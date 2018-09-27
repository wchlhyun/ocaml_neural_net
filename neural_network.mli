open Math
open Neural_layer
type t = ((module Layer) * (matrix * matrix)) list

(* [process layer_list input] take the input matrix and runs it through the neural network
 *  represented by the layer_list.
 * returns: a list of the activations of each layer in reversed order
 *          or [[]] if propogation failed.
*)
val process : t -> matrix -> matrix list

val train : (matrix * matrix) list -> int -> t -> t
val train_matrix : (matrix * matrix) list -> t -> t
val train_single_epoch : matrix -> matrix -> t -> t

val find_cost : t -> matrix -> matrix -> float

(* [save_nn nn filename] attempts to save the weights and biases to the file
 *  specified by [filename] *)
val save_nn: t -> string -> unit

(** [load_nn filename] tries to load the network from the given file
 *    specified by [filename].
 *  returns: [Some network] where network is of type t if loading was successful,
 *            or [None] otherwise.
 *)
val load_nn : string -> t option

val create_weights : int -> int -> matrix

val create_biases : int -> matrix

val print_network : t -> unit

(* [get_largest_activation vector] gives an int index of the largest value in [vector].
 * requires: [vector] is nx1.
 * returns: a value [v] from 0 to n such that [vector.(v,1)] is the maximum value in [vector]
 *)
val get_largest_activation : matrix -> int
