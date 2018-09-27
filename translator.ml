open Printf
open Tokens

(* helper function for [write_latex], creates majority of the body of the LaTeX *)
let create_msg b : string =
  Tokens.string_of_block b

(* creates string of LaTeX formatted correctly *)
let write_latex b f_name =
  let file = f_name in
  let doc_head = {|\documentclass[12pt]{article} \begin{document}|} in
  let message = doc_head ^ (create_msg b) ^ {|\end{document}|} in
  let oc = open_out file in
  fprintf oc "%s\n" message;
  close_out oc
