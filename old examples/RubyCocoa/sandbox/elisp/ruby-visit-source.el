(defun ruby-visit-source ()
  "If the current line contains text like '../src/program.rb:34', visit 
that file in the other window and position point on that line."
  (interactive)
  (let* ((start-boundary (save-excursion (beginning-of-line) (point)))
         (regexp (concat "\\([ \t\n\r\"'([<{]\\|^\\)" ; non file chars or
                                                      ; effective
                                                      ; beginning of file  
                         "\\(.+\\.rb\\):\\([0-9]+\\)")) ; file.rb:NNN
         (matchp (save-excursion
                  (end-of-line)
                  ;; if two matches on line, the second is most likely
                  ;; to be useful, so search backward.
                  (re-search-backward regexp start-boundary t))))
    (cond (matchp
           (let ((file (buffer-substring (match-beginning 2)
                                         (match-end 2))) 
                 (line (buffer-substring (match-beginning 3)
                                         (match-end 3))))
             ; Windows: Find-file doesn't seem to work with Cygwin
             ; //<drive>/ format or the odd /cygdrive/<drive>/ format 
             (if (or (string-match "//\\(.\\)\\(.*\\)" file)
                     (string-match "/cygdrive/\\(.\\)\\(.*\\)" file))
                 (setq file
                       (concat (substring file
                                          (match-beginning 1)
                                          (match-end 1))
                               ":"
                               (substring file
                                          (match-beginning 2)
                                          (match-end 2)))))
                             
             (find-file-other-window file)
             (goto-line (string-to-int line))))
          (t
           (error "No ruby location on line.")))))

;; I bind the above to ^h^h, an odd choice, because that's easy to
;; type after reaching the line with ^p or ^n.
(global-set-key "\^h\^h" 'ruby-visit-source)    

