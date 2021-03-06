;;; package --- Summary
;;; Commentary:
;;; Code:

(require 'cl)

(defun goal!tokenize-if-bang (line)
  (let* ((exp-s (string-match "if!" line))
	 (exp-e (match-end 0))
	 (exp (substring line exp-s exp-e))

	 (var-s (string-match "[a-zA-Z_]+" line exp-e))
	 (var-e (match-end 0))
	 (var (substring line var-s var-e))
	 
	 (test-s (string-match "[a-zA-Z_.]+([^)]*)" line var-e))
	 (test-e (match-end 0))
	 (test (substring line test-s test-e))

	 (b1-s (string-match "[a-zA-Z_.]+([^)]+)" line test-e))
	 (b1-e (match-end 0))
	 (b1 (substring line b1-s b1-e))

	 (b2-s (string-match "[a-zA-Z_.]+([^)]+)" line b1-e))
	 (b2-e (match-end 0))
	 (b2 (substring line b2-s b2-e)))
    `(:if! ,var ,test ,b1 ,b2)))

(defun goal!--test--tokenize-if-bang ()
  (assert (equal '(:if! "x" "f()" "good(1, 2)" "bad(err)")
		 (goal!tokenize-if-bang "if! x f() good(1, 2) bad(err)")))
  (assert (equal '(:if! "x_y" "foo(1, 2)" "good(1, 2)" "bad(err)")
		 (goal!tokenize-if-bang "if! x_y foo(1, 2) good(1, 2) bad(err)")))
  (assert (equal '(:if! "x_y" "foo(1, 2)" "fmt.Printf(\"%d %d\", 1, 2)" "bad(err)")
		 (goal!tokenize-if-bang "if! x_y foo(1, 2) fmt.Printf(\"%d %d\", 1, 2) bad(err)"))))

(defun goal!emit-if-bang (spec)
  (destructuring-bind (expr var test b1 b2) spec
    (concatenate 'string "\tif " var ", err := " test "; err != nil {\n"
		 "\t\t" b2 "\n"
		 "\t} else {\n"
		 "\t\t" b1 "\n"
		 "\t}\n")))

(defun goal!get-current-line ()
  "Return the text of the current line as a string."
  (buffer-substring-no-properties (point-at-bol) (point-at-eol)))

(defun goal!find-if-bang ()
  (search-forward-regexp "^\t*if! " (point-max) :no-error))

(defun goal!do-if-bang ()
  (while (goal!find-if-bang)
    (let ((line (goal!get-current-line)))
      (goto-char (point-at-bol))
      (kill-line)
      (insert (goal!emit-if-bang (goal!tokenize-if-bang line))))))

(defun goal!output-file-name (src)
  (let ((offset (string-match "[^/]+.goal$" src)))
    (if offset
	(let* ((file (substring src offset))
	       (base (substring file 0 (or (string-match "\.goal$" file) 0)))
	       (dst (concatenate 'string base ".go")))
	  dst)
      (error (format "Expected a Goal! source file, got: '%s'" src)))))

(provide 'goal-if-bang)
;;; goal-if-bang.el ends here
