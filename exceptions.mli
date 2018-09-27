(* Exception thrown if invalid arguments are passed in to program. *)
exception InvalidArgs of string

(* Raised if the image file provided is not valid. *)
exception InvalidImage of string

(* Raised if an image can not be found. *)
exception NotFound of string

(* Raised if an image is the wrong size (either too big or too small).*)
exception ImproperInputSize of string

(* Raised if the number of neurons is less than 1*)
exception InvalidNumberNeurons of string

(* Raised if number of hidden layers is less than 0*)
exception InvalidNumberHiddenLayers of string

(* Raised if described weights do not form a neural network with consistent
 * number of neurons in each hidden layer*)
exception InvalidSizeOfWeights of string

(* Raised if described baises do not form a neural network with consistent
 * number of neurons in each hidden layer*)
exception InvalidSizeOfBiases of string

(* Raised if a file is not a valid neural network file *)
exception InvalidFile of string

(* Raised if an invalid int is passed as an index *)
exception IndexOutOfBounds of int

(* Raised if a token can not be found*)
exception TokenNotFound
