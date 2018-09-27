open Math

module type Layer = sig
  type t = matrix * matrix
  val name : string
  val forwardprop : t -> matrix -> matrix
  val backprop_gradient : t -> matrix -> matrix -> (matrix * matrix * matrix)
end

module FullyConnectedLayer : Layer = struct
  type t = matrix * matrix
  let name = "fully_connected"
  let forwardprop (weights, biases) input = Math.m_mult weights input
                                            |> Math.m_add biases
  let backprop_gradient (weights, biases) activation del =
    let weight_grad = let a = Math.m_transpose activation
                      in let prod = Math.m_mult del a
                      in Math.m_div_scalar prod (float_of_int (Math.m_numcols del))
    and bias_grad = Math.m_mean_cols del
    and activation_grad = let product = Math.m_mult (Math.m_transpose weights) del
(* in Math.m_div_scalar product (float_of_int (Math.m_numcols del)) *)
      in product
    in (weight_grad, bias_grad, activation_grad)
end

module ReluLayer : Layer = struct
  type t = matrix * matrix
  let name = "relu"
  let forwardprop _ input = Math.m_leakyrelu input
  let backprop_gradient (w,b) activation del = w, b,
    Math.m_map (
        fun el -> if el <= 0. then Math.s_lrelu else 1.
    ) activation |> Math.m_elementwise_mult del
end

(* TODO: Implement*)
module ConvLayer : Layer = struct
  (* 5 x 5 *)
  type t = matrix * matrix
  let name = "conv"
  let forwardprop d i = i
  let backprop_gradient d activation del = del, del, del
end
(* TODO: Implement*)
module MaxPoolingLayer : Layer = struct
  (* 2 x 2 *)
  type t = matrix * matrix
  let name = "maxpool"
  let forwardprop d i = i
  let backprop_gradient d activation del = del, del, del
end
(* TODO: Implement*)
module AveragePoolingLayer : Layer = struct
  type t = matrix * matrix
  let name = "avgpool"
  let forwardprop d i = i
  let backprop_gradient d activation del = del, del, del
end

module SoftMaxLayer : Layer = struct
  type t = matrix * matrix
  let name = "softmax"
  let forwardprop _ i = Math.m_softmax i
  let backprop_gradient (w,b) activation del = w,b,del
end

let fullyconnected_l = (module FullyConnectedLayer : Layer)
let conv_l = (module ConvLayer : Layer)
let maxpooling_l = (module MaxPoolingLayer : Layer)
let averagepooling_l = (module AveragePoolingLayer : Layer)
let softmax_l = (module SoftMaxLayer : Layer)
let relu_l = (module ReluLayer : Layer)

let to_string l =
  let module L = (val l : Layer)
  in L.name

let of_string s =
  match s with
  | "fully_connected" -> fullyconnected_l
  | "conv" -> conv_l
  | "relu" -> relu_l
  | "maxpool" -> maxpooling_l
  | "avgpool" -> averagepooling_l
  | "softmax" -> softmax_l
  | _ -> failwith "Not a layer"
