(defpackage :{{project_name}}/test/main
  (:use :cl
        :rove
        :{{project_name}}/src/sub)
  (:shadowing-import-from :rove
                          :*debug-on-error*))
(in-package :{{project_name}}/test/main)

(deftest example-test
  (ok (= 1 1)))

(deftest sub-add-test
  (ok (= 2 (add 1 1))))

(deftest fail-test
  (ok (= 100 1)))
