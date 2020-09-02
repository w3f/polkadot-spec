(texmacs-module (polkadot compare)
  (:use (generic document-part) (version version-compare)))

;; This is a custom compare function with the major difference
;; being that this also highlights differences in included files.
(tm-define (compare-versions-expanded old new)
  (load-buffer old)
  (buffer-expand-includes)
  (with t1 (buffer-tree)
    (load-buffer new)
    (buffer-expand-includes)
    (let* ((t2 (buffer-tree))
           (u1 (tree->stree t1))
           (u2 (tree->stree t2))
           (x1 (if (tm-is? u1 'with) (cAr u1) u1))
           (mv (compare-versions x1 u2))
           (rt (stree->tree mv)))
      (tree-set (buffer-tree) rt)
      (version-first-difference))))
