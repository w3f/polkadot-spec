(defun generate-test-trie-yaml (trie-filename)
  (find-file trie-filename)
  (let ((number-of-nodes 10000)
         (value))
     (insert "keys:\n")
     (dotimes (number number-of-nodes value)
       (insert (concat "  - " (format "%016x" (random)) "\n")))
     (insert "values:\n")
     (dotimes (number number-of-nodes value)
       (insert (concat "  - " (format "%016x" (random)) "\n")))))

(generate-test-trie-yaml "/tmp/10000-node-trie.yaml")

(format "%016x" 123)
