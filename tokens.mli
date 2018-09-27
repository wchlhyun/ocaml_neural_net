(* Represents symbols without easy char representations *)
type symbol =  Gamma|Delta|Theta|Lambda|Pi|Sigma|Phi
            |ForAll|Exists|Neq|Geq|Leq|PM|Infinity|In|RightArrow
            |Alpha|Beta|Sum|Div

(* Represents a single character, or symbol *)
type token =
  | Character of char
  | Digit of int
  | Root of token
  | Power of token * token (* base and exponent *)
  | Symbol of symbol
  | Space

(* Represents a line of characters *)
type line = token list

(* A block is a list of lines, representing a document *)
type block = line list

(* [string_to_token] is given a string representation of any token, and
 * will output a token *)
val string_to_token : string -> token

(* [string_of_token] given a token outputs a LaTeX string representation *)
val string_of_token : token -> string

(* [string_of_block] given a block, outputs the LaTeX string representation
 * of the block *)
val string_of_block : block -> string

(* [int_to_token] given the int representation of a token,
 * returns the corresponding token *)
val int_to_token : int -> token

(* [int_of_token] given a token outputs the corresponding int representation *)
val int_of_token : token -> int
