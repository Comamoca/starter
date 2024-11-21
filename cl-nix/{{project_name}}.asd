(defsystem "{{project_name}}"
  :class :package-inferred-system
  :author "{{author}}"
  :build-pathname #.(or (uiop:getenv "CL_BUILD_PATHNAME") "{{project_name}}")
  :depends-on(:{{project_name}}/src/{{project_name}})
  :build-operation "program-op"
  :entry-point "{{project_name}}/src/{{project_name}}:main"
  :in-order-to ((test-op (test-op "{{project_name}}/test"))))

(defsystem "{{project_name}}/test"
  :author "{{author}}"
  :depends-on ("{{project_name}}/test/main" "rove")
  :class :package-inferred-system
  :perform (test-op (op c)
             (symbol-call :rove :run c)))
