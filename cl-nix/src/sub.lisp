(uiop:define-package :{{project_name}}/src/sub
  (:use :cl)
  (:export :add))
(in-package :{{project_name}}/src/sub)

(defun add (a b)
  (+ a b))
