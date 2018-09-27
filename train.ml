open Neural_network
open Neural_layer
open Math
open Tokens
open Image

let network = [
  fullyconnected_l, (create_weights 300 784, create_biases 300);
  relu_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
  fullyconnected_l, (create_weights 70 300, create_biases 70);
  softmax_l, (Math.m_zeros 1 1, Math.m_zeros 1 1);
]

let () = Random.self_init ()
let shuffle arr = Array.sort (fun _ _ -> (Random.int 3) - 1) arr

let dataset_dir = "./datasets/dataset_math"

let dir_array = Sys.readdir dataset_dir |> Array.to_list |> List.filter (fun el -> String.get el 0 <> '.')

let take n lst =
  let rec take_tail_rec n out lst' = begin
    match lst' with
    | [] -> List.rev out, lst'
    | x::xs -> if n > 0 then take_tail_rec (n-1) (x::out) xs else List.rev out, lst'
    end
  in take_tail_rec n [] lst

let filename_list = List.fold_left (
    fun acc dir -> let files_in_dir =
                     Array.to_list (Sys.readdir (Filename.concat dataset_dir dir))
                     |> List.filter (fun el -> String.get el 0 <> '.')
                     |> List.map (fun el -> dir, Filename.concat dataset_dir (Filename.concat dir el))
                     |> take 1500 |> fst
      in List.rev_append acc files_in_dir
  ) [] dir_array |> Array.of_list

let num_data = Array.length filename_list

let indexes = let i = Array.init num_data (fun i -> i)
  in shuffle i; Array.to_list i

let num_per_epoch = 200
let (train_indexes, test_indexes) = take (int_of_float ((float_of_int num_data) *. 0.7)) indexes

let make_vector (expected, filename) =
  let token = Tokens.string_to_token expected
  in let exp_int = Tokens.int_of_token token
  in let empty_vec = m_zeros 70 1
  in let exp_vec = m_set empty_vec exp_int 0 1.; empty_vec
  in let img_matrix = Image.create_img filename 0.05
  in (Math.m_reshape img_matrix [|28*28;1|], exp_vec)


let rec train_network indexes network epoch_num =
  match indexes with
  | [] -> network
  | _ -> begin print_int epoch_num; print_newline ();
      let (first_n, rest) = take num_per_epoch indexes
      in let (inputs_list, expecteds_list) = List.fold_left (
          fun (inp_list,exp_list) i ->
            let (input,exp) = make_vector filename_list.(i)
            in (input::inp_list,exp::exp_list)
        ) ([],[]) first_n
      in let (input_matrix, expected_matrix) = (Math.vector_list_to_matrix inputs_list, Math.vector_list_to_matrix expecteds_list)
      in let network' = train_single_epoch input_matrix expected_matrix network
      in train_network rest network' (epoch_num + 1)
    end

let () = print_endline "starting training"

let trained_network = train_network train_indexes network 0

(* let train_data = List.map (fun i -> filename_list.(i) |> make_vector) train_indexes *)
(* let trained_network = List.fold_left (
    fun acc i -> let (input,expected) = print_int i; make_vector filename_list.(i)
      in train_single_epoch input expected acc
  ) network train_indexes
take num_per_epoch train_indexes *)
let () = print_endline "network trained"

(* let test_data = List.map (fun i -> filename_list.(i) |> make_vector) test_indexes *)

let () = print_endline "starting testing"
(* let () = print_endline "data processing done" *)
(* let trained_network = train_matrix train_data network *)
(* let () = print_endline "training done" *)

let rec test_network network test_indexes num_correct =
  match test_indexes with
  | [] -> num_correct
  | i::tl -> begin
      let (input, expected) = make_vector (filename_list.(i))
      in match process network input with
      | [] -> failwith "Bad prop"
      | h::_ -> (* Math.m_print h; Math.m_print expected; *)
        (* print_int (get_largest_activation h); print_float expected; print_newline (); *)
        (* Math.m_print h; *)
        if get_largest_activation h = get_largest_activation expected
        then test_network network tl (num_correct + 1)
        else test_network network tl (num_correct)
    end

let () = print_int (List.length test_indexes); print_newline (); print_int (test_network trained_network test_indexes 0); print_newline ()

let () = save_nn trained_network "./classifier_new.network"
