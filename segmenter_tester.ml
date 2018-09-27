open Segmenter
open Image

let c_t = 0.02

let l_t = 0.0

let b_t = 0.5

let img = create_img (Filename.concat "test" "p2.jpg") b_t

let i_block = segment img l_t c_t

let p_chars l i =
  let harr = i_block |> Array.of_list in
  match harr.(l) with
  | Chars cs -> begin
    let csarr = cs |> Array.of_list in
    match csarr.(i) with
    | Split -> print_string "split"
    | Space -> print_string "space"
    | CharImg im -> Math.m_print im
    end
  | Break -> print_string "Line Break"
