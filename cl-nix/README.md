<div align="center">

<img src="https://emoji2svg.deno.dev/api/🦊" alt="eyecatch" height="100">

# cl-nix

Modern Common Lisp project template using Nix

<br>
<br>


</div>

<div align="center">

</div>

## 🚀 How to use

This project uses [kickstart](https://github.com/Keats/kickstart).
You need to install kickstart to use the template.

If you want to use the this template, run the following command.
Since kickstart extracts files to the current directory by default, we specify the output to the `hello` directory with the `-o` option.

```sh
kickstart https://github.com/comamoca/starter -s cl-nix -o hello
```

## ⛏️   Development

```sh
# Into devshell
nix develop

# Launch slynk server
nix run .#slynk

# Build program
nix build

# Run program
nix run

# run test
nix run .#test
```
## 🧩 Modules

- [rove](https://github.com/fukamachi/rove)
- [arrow-macros](https://github.com/hipeta/arrow-macros)
- [sly](https://github.com/joaotavora/sly)
- [flake-parts](https://flake.parts)

## 💡 Tips

### Run the test manually
Synonymous with `(rove:run :mypkg)`.

```lisp 
(asdf:test-system :mypkg)
```

## 👏 Affected projects

- [cl-project](https://github.com/fukamachi/cl-project)
