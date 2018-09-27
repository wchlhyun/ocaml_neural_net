open Math

module type Layer = sig
  type t = matrix * matrix
  val name : string
  val forwardprop : t -> matrix -> matrix
  val backprop_gradient : t -> matrix -> matrix -> (matrix * matrix * matrix)
end

module ConvLayer : Layer
module FullyConnectedLayer : Layer
module MaxPoolingLayer : Layer
module AveragePoolingLayer : Layer
module SoftMaxLayer : Layer
module ReluLayer : Layer

val fullyconnected_l : (module Layer)
val conv_l : (module Layer)
val maxpooling_l : (module Layer)
val averagepooling_l : (module Layer)
val softmax_l : (module Layer)
val relu_l : (module Layer)

val to_string : (module Layer) -> string
val of_string : string -> (module Layer)
