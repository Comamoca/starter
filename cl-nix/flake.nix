{
  description = "A basic flake to with flake-parts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{
      self,
      systems,
      nixpkgs,
      treefmt-nix,
      flake-parts,
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ treefmt-nix.flakeModule ];
      systems = import inputs.systems;

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        let
	  name = "{{project_name}}";
          stdenv = pkgs.stdenv;

          cl-{{project_name}} = pkgs.sbcl.buildASDFSystem {
            pname = name;
            version = "0.1.0";
            src = ./.;
            systems = [
              name
              "${name}/test"
            ];

            lispLibs = with pkgs.sbcl.pkgs; [
              rove

	      # TODO: Use only in devshell.
	      slynk
            ];
          };

          sbcl' = pkgs.sbcl.withOverrides (
            self: super: {
              inherit cl-{{project_name}};
            }
          );

          lisp = sbcl'.withPackages (ps: [ ps.cl-{{project_name}} ]);

	  build-script = pkgs.writeText "build.lisp"
	  ''
	    (require :asdf)
	    (asdf:load-system :${name})

            (sb-ext:save-lisp-and-die "${name}"
	      :toplevel #'${name}/${name}:main
	      :executable t
	      :purify t
	      #+sb-core-compression :compression
              #+sb-core-compression t
	    )
	  '';

          {{project_name}} = stdenv.mkDerivation {
            pname = name;
            version = "0.0.1";
            src = ./.;
            nativeBuildInputs = [ pkgs.sbcl lisp pkgs.makeWrapper ];
	    dontStrip = true;

            buildPhase = ''
              ${lisp}/bin/sbcl --script ${build-script}
            '';

            installPhase = ''
	    install -D ${name} $out/bin/${name} 
	    '';
          };

	  test-script = pkgs.writeText "build.lisp"
	  ''
	    (require :asdf)
	    (asdf:load-system :rove)
	    ;; (asdf:load-system :${name})

	    (rove)
	  '';

          run-test = pkgs.writeShellScriptBin "run-test" ''
            ${lisp}/bin/sbcl --eval "(require :asdf)" \
	                     --eval "(asdf:test-system :{{project_name}})" \
	                     --eval "(exit)"
          '';

          run-slynk = pkgs.writeShellScriptBin "run-slynk" ''
            ${lisp}/bin/sbcl --eval "(require :asdf)" \
	                     --eval "(asdf:load-system :slynk)" \
	                     --eval "(slynk:create-server :dont-close t :style :spawn)"
          '';
        in {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
            };

            settings.formatter = { };
          };

	  apps = {
	    default = {
              type = "app";
              program = self.packages.default;
	    };

	    test = {
              type = "app";
              program = run-test;
	    };

	    slynk = {
              type = "app";
              program = run-slynk;
	    };
	  };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
	      lisp
              run-slynk

              nil
            ];

            shellHook = ''
              # Register your project to ASDF.
              # This command create directory and symlink on your $HOME.
              # If you not want to this, remove it.

              mkdir $HOME/common-lisp
              ln -s (pwd) "$HOME/common-lisp/$(basename $(pwd))"
            '';
          };

        packages.default = {{project_name}};
      };
   };
}
