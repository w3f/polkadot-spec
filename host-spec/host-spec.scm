(texmacs-module (polkadot compare)
  (:use (generic document-part) (version version-compare)))

;; This function loads the specified file and updates its toc, bibliography,
;; index and glossar. Requires a tempdir for an export which seems to be
;; necessary to make this work at all.
(tm-define (load-updated input tmpdir)
  (load-buffer input :strict)
  (buffer-export (current-buffer) (string-append tmpdir "/load-updated.export.tmp") "pdf")
  (generate-all-aux) (inclusions-gc) (update-current-buffer))

;; This is a custom compare function with the major difference
;; being that it updates all indices before the comparision
;; and also highlights differences in included files.
(tm-define (compare-versions-updated-expanded old new tmpdir)
  (load-updated old tmpdir)
  (buffer-expand-includes)
  (with t1 (buffer-tree)
    (load-updated new tmpdir)
    (buffer-expand-includes)
    (let* ((t2 (buffer-tree))
           (u1 (tree->stree t1))
           (u2 (tree->stree t2))
           (x1 (if (tm-is? u1 'with) (cAr u1) u1))
           (mv (compare-versions x1 u2))
           (rt (stree->tree mv)))
      (tree-set (buffer-tree) rt))))

;; This is a custom convert function that expands all includes
;; before conversion.
(tm-define (convert-expanded input output)
  (load-buffer input :strict)
  (buffer-expand-includes)
  (export-buffer output))

;; This is a custom convert function that updates the toc, bibliography,
;; index and glossar before conversion.
(tm-define (convert-updated input output)
  (load-buffer input :strict)
  (export-buffer output)
  (generate-all-aux) (inclusions-gc) (update-current-buffer)
  (export-buffer output))

;; This function updates/rebuilds the toc, bibliography, index and glossar
;; of the document specified and save the result in place. Requires a tempdir
;; to which it triggers a export.
(tm-define (update-all input tmpdir)
  (load-updated input tmpdir)
  (buffer-save (current-buffer)))
