open Neural_layer
open Math
val get_gradient_layer_test : (module Layer) * (matrix * matrix) -> matrix -> matrix -> matrix * matrix * matrix
