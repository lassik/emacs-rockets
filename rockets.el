(defun rockets--vector-to-list (vector)
  (map 'list #'identity vector))

(defun rockets--get-launches ()
  "Acquire rocket launches."
  (let* ((url-mime-accept-string "application/json")
         (url-show-status nil))
    (with-temp-buffer
      (url-insert-file-contents "https://launchlibrary.net/1.4/launch")
      (json-read))))

(defun rockets ()
  (interactive)
  (switch-to-buffer (get-buffer-create "*Rockets*"))
  (assert (null (buffer-file-name)))
  (let ((data (rockets--get-launches)))
    (erase-buffer)
    (dolist (launch (rockets--vector-to-list (cdr (assoc 'launches data))))
      (let ((name (cdr (assoc 'name launch)))
            (time (cdr (assoc 'windowstart launch))))
        (insert (format "%s\n%s\n\n" time name))))))
