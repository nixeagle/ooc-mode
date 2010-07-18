;;; ooc-wisent-wy.el --- Generated parser support file

;; Copyright (C) 2010 James

;; Author: James <i@nixeagle.org>
;; Created: 2010-07-18 23:07:28+0000
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
      (SLASH . "/")
      (STAR . "*")
      (PERCENT . "%")
      (MINUS . "-")
      (PLUS . "+")
      (BINARY_NOT . "~")
      (LOGIC_NOT . "!")
      (BINARY_RSHIFT . ">>")
      (BINARY_LSHIFT . "<<")
      (MORETHAN_EQ . ">=")
      (LESSTHAN_EQ . "<=")
      (CMP . "<=>")
      (MORETHAN . ">")
      (LESSTHAN . "<")
      (NOT_EQUALS . "!=")
      (EQUALS . "==")
      (BINARY_AND . "&")
      (BINARY_XOR . "^")
      (BINARY_OR . "|")
      (LOGIC_AND . "&&")
      (LOGIC_OR . "||")
      (QUESTION . "?")
      (ASS_B_AND . "&=")
      (ASS_B_OR . "|=")
      (ASS_B_XOR . "^=")
      (ASS_B_LSHIFT . "<<=")
      (ASS_B_RSHIFT . ">>=")
      (ASS_DIV . "/=")
      (COMMENT_SINGLE_LINE_START . "//")
      (OOCDOC_SINGLE_LINE_START . "///")
      (ASS_MUL . "*=")
      (ASS_SUB . "-=")
      (ASS_ADD . "+=")
      (ASS . "=")
      (ASS_DECL . ":=")
      (COLON . ":")
      (DOT . ".")
      (DOUBLE_DOT . "..")
      (COMMA . ",")))
   '(("symbol" :declared t)
     ("string" :declared t)
     ("block" :declared t)
     ("number" syntax "-?\\(0c[0-8][0-8_]*\\|0b[01][01_]*\\|0x[0-9a-fA-F][0-9a-fA-F_]*\\|[0-9_]+\\.[0-9_]*\\|[0-9][0-9_]*\\)")
     ("number" :declared t)
     ("newline" syntax "\\(\n\\| >\\)")
     ("newline" :declared t)
     ("whitespace" syntax "\\([ ]+\\)")
     ("whitespace" :declared t)
     ("keyword" :declared t)))
  "Table of lexical tokens.")

(defconst ooc-wisent-wy--parse-table
  (progn
    (eval-when-compile
      (or
       (require 'wisent-comp nil t)
       (require 'semantic/wisent/comp nil t)))
    (wisent-compile-grammar
     '((BREAK_KW CONTINUE_KW RETURN_KW FUNC_KW CLASS_KW COVER_KW ENUM_KW INTERFACE_KW FROM_KW ABSTRACT_KW FINAL_KW STATIC_KW INLINE_KW EXTENDS_KW EXTERN_KW UNMANGLED_KW IMPLEMENTS_KW IMPORT_KW INCLUDE_KW USE_KW IF_KW ELSE_KW FOR_KW WHILE_KW MATCH_KW CASE_KW AS_KW IN_KW INTO_KW VERSION_KW PROTO_KW SET_KW GET_KW OPERATOR_KW CONST_KW TRUE_KW FALSE_KW NULL_KW COMMA DOUBLE_DOT DOT COLON ASS_DECL ASS ASS_ADD ASS_SUB ASS_MUL OOCDOC_SINGLE_LINE_START COMMENT_SINGLE_LINE_START ASS_DIV ASS_B_RSHIFT ASS_B_LSHIFT ASS_B_XOR ASS_B_OR ASS_B_AND QUESTION LOGIC_OR LOGIC_AND BINARY_OR BINARY_XOR BINARY_AND EQUALS NOT_EQUALS LESSTHAN MORETHAN CMP LESSTHAN_EQ MORETHAN_EQ BINARY_LSHIFT BINARY_RSHIFT LOGIC_NOT BINARY_NOT PLUS MINUS PERCENT STAR SLASH PAREN_BLOCK SQUARE_BLOCK BRACKET_BLOCK OPEN_PAREN CLOSE_PAREN OPEN_SQUARE CLOSE_SQUARE OPEN_BRACKET CLOSE_BRACKET DEC_LITERAL FLOAT_LITERAL OCT_LITERAL BIN_LITERAL HEX_LITERAL TILDE STRING_LITERAL ALPHANUMERIC IDENTIFIER)
       nil
       (goal
        ((statement)))
       (statement
        ((import))
        ((tuple))
        ((ternary))
        ((KW)))
       (import
        ((IMPORT_KW import_list)
         (identity $2)))
       (import_list
        ((import_atom))
        ((import_list COMMA import_atom)))
       (import_atom
        ((import_atom_part))
        ((import_atom_part INTO_KW identifier)))
       (import_atom_part
        ((import_path)
         (wisent-raw-tag
          (semantic-tag-new-include $1 nil :file $1))))
       (import_path
        ((alphanumeric_dot))
        ((import_path SLASH alphanumeric_dot)
         (concat $1 $2 $3)))
       (array_literal
        ((SQUARE_BLOCK)
         (semantic-bovinate-from-nonterminal
          (car $region1)
          (cdr $region1)
          'array_literal_item)))
       (array_literal_item
        ((OPEN_SQUARE expression CLOSE_SQUARE)
         (wisent-raw-tag
          (semantic-tag-new-code $2 nil nil nil :array t))))
       (tuple
        ((PAREN_BLOCK)
         (semantic-bovinate-from-nonterminal
          (car $region1)
          (cdr $region1)
          'tuple_item)))
       (tuple_item
        ((OPEN_PAREN expression CLOSE_PAREN)
         (wisent-raw-tag
          (semantic-tag-new-code $2 nil nil nil :tuple t))))
       (ternary
        ((expression QUESTION expression COLON expression)))
       (expression
        ((value_core)
         (wisent-raw-tag
          (semantic-tag-new-code $1 nil nil))))
       (value_core
        ((number_literal))
        ((STRING_LITERAL))
        ((BOOLEAN_LITERAL))
        ((NULL_KW))
        ((array_literal))
        ((tuple)))
       (number_literal
        ((integer_literal))
        ((FLOAT_LITERAL))
        ((BIN_LITERAL)))
       (integer_literal
        ((OCT_LITERAL))
        ((HEX_LITERAL))
        ((DEC_LITERAL)))
       (identifier
        ((ALPHANUMERIC))
        ((IDENTIFIER)))
       (alphanumeric_dot
        ((dots_rest ALPHANUMERIC dots_rest)
         (concat $1 $2 $3))
        ((alphanumeric_dot ALPHANUMERIC dots_rest)
         (concat $1 $2 $3)))
       (dot_optional
        (nil)
        ((DOT)))
       (dot_rest
        ((dot_optional))
        ((dot_rest dot_optional)))
       (dots_optional
        (nil)
        ((DOTS)))
       (dots_rest
        (nil)
        ((DOTS))
        ((dots_rest DOTS)
         (concat $1 $2)))
       (DOTS
        ((DOT))
        ((DOUBLE_DOT)))
       (BOOLEAN_LITERAL
        ((TRUE_KW))
        ((FALSE_KW)))
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
        ((CASE_KW))))
     '(goal tuple_item array_literal_item)))
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

(define-lex-regex-type-analyzer ooc-wisent-wy--<whitespace>-regexp-analyzer
  "regexp analyzer for <whitespace> tokens."
  "\\([ ]+\\)"
  nil
  'whitespace)

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

(define-lex-regex-type-analyzer ooc-wisent-wy--<newline>-regexp-analyzer
  "regexp analyzer for <newline> tokens."
  "\\(\n\\| >\\)"
  nil
  'newline)


;;; Epilogue
;;
(define-lex-regex-analyzer semantic-lex-ignore-all
  "Detect and ignore newline tokens.
Use this ONLY if newlines are not whitespace characters (such as when
they are comment end characters)."
  "."
  (setq semantic-lex-end-point (match-end 0)))

;; define lexer for this grammar
(define-lex ooc-lexer
  "Lexical analyzer for ooc."

  ;;  semantic-lex-beginning-of-line
  semantic-lex-ignore-comments
  semantic-lex-ignore-newline
  semantic-lex-ignore-whitespace
  ooc-wisent-wy--<number>-regexp-analyzer
  ooc-wisent-wy--<string>-sexp-analyzer
  ooc-wisent-wy--<block>-block-analyzer
  ooc-wisent-wy--<keyword>-keyword-analyzer
  ooc-wisent-wy--<symbol>-regexp-analyzer
  ;;  ooc-wisent-wy--<whitespace>-regexp-analyzer
  ;;  ooc-wisent-wy--<newline>-regexp-analyzer

  semantic-lex-charquote
  semantic-lex-paren-or-list
  semantic-lex-close-paren
  semantic-lex-punctuation-type


  semantic-lex-ignore-all
  semantic-lex-default-action
)

(provide 'ooc-wisent-wy)

;;; ooc-wisent-wy.el ends here
