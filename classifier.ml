open Neural_network
open Image
open Segmenter
open Exceptions
open Tokens

(* A list of useable neural network files.
 * 0 - classified digits only.
 * 1 - classifies alphanumeric characters
 * 2 - classifies alphanumeric characters and mathematical symbols. *)
let networks = [|"mnist_92.network";"";"classifier_45.network"|] (* FIX!! *)

(* loads correct network file based on input int, according to [networks] *)
let get_network i = match load_nn (Filename.concat Filename.current_dir_name
                                     (Filename.concat "networks" networks.(i)))
  with | Some n -> n
       | None -> raise (InvalidFile "Neural network loading failed.")

(* Static variable, size of images input to neural network. *)
let img_size = 28

(* converts output from neural network to a token. *)
let to_token output = Tokens.int_to_token output

(* converts a single character image to a token. *)
let img_to_token i n =
  (* print_endline ("nn called"); *)
  let ist = (make_standard i img_size) in
  let proc = Math.m_reshape ist [|img_size * img_size;1|] |> Neural_network.process (get_network n) in
  let act = match proc with
    | [] -> print_endline "error"; failwith "Bad propogation."
    | h::t -> (*Math.m_print h;print_int (Neural_network.get_largest_activation h);*)
      Neural_network.get_largest_activation h in
  to_token act

(* helper function for fold_left in imgline_to_tokenline,
 * classifies single char img  using network n and appends it to accumulator *)
let add_fig l fig n =
  match fig with
  | CharImg i -> (img_to_token i n)::l
  | Space -> Space::l
  | Split -> l

(* converts a line of imgs to a line of tokens using network n. *)
let imgline_to_tokenline l n =
  match l with
  | Break -> []
  | Chars fl -> List.rev (List.fold_left (fun l' f ->add_fig l' f n) [] fl)


let save_chars s dir b_t l_t c_t =
  let i = create_img s b_t in
  let ls = segment i l_t c_t in
  let ctr = ref 0 in
  List.iter (fun l -> match l with | Break -> () | Chars cs ->
      List.iter (fun c -> match c with |CharImg c' -> (ctr := !ctr+1); (* FIX!! *)
          save_img (Filename.concat dir ((string_of_int !ctr) ^ ".png"))
            (make_standard c' img_size)
                                       |_ -> ()) cs) ls

let classify ?network:(nn=0) ?skipseg:(skip=false) input_file bin_threshold line_threshold char_threshold  =
  let i = create_img input_file bin_threshold in
  if (skip) then [[img_to_token i nn]] else
  segment i line_threshold char_threshold |>
  List.fold_left (fun d l -> (imgline_to_tokenline l nn)::d) [] |> List.rev
