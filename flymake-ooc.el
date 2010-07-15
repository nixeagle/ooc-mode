;;; flymake-ooc.el ---
;;
;; Filename: flymake-ooc.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Wed Jun 23 21:34:45 2010 (+0000)
;; Version: 1.0
;; Last-Updated:
;;           By:
;;     Update #: 25
;; URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;; This is real simple for now, just (require 'flymake-ooc)
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
(require 'flymake)
(require 'ooc-mode)






(defun flymake-ooc-get-command-line-options ()
  (let ((project (ooc-find-root-project)))
    (if project
        (destructuring-bind (name path command-opts &rest remaining) project
          (mapcar (lambda (option)
                    (flymake-ooc-make-absolute-path-option option (file-truename path))) (append command-opts flymake-ooc-rock-command-line-options)))
      flymake-ooc-rock-command-line-options)))




(defun flymake-ooc-find-sourcepaths (project)
  (destructuring-bind (name path command-opts &rest remaining) project

   (mapcan (lambda (option)
             (if (search "-sourcepath=" option)
                 (list (expand-file-name (substring option (length "-sourcepath="))
                                         path))))
           command-opts)))

(defun flymake-ooc-file-relative-path (project file)
  (or (and project
           (loop for path in (flymake-ooc-find-sourcepaths project)
                 when (search path (file-truename file))
                 return (file-relative-name file path)))
      (file-relative-name file
                          (file-name-directory file))))

(defun flymake-ooc-make-absolute-path-option (option root)
  ;; Mostly a hack for oos issues with sourcepath. This can be updated to
  ;; make any rock option absolute instead of relative.
  (if (search "-sourcepath=" option)
      (concat "-sourcepath="
              (expand-file-name (substring option (length "-sourcepath="))
                                root))
    option))
(defun flymake-ooc-init ()
  (append (list flymake-ooc-rock-binary
                (append (flymake-ooc-get-command-line-options)
                        (list
                         (flymake-ooc-file-relative-path
                          (ooc-find-root-project)
                          (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace)))))))

(add-to-list 'flymake-allowed-file-name-masks
             '(".+\\.ooc$" flymake-ooc-init))

(add-to-list 'flymake-err-line-patterns
             '("^\\(.*\\):\\([0-9]+\\):\\([0-9]+\\) \\[[^\]]+\\] \\(.*\\)" 1 2 3 4))

(defun enable-flymake-ooc-mode ()
  "Turn flymake-ooc on no matter what."
  (flymake-mode 1))

(custom-add-frequent-value 'ooc-mode-hook 'enable-flymake-ooc-mode)

;;;###autoload
(defun flymake-ooc-mode ()
  (interactive)
  (flymake-mode))

(provide 'flymake-ooc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; flymake-ooc.el ends here
