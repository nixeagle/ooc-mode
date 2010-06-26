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
;;     Update #: 13
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

(defgroup flymake-ooc nil
  "Flymake for ooc."
  :group 'flymake
  :group 'ooc)
(defcustom flymake-ooc-rock-binary "rock"
  "Location of the rock compiler executable."
  :group 'flymake-ooc
  :type 'string)

(defcustom flymake-ooc-rock-command-line-options '("-onlygen")
  "Commandline options to pass to rock while running flymake.

There are two new rock options added in the 0.9.2 prerelease
-onlyparse and -onlycheck but these will not be used by this mode
until they are released. Feel free to customize this variable to
use them now if you are using the git version of rock."
  :group 'flymake-ooc
  :type '(repeat (string)))

(defun flymake-ooc-init ()
  (list flymake-ooc-rock-binary
        (append flymake-ooc-rock-command-line-options
                (list
                 (file-relative-name
                  (flymake-init-create-temp-buffer-copy
                   'flymake-create-temp-inplace)
                  (file-name-directory buffer-file-name))))))

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
