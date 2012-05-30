;;; ooc-mode.el --- ???
;;
;; Filename: ooc-mode.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Sat May 29 20:34:29 2010 (-0400)
;; Version: 0.1
;; Last-Updated:
;;           By:
;;     Update #: 155
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
(when (and (< emacs-major-version 23)
           (< emacs-minor-version 2))
  (error "ooc mode requires GNU Emacs version 23.2 or later."))

(require 'cc-mode)
(eval-when-compile
  (require 'cc-langs)
  (require 'cc-fonts)
  (require 'cl)
  (c-add-language 'ooc-mode 'c-mode))

(require 'semantic)
(require 'cedet)

(require 'ooc-wisent-wy)

;; Ugly fix to shut this annoying errors because of a depreciation
;; function being fed 3 arguments instead of 2.
;;
;; This is from mode-local.el of cedet 1.0pre7
;;  [2010-07-15 Thu 03:49]
(defun make-obsolete-overload (old new &optional version)
  "Mark OLD overload as obsoleted by NEW overload.

The optional VERSION argument here is just to shutup errors from
code passing version numbers. (Bugfix)."
  (put old 'overload-obsoleted-by new)
  (put old 'mode-local-overload t)
  (put new 'overload-obsolete old))

;; More silliness, this time from semantic/fw.el
;;   [2010-07-15 Thu 03:57]
(defun semantic-varalias-obsolete (oldvaralias newvar &optional when)
  "Make OLDVARALIAS an alias for variable NEWVAR.
Mark OLDVARALIAS as obsolete, such that the byte compiler
will throw a warning WHEN it encounters this symbol."
  (make-obsolete-variable oldvaralias newvar (or when "23.2"))
  (condition-case nil
      (defvaralias oldvaralias newvar)
    (error
     ;; Only throw this warning when byte compiling things.
     (when (and (boundp 'byte-compile-current-file)
                byte-compile-current-file)
       (semantic-compile-warn
        "variable `%s' obsoletes, but isn't alias of `%s'"
        newvar oldvaralias)))))

;; And more from semantic/fw.el!
(defun semantic-alias-obsolete (oldfnalias newfn &optional when)
  "Make OLDFNALIAS an alias for NEWFN.
Mark OLDFNALIAS as obsolete, such that the byte compiler
will throw a warning WHEN it encounters this symbol."
  (defalias oldfnalias newfn)
  (let ((when "23.2"))
    (make-obsolete oldfnalias newfn when)
    (when (and (function-overload-p newfn)
               (not (overload-obsoleted-by newfn))
               ;; Only throw this warning when byte compiling things.
               (boundp 'byte-compile-current-file)
               byte-compile-current-file
               (not (string-match "cedet" byte-compile-current-file)))
      (make-obsolete-overload oldfnalias newfn when)
      (semantic-compile-warn
       "%s: `%s' obsoletes overload `%s'"
       byte-compile-current-file
       newfn
       (semantic-overload-symbol-from-function oldfnalias)))))

;(require 'semantic/decorate/include nil t)
(or (require 'semantic-decorate-include nil t)
    (require 'semantic/decorate/include nil t))

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
  "Paths to project root directories."
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
  "\\<[a-zA-Z_][0-9a-zA-Z_]*[\\\!\\\?]?"
  "Regexp matching valid ooc identifiers.

These cover classes, functions, templates, and variables.")

(defconst ooc-font-lock-keywords-1 (c-lang-const c-matchers-1 ooc))

(defun ooc-look-for-lambda-list-end ()
  (let ((p (point)))
    (prog1 (search-forward ")")
      (search-backward "("))))
(defun ooc-highlight-variable-declarations-matcher (limit)
  "Match next variable declaration without matching past a : or LIMIT."
  (let ((.point (point)))
    (let ((.search (search-forward ":" (1+ limit) t)))
      (when .search
        (let ((limit (point)))
          (goto-char .point)
          (re-search-forward (concat "\\(" ooc-syntax-identifier-regex "\\)"
                                     "[, :$]")
                             limit t))))))
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
                                      "interface" "proto" "extern"
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


            ;; Mark single words not yet highlighted as variables
            (,(concat "\\(" ooc-syntax-identifier-regex "\\)")
             (let ((p (point)))
               (prog1 (search-forward ")")
                 (search-backward "("))) nil (1 font-lock-variable-name-face)))

          ;;naive approach, treat |....| as a variable
          '("|[0-9a-zA-Z_\\!\\? ,]+|" (0 nil)
            ("\\<\\([a-zA-Z_][0-9a-zA-Z_]*[\\\!\\\?]?\\)\\>"
             (search-backward "|" nil nil 2) nil (1 font-lock-variable-name-face)))

          '("\\\([a-zA-Z_][0-9a-zA-Z_]*[\\\!\\\?]?\\\) *:=" 1 font-lock-variable-name-face)

                                        ; (print (format "a"))
          ;; variable declarations, start of line

          '("\\\([a-zA-Z_][0-9a-zA-Z_]*[\\\!\\\?]?\\\):\s*\\(static\s*\\)?func" (1 font-lock-function-name-face))
          '("\\\([a-zA-Z_][0-9a-zA-Z_]*[\\\!\\\?]?\\\):\s*\\(?:class\\|cover\\)" (1 font-lock-type-face))

          '("\\\(\(\\\|->\\\|:=?\\\)\\\s*\\\([A-Z][0-9a-zA-Z_]*[\\\!\\\?]?\\\)" 2 font-lock-type-face)
          '("\\(?:[ ,]\\|^\\)\\\([a-zA-Z_][0-9a-zA-Z_]*[\\\!\\\?]?\\\):" (0 nil)
             (ooc-highlight-variable-declarations-matcher (beginning-of-line) nil (1 font-lock-variable-name-face)))
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



(defun ooc-make-mode-map ()
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-k") 'ooc-kill-line-and-spaces)
    (define-key map (kbd "C-c C-r") 'ooc-run-single-file)
    (define-key map (kbd "}")
      (lambda ()
        (interactive)
        (insert "}")
        (funcall indent-line-function)))
    map))

(defvar ooc-mode-map (ooc-make-mode-map))

(defun ooc-reset-mode-map ()
  (interactive)
  (setq ooc-mode-map (ooc-make-mode-map)))
;(defvar ooc-mode-map nil "Keymap for `ooc-mode'.")

(defun ooc-mode-make-syntax-table ()
  (let ((table (make-syntax-table c-mode-syntax-table)))
    (modify-syntax-entry ?! "_" table)
    (modify-syntax-entry ?? "_" table)
    table))

(c-add-style "ooc"
             '((c-basic-offset . 4)
               (c-offsets-alist
                .
                ((label . 4)
                 (case-label . 4)
                 (statement-cont . c-lineup-topmost-intro-cont)
                 ;; Terrible hack to at least close the
                 ;; defun on the right position.
                 (defun-close . [0])
                 ;; TODO: This needs indent to [19] if
                 ;; it is not an anonymous function
                 ;; embedded in an arglist. We can tell
                 ;; this by looking for |...| just after
                 ;; a ',' char.
                 (arglist-cont-nonempty . +)
                 (brace-list-entry . (first ooc-lineup-multiline-case-statement
                                            ooc-lineup-oneline-if-statement
                                            0))
                 (topmost-intro .
                                (first ooc-lineup-oneline-if-statement
                                       ooc-lineup-oneline-else-statement
                                       0))
                 (else-clause . (first ooc-lineup-oneline-else-clause
                                       0))
                 (statement . (first ooc-lineup-oneline-if-statement
                                     0))
                 (arglist-close . 0)))))

(defun ooc-lineup-multiline-case-statement (langelem)
  (save-excursion
    (when (looking-back "case.*=>[^{}]+")
      '+)))
(defun ooc-lineup-oneline-if-statement (langelem)
  (save-excursion
    (when (looking-back "if\s*([^)]*)\s*\n.*")
      '+)))

(defun ooc-lineup-oneline-else-statement (langelem)
  (save-excursion
    (cond
     ((looking-back "else\s*\n.*") '+)
     ((save-excursion
        ;; Go back a level if last anchor is for a oneline else statement.
        (goto-char (c-langelem-pos langelem))
        (looking-back "else\s*\n.*")) '-))))

(defun ooc-lineup-oneline-else-clause (langelem)
  (save-excursion
    (beginning-of-line)
    (when (looking-at-p "\s*else\s*$")
      '-)))
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

(defun ooc-syntax-in-match/case-case-p ()
  (let ((.point (point)))
    (beginning-of-line)
    (let ((.current-bol (point)))
      (beginning-of-line 0)
      (prog1
          (and (not (equal (point) .current-bol)) ; nil if on top line
               (search-forward "case" .current-bol t) ; |case| <blah> => \n ...
               (search-forward "=>" .current-bol t)) ; case <blah> |=>| \n ...
        (goto-char .point)))))


(defun* ooc-backwards-string-indent-level (string &optional (point (point))
                                                  (limit 200))
  (save-excursion
    (save-match-data
      (- (search-backward-regexp string (- point limit))
         (line-beginning-position)))))

(defun ooc-indent-line (&optional syntax quiet ignore-point-pos)
  (cond
   ((ooc-syntax-in-match/case-case-p)
    (c-indent-line (or syntax
                       `((brace-list-intro
                          ,(+ (line-beginning-position)
                              (ooc-backwards-string-indent-level "case")))))
                   quiet ignore-point-pos))
   (t (c-indent-line syntax quiet ignore-point-pos))))


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

(defcustom ooc-rock-binary nil
  "Location of the rock compiler executable."
  :group 'ooc
  :type '(choice (const :tag "Same location as rock dist" nil)
                 (string :tag "Alternate global binary")))

(defcustom flymake-ooc-rock-command-line-options '("-onlycheck")
  "Commandline options to pass to rock while running flymake.

There are two new rock options added in the 0.9.2 prerelease
-onlyparse and -onlycheck but these will not be used by this mode
until they are released. Feel free to customize this variable to
use them now if you are using the git version of rock."
  :group 'flymake-ooc
  :type '(repeat (string)))

(defcustom ooc-rock-dist "~/rock"
  "Location of the rock distribution.

This will define the default location of rock as well as the
default location of the rock sdk."
  :group 'ooc
  :type 'directory)

(defcustom ooc-rock-sdk nil
  "Location of the rock sdk if seperate from `ooc-rock-dist'."
  :group 'ooc
  :type '(choice (const :tag "Same location as rock dist" nil)
                 (directory :tag "Alternate global sdk directory.")))

(defun ooc-run-single-file ()
  "Run file in current buffer."
  (interactive)
  (let ((file (file-name-nondirectory (buffer-file-name (current-buffer)))))
    (with-current-buffer (get-buffer-create "*ooc rock output*")
      (erase-buffer)
      (insert (shell-command-to-string (concat ooc-rock-binary " -r " file)))
      (delete-file (file-name-sans-extension file))
      (pop-to-buffer "*ooc rock output*"))))
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
  (set (make-local-variable 'semantic-lex-analyzer)
       'ooc-lexer)
  (setq semantic-lex-syntax-table ooc-mode-syntax-table)
  (ooc-wisent-wy--install-parser)
  (semantic-new-buffer-fcn)
  (semantic-decoration-mode)
  (c-set-style "ooc")
  (run-hooks 'c-mode-common-hook)
  (run-hooks 'ooc-mode-hook)
  (c-update-modeline))


(defun ooc-rock-binary ()
  "Return location of rock's binary."
  (or ooc-rock-binary
      (expand-file-name "bin/rock" ooc-rock-dist)))

(defun ooc-rock-sdk-path (&optional project-path)
  "Return location of rock's sdk path or PROJECT-PATH."
  (or project-path ooc-rock-sdk
      (expand-file-name "sdk" ooc-rock-dist)))

(defun ooc-project-find-sourcepaths (project)
  (if project
      (destructuring-bind (name path command-opts &rest remaining) project

        (or (cons default-directory
                  (mapcan (lambda (option)
                            (if (search "-sourcepath=" option)
                                (list (expand-file-name (substring option (length "-sourcepath="))
                                                        path))))
                          command-opts))
            (list default-directory)))
    (list default-directory)))

;; Semantic overloads
(define-mode-local-override semantic-dependency-tag-file
  ooc-mode (&optional tag)
  "Finds file represented by TAG."
  (let ((tag (or tag (car (semantic-find-tag-by-overlay nil)))))
    (unless (semantic-tag-of-class-p tag 'include)
      (signal 'wrong-type-argument (list tag 'include)))
    (loop for paths in (append (list (ooc-rock-sdk-path))
                               (ooc-project-find-sourcepaths
                                (ooc-find-root-project)))
          when (file-exists-p
                (expand-file-name (concat (semantic-tag-include-filename tag) ".ooc")
                                  paths))
          return (expand-file-name (concat (semantic-tag-include-filename tag) ".ooc")
                                  paths))))

(defun ooc-format-configuration-option-output (option &optional notes)
  (if notes
      (insert (format "%-25s= %s\n    %s\n" option (symbol-value option)
                      notes))
    (insert (format "%-25s= %s\n" option (symbol-value option)))))

(defun ooc-print-configuration-options ()
  "Print out interesting `ooc-mode' options for bug reports."
  (interactive)
  (with-current-buffer (get-buffer-create "*ooc-important-config-options*")
    (erase-buffer)
    (flet ((o (option &optional notes)
              (ooc-format-configuration-option-output option notes)))
      (o 'ooc-rock-dist)
      (o 'ooc-rock-sdk)
      (o 'ooc-rock-binary
         (format "If rock is at %s/bin/rock please leave this nil."
                 ooc-rock-dist))
      (o 'flymake-ooc-rock-command-line-options
         "DEPRECIATED, use `ooc-rock-dist' or `ooc-rock-binary'!")
      (insert "\n\n== ooc-projects==\n\n"
              (format "%s" ooc-projects))))
  (pop-to-buffer "*ooc-important-config-options*" nil t))

(defun* nix.lex-test (&optional (buffer (current-buffer)))
  (interactive)
  (with-current-buffer (get-buffer-create "*wisent-log*")
    (erase-buffer))
  (with-current-buffer (get-buffer-create "*Messages*")
    (erase-buffer))
  (with-current-buffer "ooc-wisent.wy"
    (semantic-grammar-create-package))
  (with-current-buffer buffer
    (setq semantic-lex-syntax-table ooc-mode-syntax-table)
    (ooc-wisent-wy--install-parser)
    (set (make-local-variable 'wisent-discarding-token-functions)
       (list (lambda (token)
               (print token))))
                                        ;(erase-buffer)
 ;;   (ooc-mode)
                                        ;(insert .string)
    (let ((.lex (semantic-lex 0 (buffer-end 1) 1)))
      (with-current-buffer (get-buffer-create "*Lexer Output*")
        (erase-buffer)
        (insert (format "%S" .lex))))
    (bovinate 1)


    )
  (switch-to-buffer buffer t)
  (other-window 1)
  (switch-to-buffer "*Parser Output*" t)
  (other-window -1))

(provide 'ooc-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ooc-mode.el ends here
