open Neural_layer
open Filename
open Math

(* The type of the neural network *)
type t = ((module Layer) * (matrix * matrix)) list

(* The learning rate of the neural network *)
let learning_rate = -0.03

(** [create_weights num_inputs num_outputs] creates a matrix of weights, randomly initialized *)
let create_weights num_inputs num_outputs =
  let rand = m_random num_inputs num_outputs
  in let scalar = 1. /. (sqrt (float_of_int num_inputs))
  in m_map (fun f -> f *. 2. *. scalar -. scalar) rand

(** [create_biases num_outputs] creates a matrix of biases, initially 0 *)
let create_biases num_outputs = m_zeros num_outputs 1

(** [print_network network] prints out a network *)
let print_network network = List.iter (fun (i,(w,b)) -> Math.m_print w; Math.m_print b; print_newline ()) network

(** [save_nn network filename] saves network to filename *)
let save_nn network filename =
  try
    let f = open_out_bin filename
    in let serialized = List.map (fun (layer,matrices) -> (to_string layer), matrices) network
(* in output_value f layer_list; close_out f *)
    in output_value f serialized; close_out f
  with
  | _ -> ()

(** [load_nn filename] loads network from filename *)
let load_nn filename = try
    let f = open_in_bin filename
    in let serialized = input_value f
    in let network = List.map (fun (layer, matrices) -> (of_string layer), matrices) serialized
    in close_in f; Some network
  with
  | _ -> None

(* [process layer_list input] take the input matrix and runs it through the neural network
 *  represented by the layer_list.
 * returns: a list of the activations of each layer in reversed order
 *          or [[]] if propogation failed.
 *)
let process network input =
  List.fold_left (fun acc ((module L : Layer), data) ->
      match acc with
      | [] -> []
      | x::xs -> try
          (L.forwardprop data x) :: acc
        with
        | _ -> []
    ) [input] network

let backprop network input expected =
  let out = process network input
  in match out with
  | [] -> failwith "Bad Propogation"
  | output::rest ->
    (* let del = Math.m_scale (Math.m_sub output expected) 2. *)
    let del = Math.m_sub output expected
    in let rec backproping network out' del'' acc =
         match network, out' with
         | [], _ -> acc
         | _, [] -> failwith "Bad Size"
         | (l, (w, b))::layer_list, act::act_list ->
           let module L = (val l : Layer)
           in let (temp_w, temp_b, del') = L.backprop_gradient (w, b) act del''
           in let w' = Math.m_norm (Math.m_scale temp_w learning_rate) 1.
           in let b' = Math.m_norm (Math.m_scale temp_b learning_rate) 1.
           in backproping layer_list act_list del' ((w', b')::acc)
    in backproping (List.rev network) rest del []

let take n lst =
  let rec take_tail_rec n out lst' = begin
    match lst' with
    | [] -> List.rev out, lst'
    | x::xs -> if n > 0 then take_tail_rec (n-1) (x::out) xs else List.rev out, lst'
    end
  in take_tail_rec n [] lst

(* [adjustGradients network delta_list] adjusts all the weights and biases in the
 * [network] by those in [delta_list]. Each entry of [delta_list] corresponds
 * to a layer of the network.
 *)
let adjustGradients network delta_list = List.map2 (
    fun (l, (w,b)) (w',b') -> l, (Math.m_add w w', Math.m_add b b')
  ) network delta_list

let rec train train_data data_per_epoch network = match train_data with
  | [] -> network
  | more -> begin
      match take data_per_epoch more with
      | [], _ -> failwith "Bad parameters to training: took no elements"
      | data, tl ->
          let (input_list, expected_list) = List.split data
          in let (input, expected) = (
              Math.vector_list_to_matrix input_list,
              Math.vector_list_to_matrix expected_list
            )
          (* in let b' = backprop network input expected
          in let net' = adjustGradients network b'
             in print_network net'; ignore (read_line ()); train tl data_per_epoch net' *)
          in backprop network input expected
          |> adjustGradients network
          |> train tl data_per_epoch
    end

let train_single_epoch input expected network =
  backprop network input expected |> adjustGradients network

let rec train_matrix train_data network = match train_data with
  | [] -> network
  | (inputs,expecteds)::tl ->
      train_single_epoch inputs expecteds network
      |> train_matrix tl

(* [get_largest_activation vector] gives an int index of the largest value in [vector].
 * requires: [vector] is nx1.
 * returns: a value [v] from 0 to n such that [vector.(v,1)] is the maximum value in [vector]
 *)
let get_largest_activation vector = fst (max_index_of_matrix vector)

let find_cost network input expected =
  match process network input with
  | [] -> failwith "Bad Propogation"
  | x::xs -> Math.m_sub x expected
                |> Math.m_square
                |> Math.m_sum
                |> (/.) (2. *. (float_of_int (Math.m_size expected)))
