open Tokens
(* Translator takes in token blocks and writes them to a LaTeX file *)

(* [write_latex] takes in a Token block and a filename and creates a
 * LaTeX file (.tex file)
 *)
val write_latex : block -> string -> unit
