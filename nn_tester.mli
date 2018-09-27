open Math
open Neural_network

val create_data : int -> (matrix * matrix) list -> (matrix * matrix) list

val test_network : t -> (matrix * matrix) list -> int -> int

val average_error : t -> (matrix * matrix) list -> float -> float 
