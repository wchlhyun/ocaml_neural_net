open Tokens
open Translator
    (*Gamma|Delta|Theta|Lambda|Pi|Sigma|Phi
                |Psi|ForAll|Exists|Neq|Geq|Leq|PM|Infinity|In|RightArrow
                |Alpha|Beta|Sum|Div*)
(*Should read:
  The (lambda) = 44
  while (psi) (leq) Z
  a^2 + b^2 = c^2
  sqrt(9) = 3*)

let l1 = Line (Token_List [Character 'T'; Character 'h'; Character 'e'; Space; Symbol Lambda;
                           Space; Character '='; Space; Digit 44;])
let l2 = Line (Token_List [Character 'w'; Character 'h'; Character 'i'; Character 'l';
                           Character 'e'; Space; Symbol Psi; Space; Symbol Leq])
let l3 = Line (Token_List [Power ((Character 'a'), (Digit 2)); Space; Character '+'; Space;
               Power ((Character 'b'), (Digit 2)); Space; Character '='; Space;
                           Power ((Character 'c'), (Digit 2));])
let l4 = Line (Token_List [Root (Digit 9); Space; Character '='; Space; Digit 3])
let l5 = Line (Token_List [Symbol Gamma; Symbol Delta; Symbol Theta;
               Symbol Lambda; Symbol Pi; Symbol Sigma; Symbol Psi; Symbol ForAll;
               Symbol Exists; Symbol Neq; Symbol Geq;
               Symbol Leq; Symbol PM; Symbol Infinity; Symbol In;
               Symbol RightArrow; Symbol Alpha; Symbol Beta; Symbol Sum; Symbol Div;])

let d = Document [l1; l2; l3; l4; l5]

let w = write_latex d "test"
