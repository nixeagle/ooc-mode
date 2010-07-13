;;; ooc-wisent-wy.el --- Generated parser support file

;; Copyright (C) 2010 James

;; Author: James <i@nixeagle.org>
;; Created: 2010-07-13 03:13:53+0000
;; Keywords: syntax
;; X-RCS: $Id$

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.
;;
;; This software is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; PLEASE DO NOT MANUALLY EDIT THIS FILE!  It is automatically
;; generated from the grammar file ooc-wisent.wy.

;;; Code:

;;; Prologue
;;

;;; Declarations
;;
(defconst ooc-wisent-wy--keyword-table
  (semantic-lex-make-keyword-table
   '(("break" . BREAK_KW)
     ("continue" . CONTINUE_KW)
     ("return" . RETURN_KW)
     ("func" . FUNC_KW)
     ("class" . CLASS_KW)
     ("cover" . COVER_KW)
     ("enum" . ENUM_KW)
     ("interface" . INTERFACE_KW)
     ("from" . FROM_KW)
     ("abstract" . ABSTRACT_KW)
     ("final" . FINAL_KW)
     ("static" . STATIC_KW)
     ("inline" . INLINE_KW)
     ("extends" . EXTENDS_KW)
     ("extern" . EXTERN_KW)
     ("unmangled" . UNMANGLED_KW)
     ("implements" . IMPLEMENTS_KW)
     ("import" . IMPORT_KW)
     ("include" . INCLUDE_KW)
     ("use" . USE_KW)
     ("if" . IF_KW)
     ("else" . ELSE_KW)
     ("for" . FOR_KW)
     ("true" . WHILE_KW)
     ("match" . MATCH_KW)
     ("case" . CASE_KW)
     ("as" . AS_KW)
     ("in" . IN_KW)
     ("into" . INTO_KW)
     ("version" . VERSION_KW)
     ("proto" . PROTO_KW)
     ("set" . SET_KW)
     ("get" . GET_KW)
     ("operator" . OPERATOR_KW)
     ("const" . CONST_KW)
     ("true" . TRUE_KW)
     ("false" . FALSE_KW)
     ("null" . NULL_KW)
     ("," . COMMA)
     ("->" . R_ARROW)
     (">" . DOUBLE_ARROW)
     (":" . ASS_DECL)
     ("+" . ASS_ADD)
     ("-" . ASS_SUB)
     ("*" . ASS_MUL)
     ("/" . ASS_DIV)
     (">>" . ASS_B_RSHIFT)
     ("<<" . ASS_B_LSHIFT)
     ("^" . ASS_B_XOR)
     ("|" . ASS_B_OR)
     ("&" . ASS_B_AND)
     ("?" . QUEST)
     ("||" . L_OR)
     ("&&" . L_AND)
     ("^" . B_XOR)
     ("==" . EQUALS)
     ("!=" . NOT_EQUALS)
     ("<" . LESSTHAN)
     (">" . MORETHAN)
     ("<=>" . CMP)
     ("<=" . LESSTHAN_EQ)
     (">=" . MORETHAN_EQ)
     ("<<" . B_LSHIFT)
     (">>" . B_RSHIFT)
     (".." . DOUBLE_DOT)
     ("!" . L_NOT)
     ("~" . B_NOT)
     ("+" . PLUS)
     ("-" . MINUS)
     ("%" . PERCENT)
     ("*" . STAR)
     ("(" . OPEN_PAREN)
     (")" . CLOS_PAREN)
     ("[" . OPEN_SQUAR)
     ("]" . CLOS_SQUAR)
     ("{" . OPEN_BRACK)
     ("}" . CLOS_BRACK)
     ("@" . AT)
     ("~" . TILDE))
   'nil)
  "Table of language keywords.")

(defconst ooc-wisent-wy--token-table
  (semantic-lex-make-type-table 'nil 'nil)
  "Table of lexical tokens.")

(defconst ooc-wisent-wy--parse-table
  (progn
    (eval-when-compile
      (require 'wisent-comp))
    (wisent-compile-grammar
     '((BREAK_KW CONTINUE_KW RETURN_KW FUNC_KW CLASS_KW COVER_KW ENUM_KW INTERFACE_KW FROM_KW ABSTRACT_KW FINAL_KW STATIC_KW INLINE_KW EXTENDS_KW EXTERN_KW UNMANGLED_KW IMPLEMENTS_KW IMPORT_KW INCLUDE_KW USE_KW IF_KW ELSE_KW FOR_KW WHILE_KW MATCH_KW CASE_KW AS_KW IN_KW INTO_KW VERSION_KW PROTO_KW SET_KW GET_KW OPERATOR_KW CONST_KW TRUE_KW FALSE_KW NULL_KW COMMA R_ARROW DOUBLE_ARROW ASS_DECL ASS_ADD ASS_SUB ASS_MUL ASS_DIV ASS_B_RSHIFT ASS_B_LSHIFT ASS_B_XOR ASS_B_OR ASS_B_AND QUEST L_OR L_AND B_XOR EQUALS NOT_EQUALS LESSTHAN MORETHAN CMP LESSTHAN_EQ MORETHAN_EQ B_LSHIFT B_RSHIFT DOUBLE_DOT L_NOT B_NOT PLUS MINUS PERCENT STAR OPEN_PAREN CLOS_PAREN OPEN_SQUAR CLOS_SQUAR OPEN_BRACK CLOS_BRACK AT TILDE)
       nil
       (KW
        ((BREAK_KW))
        ((CONTINUE_KW))
        ((RETURN_KW))
        ((FUNC_KW))
        ((COVER_KW))
        ((ENUM_KW))
        ((FROM_KW))
        ((ABSTRACT_KW))
        ((FINAL_KW))
        ((STATIC_KW))
        ((INLINE_KW))
        ((EXTENDS_KW))
        ((EXTERN_KW))
        ((UNMANGLED_KW))
        ((IMPORT_KW))
        ((INCLUDE_KW))
        ((IF_KW))
        ((ELSE_KW))
        ((FOR_KW))
        ((WHILE_KW))
        ((AS_KW))
        ((OPERATOR_KW))
        ((CONST_KW))
        ((NULL_KW))
        ((MATCH_KW))
        ((CASE_KW)))
       (statements
        (nil)
        ((statements KW))))
     '(statements)))
  "Parser table.")

(defun ooc-wisent-wy--install-parser ()
  "Setup the Semantic Parser."
  (semantic-install-function-overrides
   '((parse-stream . wisent-parse-stream)))
  (setq semantic-parser-name "LALR"
        semantic--parse-table ooc-wisent-wy--parse-table
        semantic-debug-parser-source "ooc-wisent.wy"
        semantic-flex-keywords-obarray ooc-wisent-wy--keyword-table
        semantic-lex-types-obarray ooc-wisent-wy--token-table)
  ;; Collect unmatched syntax lexical tokens
  (semantic-make-local-hook 'wisent-discarding-token-functions)
  (add-hook 'wisent-discarding-token-functions
            'wisent-collect-unmatched-syntax nil t))


;;; Analyzers
;;
(require 'semantic-lex)


;;; Epilogue
;;

(provide 'ooc-wisent-wy)

;;; ooc-wisent-wy.el ends here
