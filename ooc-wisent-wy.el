;;; ooc-wisent-wy.el --- Generated parser support file

;; Copyright (C) 2010 James

;; Author: James <i@nixeagle.org>
;; Created: 2010-07-16 04:46:44+0000
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
     ("->" . R_ARROW)
     (">" . DOUBLE_ARROW)
     (":" . ASS_DECL)
     ("+" . ASS_ADD)
     ("-" . ASS_SUB)
     ("*" . ASS_MUL)
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
     ("~" . TILDE))
   '(("as" summary "TYPE as ANOTHERTYPE")
     ("for" summary "for (NAME in [List|Range|1..10]) {...}")
     ("if" summary "if (...) { ... } [[else | else if] { ... }]")
     ("use" summary "use FILE(without .ooc)")
     ("include" summary "include stdio")
     ("import" summary "import FOLDER/FILE(without .ooc) | import FOLDER/[FILE1,FILE2]")
     ("implements" summary "NAME: class implements INTERFACE1,INTERFACE2 {...}")
     ("unmangled" summary "NAME: unmangled func {...}")
     ("extern" summary "NAME: extern[(EXTERNFUNCNAME)] func")
     ("extends" summary "NAME: class extends OTHERCLASSNAME {...}")
     ("inline" summary "NAME: inline func {...}")
     ("static" summary "NAME: static func {...}")
     ("abstract" summary "NAME: abstract func {...} | NAME: abstract class {...}")
     ("interface" summary "NAME: interface {...}")
     ("cover" summary "NAME: cover [from TYPE] {...}")
     ("class" summary "NAME: [abstract] class [extends CLASS | implements INTERFACE1, INTERFACE2] {...}")
     ("func" summary "NAME: [extern | inline] func [~overloaded] [(PARAMS: PARAMSTYPE)] [-> RETURNTYPE] {...}")
     ("return" summary "return VAL // called inside of a function to return a value. Last statement in function is implicit return")
     ("continue" summary "for (i in 0..5) continue // continues the loop")
     ("break" summary "for (i in 0..5) break // i will never get to be 1")))
  "Table of language keywords.")

(defconst ooc-wisent-wy--token-table
  (semantic-lex-make-type-table
   '(("symbol"
      (IDENTIFIER)
      (ALPHANUMERIC . "[A-Za-z_0-9]+"))
     ("string"
      (STRING_LITERAL))
     ("number"
      (HEX_LITERAL . "-?0x[0-9a-fA-F][0-9a-fA-F_]*")
      (BIN_LITERAL . "-?0b[01][01_]*")
      (OCT_LITERAL . "-?0c[0-8][0-8_]*")
      (FLOAT_LITERAL . "-?[0-9_]+\\.[0-9_]*")
      (DEC_LITERAL . "-?[0-9][0-9_]*"))
     ("close-paren"
      (CLOSE_BRACKET . "}")
      (CLOSE_SQUARE . "]")
      (CLOSE_PAREN . ")"))
     ("open-paren"
      (OPEN_BRACKET . "{")
      (OPEN_SQUARE . "[")
      (OPEN_PAREN . "("))
     ("block"
      (BRACKET_BLOCK . "(OPEN_BRACKET CLOSE_BRACKET)")
      (SQUARE_BLOCK . "(OPEN_SQUARE CLOSE_SQUARE)")
      (PAREN_BLOCK . "(OPEN_PAREN CLOSE_PAREN)"))
     ("punctuation"
      (ASS_DIV . "/")
      (COMMENT_SINGLE_LINE_START . "//")
      (OOCDOC_SINGLE_LINE_START . "///")
      (DOT . ".")
      (DOUBLE_DOT . "..")
      (COMMA . ",")))
   '(("symbol" :declared t)
     ("string" :declared t)
     ("block" :declared t)
     ("number" syntax "-?\\(0c[0-8][0-8_]*\\|0b[01][01_]*\\|0x[0-9a-fA-F][0-9a-fA-F_]*\\|[0-9_]+\\.[0-9_]*\\|[0-9][0-9_]*\\)")
     ("number" :declared t)
     ("keyword" :declared t)))
  "Table of lexical tokens.")

(defconst ooc-wisent-wy--parse-table
  (progn
    (eval-when-compile
      (or
       (require 'wisent-comp nil t)
       (require 'semantic/wisent/comp nil t)))
    (wisent-compile-grammar
     '((BREAK_KW CONTINUE_KW RETURN_KW FUNC_KW CLASS_KW COVER_KW ENUM_KW INTERFACE_KW FROM_KW ABSTRACT_KW FINAL_KW STATIC_KW INLINE_KW EXTENDS_KW EXTERN_KW UNMANGLED_KW IMPLEMENTS_KW IMPORT_KW INCLUDE_KW USE_KW IF_KW ELSE_KW FOR_KW WHILE_KW MATCH_KW CASE_KW AS_KW IN_KW INTO_KW VERSION_KW PROTO_KW SET_KW GET_KW OPERATOR_KW CONST_KW TRUE_KW FALSE_KW NULL_KW COMMA DOUBLE_DOT DOT R_ARROW DOUBLE_ARROW ASS_DECL ASS_ADD ASS_SUB ASS_MUL OOCDOC_SINGLE_LINE_START COMMENT_SINGLE_LINE_START ASS_DIV ASS_B_RSHIFT ASS_B_LSHIFT ASS_B_XOR ASS_B_OR ASS_B_AND QUEST L_OR L_AND B_XOR EQUALS NOT_EQUALS LESSTHAN MORETHAN CMP LESSTHAN_EQ MORETHAN_EQ B_LSHIFT B_RSHIFT L_NOT B_NOT PLUS MINUS PERCENT STAR PAREN_BLOCK SQUARE_BLOCK BRACKET_BLOCK OPEN_PAREN CLOSE_PAREN OPEN_SQUARE CLOSE_SQUARE OPEN_BRACKET CLOSE_BRACKET DEC_LITERAL FLOAT_LITERAL OCT_LITERAL BIN_LITERAL HEX_LITERAL TILDE STRING_LITERAL ALPHANUMERIC IDENTIFIER)
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
       (goal
        ((import)))
       (import
        ((IMPORT_KW import_path)
         (wisent-raw-tag
          (semantic-tag-new-include $2 nil nil)))
        ((IMPORT_KW import_path import_name)
         (wisent-raw-tag
          (semantic-tag-new-include
           (concat $2 $3)
           nil nil))))
       (import_name
        ((ALPHANUMERIC)))
       (import_path_part
        ((ALPHANUMERIC))
        ((import_path_part DOT ALPHANUMERIC)
         (concat $1 $2 $3)))
       (import_path
        (nil)
        ((import_path_part ASS_DIV)
         (concat $1 $2))
        ((import_path ASS_DIV import_path_part)
         (progn
           (print
            (list $1 $2 $3))
           (concat $1 $2 $3))))
       (BOOLEAN_LITERAL
        ((TRUE_KW))
        ((FALSE_KW))))
     '(goal)))
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
(require 'semantic-lex nil t)
(require 'semantic/lex nil t)

(define-lex-keyword-type-analyzer ooc-wisent-wy--<keyword>-keyword-analyzer
  "keyword analyzer for <keyword> tokens."
  "\\(\\sw\\|\\s_\\)+")

(define-lex-block-type-analyzer ooc-wisent-wy--<block>-block-analyzer
  "block analyzer for <block> tokens."
  "\\s(\\|\\s)"
  '((("(" OPEN_PAREN PAREN_BLOCK)
     ("[" OPEN_SQUARE SQUARE_BLOCK)
     ("{" OPEN_BRACKET BRACKET_BLOCK))
    (")" CLOSE_PAREN)
    ("]" CLOSE_SQUARE)
    ("}" CLOSE_BRACKET))
  )

(define-lex-sexp-type-analyzer ooc-wisent-wy--<string>-sexp-analyzer
  "sexp analyzer for <string> tokens."
  "\\s\""
  'STRING_LITERAL)

(define-lex-regex-type-analyzer ooc-wisent-wy--<symbol>-regexp-analyzer
  "regexp analyzer for <symbol> tokens."
  "\\(\\sw\\|\\s_\\)+"
  '((ALPHANUMERIC . "[A-Za-z_0-9]+"))
  'IDENTIFIER)

(define-lex-regex-type-analyzer ooc-wisent-wy--<number>-regexp-analyzer
  "regexp analyzer for <number> tokens."
  "-?\\(0c[0-8][0-8_]*\\|0b[01][01_]*\\|0x[0-9a-fA-F][0-9a-fA-F_]*\\|[0-9_]+\\.[0-9_]*\\|[0-9][0-9_]*\\)"
  '((HEX_LITERAL . "-?0x[0-9a-fA-F][0-9a-fA-F_]*")
    (BIN_LITERAL . "-?0b[01][01_]*")
    (OCT_LITERAL . "-?0c[0-8][0-8_]*")
    (FLOAT_LITERAL . "-?[0-9_]+\\.[0-9_]*")
    (DEC_LITERAL . "-?[0-9][0-9_]*"))
  'number)


;;; Epilogue
;;
;; define lexer for this grammar
(define-lex ooc-lexer
  "Lexical analyzer for ooc."

  ;;  semantic-lex-beginning-of-line
  ;; semantic-lex-newline
  ;;ooc-wisent-wy--<test>
  ooc-wisent-wy--<number>-regexp-analyzer
  ooc-wisent-wy--<string>-sexp-analyzer
  ooc-wisent-wy--<block>-block-analyzer
  ooc-wisent-wy--<keyword>-keyword-analyzer
  ooc-wisent-wy--<symbol>-regexp-analyzer

  ;;  semantic-lex-symbol-or-keyword
  semantic-lex-charquote
  semantic-lex-paren-or-list
  semantic-lex-close-paren
  semantic-lex-punctuation-type
  semantic-lex-newline
  semantic-lex-whitespace
  semantic-lex-default-action)

(provide 'ooc-wisent-wy)

;;; ooc-wisent-wy.el ends here
