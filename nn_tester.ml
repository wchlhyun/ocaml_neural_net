open Neural_network
open Neural_layer
open Math

let simple_network : t = [
  fullyconnected_l, (create_weights 40 10, m_zeros 40 1);
  (* relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1); *)
  fullyconnected_l, (create_weights 10 40, m_zeros 10 1);
  (* softmax_l, (Math.m_zeros 1 1, Math.m_zeros 1 1); *)
]

let rec create_data n acc = match n with
  | 0 -> acc
  | _ -> let input = m_random 10 1
    in let input' = m_map (fun f -> if f > 0.5 then 1. else 0.) input
    in let output' = m_map (fun f -> abs_float (f -. 1.)) input'
    in create_data (n-1) ((input',output')::acc)

(*square root*)
(* let rec create_data n acc = match n with
  | 0 -> acc
  | _ -> let input = m_random 5 1
    in let input' = input
    in let output' = m_map (fun f -> f /. 2.) input'
    in create_data (n-1) ((input',output')::acc) *)

(* let rec create_data n acc = match n with
  | 0 -> acc
  | _ -> let input = m_random 5 1
    in let input' = m_map (fun f -> if f > 0.5 then 1. else 0.) input
    in let output' = m_reverse input'
    in create_data (n-1) ((input',output')::acc) *)


(* let rec create_data n acc = match n with
  | 0 -> acc
  | _ -> let input = m_random 6 1
    in let input' = m_map (fun f -> if f > 0.5 then 1. else 0.) input
    in let output' = m_zeros 5 1
    in create_data (n-1) ((input',output')::acc) *)
let num_train_data = 10000

let num_test_data = 100

let num_per_epoch = 100

let data = create_data num_train_data []

let trained_network = train data num_per_epoch simple_network

(* let data = create_data 1 []

let trained_network = train data 1 simple_network *)

let test_data = create_data num_test_data []

(* let rec test_network network data num_correct =
  match data with
  | [] -> num_correct
  | (input, expected)::tl -> begin
      match process network input with
      | [] -> failwith "Bad prop"
      | h::_ -> (* Math.m_print h; Math.m_print expected; *)
          if Math.m_equal (m_map (fun f -> if f > 0.5 then 1. else 0.) h) expected
          then test_network network tl (num_correct + 1)
          else test_network network tl (num_correct)
    end *)

(* square root *)

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
        if Math.m_equal (m_map (fun f -> if f > 0.5 then 1. else 0.) h) expected
        then test_network network tl (num_correct + 1)
        else test_network network tl (num_correct)
    end

let () = print_network trained_network

(* let () = print_float ((average_error trained_network test_data 0.) /. float_of_int(num_test_data)); print_endline ""; *)

let () = print_int (test_network trained_network test_data 0); print_endline ""
