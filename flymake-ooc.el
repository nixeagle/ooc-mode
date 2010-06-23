;;; flymake-ooc.el ---
;;
;; Filename: flymake-ooc.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Wed Jun 23 21:34:45 2010 (+0000)
;; Version:
;; Last-Updated:
;;           By:
;;     Update #: 2
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

(defun flymake-ooc-init ()
  (list "~/lisp/rock-0.9.1-source/bin/rock"
        (list "-onlygen"
              (file-relative-name
               (flymake-init-create-temp-buffer-copy
                'flymake-create-temp-inplace)
               (file-name-directory buffer-file-name)))))

(add-to-list 'flymake-allowed-file-name-masks
             '(".+\\.ooc$" flymake-ooc-init))


(provide 'flymake-ooc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; flymake-ooc.el ends here
