open Neural_network
open Neural_layer
open Math
open Owl.Dataset
open Owl

(* Good learning rate: -0.03 *)

let simple_network : t = [
  fullyconnected_l, (create_weights 100 784, m_zeros 100 1);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 25 100, m_zeros 25 1);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 10 25, m_zeros 10 1);
  softmax_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
]
(* let simple_network : t = [
  fullyconnected_l, (create_weights 100 784, m_zeros 100 1);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 25 100, m_zeros 25 1);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 25 25, m_zeros 25 1);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 25 25, m_zeros 25 1);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 25 25, m_zeros 25 1);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 25 25, m_zeros 25 1);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 25 25, m_zeros 25 1);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 25 25, m_zeros 25 1);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 25 25, m_zeros 25 1);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 10 25, m_zeros 10 1);
  softmax_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
] *)
(* let simple_network_2 : t = [
fullyconnected_l, (create_weights 100 784, m_zeros 100 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 25 100, m_zeros 25 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 25 25, m_zeros 25 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 10 25, m_zeros 10 1);
softmax_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
]
let simple_network_3 : t = [
fullyconnected_l, (create_weights 100 784, m_zeros 100 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 25 100, m_zeros 25 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 25 25, m_zeros 25 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 10 25, m_zeros 10 1);
softmax_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
]
let simple_network_4 : t = [
fullyconnected_l, (create_weights 100 784, m_zeros 100 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 25 100, m_zeros 25 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 25 25, m_zeros 25 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 10 25, m_zeros 10 1);
softmax_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
]
let simple_network_5 : t = [
fullyconnected_l, (create_weights 100 784, m_zeros 100 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 25 100, m_zeros 25 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 25 25, m_zeros 25 1);
relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
fullyconnected_l, (create_weights 10 25, m_zeros 10 1);
softmax_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
] *)

(* let _ = Owl.Dataset.download_all () *)

let num_train_data = 60000

let num_test_data = 10000

let num_per_epoch = 80

let (pics, _, answer) = load_mnist_train_data ()

(* let pics' = Owl.Dense.Matrix.Generic.cast_s2d pics |> Math.owl_to_matrix |> Math.m_transpose |> Math.m_split ~axis:1 (Array.make num_train_data 1) |> Array.to_list

let answer' = Owl.Dense.Matrix.Generic.cast_s2d answer |> Math.owl_to_matrix |> Math.m_transpose |> Math.m_split ~axis:1 (Array.make num_train_data 1) |> Array.to_list *)
let pics' = Owl.Dense.Matrix.Generic.cast_s2d pics |> Math.owl_to_matrix |> Math.m_transpose |> Math.m_split ~axis:1 (Array.make (num_train_data/num_per_epoch) num_per_epoch) |> Array.to_list

let answer' = Owl.Dense.Matrix.Generic.cast_s2d answer |> Math.owl_to_matrix |> Math.m_transpose |> Math.m_split ~axis:1 (Array.make (num_train_data/num_per_epoch) num_per_epoch) |> Array.to_list


let data = List.combine pics' answer'

let (_pics, _answer, _) = load_mnist_test_data ()


let _pics' = Owl.Dense.Matrix.Generic.cast_s2d _pics |> Math.owl_to_matrix |> Math.m_transpose |> Math.m_split ~axis:1 (Array.make num_test_data 1) |> Array.to_list

let _answer' = Owl.Dense.Matrix.Generic.cast_s2d _answer |> Owl.Dense.Matrix.Generic.fold_rows (fun acc x -> (Owl.Dense.Matrix.Generic.get x 0 0)::acc ) [] |> List.rev

let _data = List.combine _pics' _answer'

let a = print_endline "data processing done"

(* let trained_network = match load_nn "./mnist_90.network" with
  | Some n -> n
  | None -> failwith "error" *)

let trained_network = train_matrix data simple_network
(* let trained_network_2 = train_matrix data simple_network_2
let trained_network_3 = train_matrix data simple_network_3
let trained_network_4 = train_matrix data simple_network_4
let trained_network_5 = train_matrix data simple_network_5 *)
let b = print_endline "training done"


let ep = 0.001
let rec average_error network data error =
  match data with
  | [] -> error
  | (input, expected)::tl -> begin
      match process network input with
      | [] -> failwith "Bad prop"
      | h::_ -> (* Math.m_print h; Math.m_print expected; *)
        average_error network tl (error +. (Math.m_ssqr_diff h expected))
    end

let rec test_network network data num_correct =
  match data with
  | [] -> num_correct
  | (input, expected)::tl -> begin
      match process network input with
      | [] -> failwith "Bad prop"
      | h::_ -> (* Math.m_print h; Math.m_print expected; *)
        (* print_int (get_largest_activation h); print_float expected; print_newline (); *)
        (* Math.m_print h; *)
        if get_largest_activation h = int_of_float expected
        then test_network network tl (num_correct + 1)
        else test_network network tl (num_correct)
    end

let rec test5_network n1 n2 n3 n4 n5 data num_correct =
  match data with
  | [] -> num_correct
  | (input, expected)::tl -> begin
      match (process n1 input), (process n2 input), (process n3 input), (process n4 input), (process n5 input) with
      | (h1::_), (h2::_), (h3::_), (h4::_), (h5::_) -> (* Math.m_print h; Math.m_print expected; *)
        (* print_int (get_largest_activation h); print_float expected; print_newline (); *)
        (* Math.m_print h; *)
        let sum = Math.m_add h1 h2 |> Math.m_add h3 |> Math.m_add h4 |> Math.m_add h5
        in if get_largest_activation sum = int_of_float expected
        then test5_network n1 n2 n3 n4 n5 tl (num_correct + 1)
        else test5_network n1 n2 n3 n4 n5 tl (num_correct)
      | _,_,_,_,_-> failwith "Bad prop"
    end

(* let () = print_network trained_network *)

(* let () = print_float (average_error trained_network _data 0.); print_endline ""; *)
let () = print_int (test_network trained_network _data 0); print_endline ""
(* let () = print_int (test5_network trained_network trained_network_2 trained_network_3 trained_network_4 trained_network_5 _data 0); print_endline ""; *)
let () = save_nn trained_network "./mnist_new.network"
