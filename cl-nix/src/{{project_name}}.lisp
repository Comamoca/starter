(uiop:define-package :{{project_name}}/src/{{project_name}}
  (:nicknames)
  (:use :cl :{{project_name}}/src/sub) 
  (:export :main))

(in-package :{{project_name}}/src/{{project_name}})

(defun main ()
  (format t "Hello!~%1 + 2 = ~a~%" (add 1 2)))
