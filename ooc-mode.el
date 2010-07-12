;;; ooc-mode.el ---
;;
;; Filename: ooc-mode.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Sat May 29 20:34:29 2010 (-0400)
;; Version: 0.1
;; Last-Updated:
;;           By:
;;     Update #: 92
;; URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change log:
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:
(require 'cc-mode)
(eval-when-compile
  (require 'cc-langs)
  (require 'cc-fonts)
  (require 'cl)
  (c-add-language 'ooc-mode 'c-mode))

(defgroup ooc nil
  "Settings for ooc-mode.")

(defgroup ooc-project nil
  "Project settings for ooc-mode.")

(defgroup flymake-ooc nil
  "Flymake for ooc."
  :group 'flymake
  :group 'ooc)

(defcustom ooc-library-path (or (getenv "OOC_LIBS") "/usr/lib/ooc/")
  "Location of ooc-libraries.

If the environment variable OOC_LIBS is set, the value of that is
used, otherwise we default to /usr/lib/ooc/."
  :group 'ooc
  :type 'directory)

(defcustom ooc-projects nil
  "Paths to project rood directories."
  :group 'ooc-project
  :type '(repeat (list :tag "Project"
                       (string :tag "Name")
                       (directory :tag "Root")
                       (repeat :tag "Rock Options"
                               (string :tag "Option")))))

(defun* ooc-find-root-project
    (&optional (directory (buffer-file-name (current-buffer))))
  "Return first applicable project for the given directory."
  (loop for project in ooc-projects
        when (destructuring-bind (name path &rest remaining) project
                  (search (file-truename path) directory
                          :end2 (length (file-truename path))))
        return project))

(defun ooc-kill-line-and-spaces (&optional arg)
  "Kill and remove any spaces following point."
  (interactive "P")
  (kill-line arg)
  (fixup-whitespace))

(defconst ooc-syntax-identifier-regex
  "\\<[a-zA-Z_][0-9a-zA-Z_]*[\\\!\\\?]?\\>"
  "Regexp matching valid ooc identifiers.

These cover classes, functions, templates, and variables.")

(defconst ooc-font-lock-keywords-1 (c-lang-const c-matchers-1 ooc))

(defun ooc-look-for-lambda-list-end ()
  (let ((p (point)))
    (prog1 (search-forward ")")
      (search-backward "("))))

(progn
  (c-lang-defconst c-matchers-3
    ooc (append
                                       ;;(c-lang-const c-matchers-3)
         (list
          (cons (concat "\\<"
                        (regexp-opt '("class" "cover" "func" "abstract" "from" "this"
                                      "super" "const" "static" "include"
                                      "import" "break" "continue" "fallthrough"
                                      "implement" "override" "if" "else" "for" "while"
                                      "do" "switch" "case" "version" "return" "ctype"
                                      "typedef" "use" "extends" "enum"
                                      "as" "in" "match" "implements"
                                      "interface"
                                      ) t)
                        "\\>")
                'font-lock-keyword-face)
          (cons (concat "\\<" (regexp-opt '("true" "false" "null") t) "\\>")
                'font-lock-constant-face)
          ;; handle the func type
          `(,(concat "\\<Func\\> (\\(" ooc-syntax-identifier-regex "\\)<")
            1 font-lock-type-face)
          `(,(concat "\\<func\\> *\\(~" ooc-syntax-identifier-regex "\\)? *(")
            (0 nil)
            ;; Mark anything following a : as a type.
            (,(concat ooc-syntax-identifier-regex ": *\\("
                      ooc-syntax-identifier-regex "\\)")
             (let ((p (point)))
               (prog1 (search-forward-regexp ")\\|$")
                 (search-backward "("))) nil (1 font-lock-type-face))
            ;; Mark generics as a type.
            (,(concat "\\(" ooc-syntax-identifier-regex "\\)>")
             (let ((p (point)))
               (prog1 (search-forward-regexp ")\\|$")
                 (search-backward "("))) nil (1 font-lock-type-face))


            ;; Mark signle words not yet highlighted as variables
            (,(concat "\\(" ooc-syntax-identifier-regex "\\)")
             (let ((p (point)))
               (prog1 (search-forward ")")
                 (search-backward "("))) nil (1 font-lock-variable-name-face)))

          ;; naive approach, treat |....| as a variable
          '("|[0-9a-zA-Z_\\!\\? ,]*|" (0 nil)
            ("\\<\\([a-zA-Z_][0-9a-zA-Z_]*[\\\!\\\?]?\\)\\>"
             (search-backward "|" nil nil 2) nil (1 font-lock-variable-name-face)))

          '("\\\([a-zA-Z_][0-9a-zA-Z_]*[\\\!\\\?]?\\\) *:=" 1 font-lock-variable-name-face)

                                        ; (print (format "a"))
          ;; variable declarations, start of line

          '("\\\([a-zA-Z_][0-9a-zA-Z_]*[\\\!\\\?]?\\\):" (1 font-lock-function-name-face))
          '("\\\(\(\\\|->\\\|:=?\\\)\\\s*\\\([A-Z][0-9a-zA-Z_]*[\\\!\\\?]?\\\)" 2 font-lock-type-face)
          '("\\b[A-Z_][0-9a-zA-Z_]*" 0 font-lock-type-face))))
  (defconst ooc-font-lock-keywords-2 (c-lang-const c-matchers-2 ooc))
  (defconst ooc-font-lock-keywords-3 (c-lang-const c-matchers-3 ooc)))

;; Lets make all EOL markers equivalent to ';' This variable could have
;; been named _something_ better... its not asm here
(c-lang-defconst c-at-vsemi-p-fn
  ooc (lambda (&optional pos) t))

(defcustom ooc-mode-hook nil
  "Hook to be called after `ooc-mode' is called."
  :type 'hook
  :group 'ooc)

(defvar ooc-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-k") 'ooc-kill-line-and-spaces)
    (define-key map (kbd "C-c C-r") 'ooc-run-single-file)
    map))
;(defvar ooc-mode-map nil "Keymap for `ooc-mode'.")

(defun ooc-mode-make-syntax-table ()
  (let ((table (make-syntax-table c-mode-syntax-table)))
    (modify-syntax-entry ?! "_" table)
    (modify-syntax-entry ?? "_" table)
    table))

(c-add-style "ooc"
             '((c-basic-offset . 4)
               (c-offsets-alist . ((statement-block-intro . +)
                                   (label . 4)
                                   (case-label . 4)
                                   ;; Terrible hack to at least close the
                                   ;; defun on the right position.
                                   (defun-close . [0])
                                   ;; TODO: This needs indent to [19] if
                                   ;; it is not an anonymous function
                                   ;; embedded in an arglist. We can tell
                                   ;; this by looking for |...| just after
                                   ;; a ',' char.
                                   (arglist-cont-nonempty . +)
                                   (arglist-close . 0)))))

(defvar ooc-mode-syntax-table (ooc-mode-make-syntax-table)
  "Syntax table for `ooc-mode'.")

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.ooc\\'" . ooc-mode))

(defun ooc-font-lock-syntactic-face-function (state)
  (let* ((start-pos (nth 8 state))
         (look-end-pos (if (< (buffer-end 1) (+ 3 start-pos))
                           (buffer-end 1)
                         (+ 3 start-pos)))
         (comment-start-chars (buffer-substring start-pos look-end-pos)))
    (cond
     ((string= comment-start-chars "///") 'font-lock-doc-face)
     ((string= comment-start-chars "/**") 'font-lock-doc-face)
     (t (if (nth 3 state) font-lock-string-face font-lock-comment-face)))))

(defun ooc-last-line-import-statement-p ()
  ;; Semi fix to the issue, We need to make sure that other toplevel
  ;; statements like comments or strings don't happen to confuse us about
  ;; statement-cont status.
  (looking-back "import.*[\n\s]*\n.*" (- (point) 200)))

(defun ooc-syntax-in-oneline-conditional-p ()
  (looking-back "\\(if\s*(.*)\\|else\\)\s*\n+.*" (- (point) 200)))

(defun ooc-syntax-in-match/case-case-p ()
  (looking-back "case\s*[^=\n]*\s*=>\s*\n.*" (- (point) 200)))

(defun* ooc-backwards-string-indent-level (string &optional (point (point))
                                                  (limit 200))
  (save-excursion
    (save-match-data
      (- (search-backward string (- point limit))
         (line-beginning-position)))))

(defun ooc-indent-line (&optional syntax quiet ignore-point-pos)
  (cond
   ((ooc-last-line-import-statement-p)
    (c-indent-line (or syntax '((topmost-intro)))
                   quiet ignore-point-pos))
   ((ooc-syntax-in-oneline-conditional-p)
    (c-indent-line (or syntax '((statement-block-intro)))
                   quiet ignore-point-pos))
   ((ooc-syntax-in-match/case-case-p)
    (c-indent-line (or syntax
                       `((brace-list-intro
                          ,(+ (line-beginning-position)
                              (ooc-backwards-string-indent-level "case")))))
                   quiet ignore-point-pos))
   (t (c-indent-line syntax quiet ignore-point-pos))))

;;;###autoload
(defun ooc-mode ()
  "Major mode for editing ooc files."
  (interactive)
  (kill-all-local-variables)
  ;; Setup environment things
  (setq major-mode 'ooc-mode)
  (setq mode-name "ooc")
  (set (make-local-variable 'font-lock-syntactic-face-function)
       'ooc-font-lock-syntactic-face-function)

  (c-initialize-cc-mode t)
  (set-syntax-table ooc-mode-syntax-table)
  (use-local-map ooc-mode-map)
                                        ;  (put 'ooc-mode 'c-mode-prefix "ooc-")
  (c-init-language-vars ooc-mode)
  (c-common-init 'ooc-mode)
  ;; Might be some c-mode way to do this....
  (set (make-local-variable 'indent-line-function)
       'ooc-indent-line)
  (c-set-style "ooc")
  (run-hooks 'c-mode-common-hook)
  (run-hooks 'ooc-mode-hook)
  (c-update-modeline))


;;;###autoload
(defun reload-all-ooc-libraries ()
  "Reload all related ooc libraries.

This is a development helper function and assumes all the related
libraries are in `load-path'."
  (interactive)
  (load-library "ooc-mode")
  (load-library "flymake-ooc")
  (load-library "ooc-usefile-mode"))

(defun ooc-reindent-buffer ()
  "Reindent the current buffer using smart ooc indention."
  (interactive)
  (indent-region (buffer-end -1) (buffer-end 1)))

;; run a program
(defcustom flymake-ooc-rock-binary "rock"
  "DEPRECIATED! Location of the rock compiler executable.

Please use `ooc-rock-binary'."
  :group 'flymake-ooc
  :type 'string)

(defcustom ooc-rock-binary flymake-ooc-rock-binary
  "Location of the rock compiler executable."
  :group 'ooc
  :type 'string)

(defcustom flymake-ooc-rock-command-line-options '("-onlycheck")
  "Commandline options to pass to rock while running flymake.

There are two new rock options added in the 0.9.2 prerelease
-onlyparse and -onlycheck but these will not be used by this mode
until they are released. Feel free to customize this variable to
use them now if you are using the git version of rock."
  :group 'flymake-ooc
  :type '(repeat (string)))

(defun ooc-run-single-file ()
  "Run file in current buffer."
  (interactive)
  (let ((file (file-name-nondirectory (buffer-file-name (current-buffer)))))
    (with-current-buffer (get-buffer-create "*ooc rock output*")
      (erase-buffer)
      (insert (shell-command-to-string (concat ooc-rock-binary " -r " file)))
      (delete-file (file-name-sans-extension file))
      (pop-to-buffer "*ooc rock output*"))))

(provide 'ooc-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ooc-mode.el ends here
