;;; ooc-usefile-mode.el ---
;;
;; Filename: ooc-usefile-mode.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Thu Jun 24 02:36:20 2010 (+0000)
;; Version:
;; Last-Updated:
;;           By:
;;     Update #: 1
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

(defvar ooc-usefile-mode-font-lock-keywords
  `(("^#.*$" . font-lock-comment-face)
    ("^\\([^\\#]*:\\).*"  (1 font-lock-keyword-face))

    ("^[^#].+$" . font-lock-warning-face)))

(defvar ooc-usefile-mode-font-lock-defaults
  '(ooc-usefile-mode-font-lock-keywords nil t))

(define-derived-mode ooc-usefile-mode
  text-mode "usefile"
  "Major mode for ooc usefiles
\\{ooc-usefile-mode-map}"
  (set (make-local-variable 'font-lock-defaults)
       ooc-usefile-mode-font-lock-defaults))

(provide 'ooc-usefile-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ooc-usefile-mode.el ends here
