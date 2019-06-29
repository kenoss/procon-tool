;;;
;;; Very simple procon helper
;;;

(defvar keu-procon:test-buffer-name
  "*procon test*")

(defvar keu-procon:test-arg
  "")

(defvar keu-procon:procon-tool-path
  "~/src/github.com/kenoss/procon-tool/bin/procon-tool")


(defun keu-procon:get-command ()
  (concat "cd ..; eval \"$(direnv export bash 2>/dev/null)\"; "
          keu-procon:procon-tool-path " test " keu-procon:test-arg))

(defun keu-procon:test-aux (&optional arg)
  (save-excursion
    (save-selected-window
      (when arg
        (setq keu-procon:test-arg arg))
      (let ((command (keu-procon:get-command))
            (buffer (get-buffer-create keu-procon:test-buffer-name)))
        (with-current-buffer buffer
          (erase-buffer))
        (when (not (get-buffer-window buffer))
          (split-window-right)
          (other-window 1)
          (set-window-buffer nil buffer))
        (call-process "bash" nil buffer t "-c" command)))))

(defun keu-procon-test ()
  (interactive)
  (keu-procon:test-aux))

(defun keu-procon-test-all ()
  (interactive)
  (keu-procon:test-aux ""))

(defun keu-procon-test-1 ()
  (interactive)
  (keu-procon:test-aux "01"))

(defun keu-procon-test-2 ()
  (interactive)
  (keu-procon:test-aux "02"))

(defun keu-procon-test-3 ()
  (interactive)
  (keu-procon:test-aux "03"))

(defun keu-procon-test-4 ()
  (interactive)
  (keu-procon:test-aux "04"))


;; (with-eval-after-load 'rust-mode
;;   (kef-define-keys rust-mode-map
;;     (("C-c C-t C-t" 'keu-procon-test)
;;      ("C-c C-t C-a" 'keu-procon-test-all)
;;      ("C-c C-t 1"   'keu-procon-test-1)
;;      ("C-c C-t 2"   'keu-procon-test-2)
;;      ("C-c C-t 3"   'keu-procon-test-3)
;;      ("C-c C-t 4"   'keu-procon-test-4)
;;      ))
;;   )

;; (with-eval-after-load 'python-mode
;;   (kef-define-keys python-mode-map
;;     (("C-c C-t C-t" 'keu-procon-test)
;;      ("C-c C-t C-a" 'keu-procon-test-all)
;;      ("C-c C-t 1"   'keu-procon-test-1)
;;      ("C-c C-t 2"   'keu-procon-test-2)
;;      ("C-c C-t 3"   'keu-procon-test-3)
;;      ("C-c C-t 4"   'keu-procon-test-4)
;;      ))
;;   )
