open Image
open Math

type t

(* [process layer_list input] take the input matrix and runs it through the neural network
 *  represented by the layer_list.
 * returns: a list of the activations of each layer in reversed order
 *          or [[]] if propogation failed.
*)
val process : t -> matrix -> matrix

(* [create_new i h n o] is an untrained neural network with [i] neurons in the
 * input layers, [h] hidden layers, [n] neurons per hidden layer, and [o]
 * neurons in the output layer
 * requires: -[i] > 0, [h] >= 0, [n] > 0, [o] > 0
 * raises: -InvalidNumberNeurons if [i], [n], or [o] <= 0
 *         -InvalidNumberHiddenLayers if [h] < 0 *)
val create_new: int -> int -> int -> int -> t


(* [create_new weights biases] is a neural network whose weight on the connection
 * between node_i1, j1 (which represents the node j1-th node in the i1-th layer)
 * to node_i2, j2 is weights[i1][j2][j1] and whose biases
 * on the connection between node_i1, j1 to node_i2_j2 to is
 * biases[i2 - 1][j2]
 * requires: -length of weights[1] = lengt of weight[2] = ...
 *             = weights[length of weights - 1]
 *           -length of biases[0] = length of biases[1] = ...
 *             = biases[length of biases - 2]
 * raises: -InvalidSizeOfWeights if
            length of weights[1] <> lengt of weight[2] <> ...
 *          <> weights[length of weights - 1]
 *         -InvalidSizeOfBiases if
 *          length of biases[0] <> length of biases[1] <> ...
 *          <> biases[length of biases - 2]*)
val create_trained: float array array list -> float array list -> t

(* [train nn data] is the neural network trained on [data], where [data]
 * is a list of tuples, whose first element is a image which can be inputted
 * into the [nn] and whose second element is the correct token is classification
 * of the image
 * requires: -the first elements of [data] to be an image with n by n pixels
 *           such that n * n = number of input neurons in [nn]
 *           -the second element of [data] to be the correct classification of
 *             its first element
 * raises: -ImproperInputSize if the first elements of [data] to be an image
 *          with n by n pixels such that n * n <> number of input neurons in
 *          [nn]*)
val train: t -> (img * float array) list -> t

(* [classify nn image] is an ouput that [nn] classifies [image] to
 * requires: [img] to be correct size of [nn] input neurons
 * raises: ImproperInputSize if [image] is not the correct size of [nn] input
 * neurons *)
val classify: t -> img -> float array

(* [save_nn nn] saves the weights and biases to a file*)
val save_nn: t -> string -> unit

(* [nn-from_file file] is a nerual network created from the contents of file
 * [file]
 * requires: [file] to be a valid file storing data on a valid neural network
 * raises: InvalidFile if [file] is not a valid neural network file*)
val nn_from_file: string -> t
