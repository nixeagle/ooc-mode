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
;;     Update #: 7
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

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.use\\'" . ooc-usefile-mode))

(defgroup ooc-usefile nil
  "Settings for ooc usefiles."
  :group 'ooc-mode)

(defgroup ooc-usefile-faces nil
  "Faces for ooc usefiles."
  :group 'ooc-usefile)

(defgroup ooc-usefile-regexp nil
  "Regexps used in ooc usefile buffers."
  :group 'ooc-usefile)
(defgroup ooc-usefile-button nil
  "Settings for buttons in ooc usefiles."
  :group 'ooc-usefile)

(defface ooc-usefile-button '((t))
  "Usefile button face."
  :group 'ooc-usefile-faces)

(defcustom ooc-usefile-button-face 'ooc-usefile-button
  "Face for highlighting buttons in usefile buffers.

A button is a piece of text that you can activate by pressing
`RET' or `mouse-2' above it. See also
`ooc-usefile-mode-keymap'."
  :type 'face
  :group 'ooc-usefile-faces)

(defcustom ooc-usefile-button-mouse-face 'highlight
  "Face used for mouse highlighting in ooc usefile buffers.

Buttons will be displayed in this face when the mouse cursor is
above them"
  :type 'face
  :group 'ooc-usefile-faces)

(defcustom ooc-usefile-button-requires-regexp
  "\\([^\s]\\)"
  "Matches valid library names to require."
  :group 'ooc-usefile-regexp
  :group 'ooc-usefile-button
  :type 'regexp)

(defvar ooc-usefile-button-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") 'ooc-usefile-button-press-button)
    map)
  "Local keymap for ooc usefile buttons.")

(defun ooc-library-expand-file-name (filename)
  "Expand FILENAME as an ooc-library."
  (expand-file-name (concat (file-name-sans-extension filename) ".use")
                    ooc-library-path))

(defun ooc-button-add-button (from to face map)
  (add-text-properties from to `(mouse-face ,face
                                            keymap ,map
                                            rear-nonsticky t)))

;; From erc-button.el `erc-button-add-face' [2010-06-24 Thu 23:08]
(defun ooc-button-add-face (from to face)
  "Add FACE to the region between FROM and TO."
  (let ((old (if (listp (get-text-property from 'face))
                 (get-text-property from 'face)
               (list (get-text-property from 'face))))
        (pos from)
        (end (next-single-property-change from 'face nil to))
        new)
    ;; old is the face at pos, in list form.  It is nil if there is no
    ;; face at pos.  If nil, the new face is FACE.  If not nil, the
    ;; new face is a list containing FACE and the old stuff.  end is
    ;; where this face changes.
    (while (< pos to)
      (setq new (if old (cons face old) face))
      (put-text-property pos end 'face new)
      (setq pos end
            old (if (listp (get-text-property from 'face))
                 (get-text-property from 'face)
                 (list (get-text-property from 'face)))
            end (next-single-property-change pos 'face nil to)))))


(defun ooc-usefile-button-press-button ()
  "Open requires file that text at point describes."
  (interactive)
  (find-file (ooc-library-expand-file-name (symbol-name (symbol-at-point)))))

(defvar ooc-usefile-mode-font-lock-keywords
  `(("^#.*$" . font-lock-comment-face)
    ("^\\([^\\#:]*:\\)"  (1 font-lock-keyword-face))

    ("^Requires:" "[^\s]" nil
     (save-excursion
       (forward-line 0)
       (search-forward ":")
       (let ((.end (line-end-position))
         (.start (point)))
     (loop until (> (point) .end)
           for .white = (forward-whitespace 1)
           for .symbol = (forward-symbol 1)
           until (> .symbol .end)
           do (ooc-button-add-button .white .symbol
                                     ooc-usefile-button-mouse-face
                                     ooc-usefile-button-keymap))))
     (0 font-lock-variable-name-face))
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
