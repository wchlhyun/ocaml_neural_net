open Neural_network
open Neural_layer
open Math
let ep = 0.0001

let get_cost result expected =
  Math.m_sub result expected
  |> Math.m_square
  |> Math.m_sum
  (* |> (/.) (2. *. (float_of_int (Math.m_size expected))) *)

let get_gradient_layer_test ((module L : Layer), (w, b)) activation expected =
  let grad_w = Math.m_zeros (Math.m_numrows w) (Math.m_numcols w) in
  let grad_b  = Math.m_zeros (Math.m_numrows b) (Math.m_numcols b) in
  let new_del = Math.m_zeros (Math.m_numcols w) 1 in
  let og_cost = get_cost (L.forwardprop (w, b) activation) (expected) in
  Math.m_iter (
    fun i j e -> Math.m_set w i j (e +. ep);
      let ep_cost = get_cost (L.forwardprop (w, b) activation) (expected) in
      let delc_delw = (ep_cost -. og_cost) /. ep in
      Math.m_set grad_w i j delc_delw;
      Math.m_set w i j e
    ) w;
  Math.m_iter (
      fun i j e -> Math.m_set b i j (e +. ep);
        let ep_cost = get_cost (L.forwardprop (w, b) activation) (expected) in
        let delc_delb = (ep_cost -. og_cost) /. ep in
        Math.m_set grad_b i j delc_delb;
        Math.m_set b i j e
      ) b;
  Math.m_iter (
      fun i j e -> Math.m_set activation i j (e +. ep);
        let ep_cost = get_cost (L.forwardprop (w, b) activation) (expected) in
        let delc_dela = (ep_cost -. og_cost) /. ep in
        Math.m_set new_del i j delc_dela;
        Math.m_set activation i j e
      ) activation;
    (grad_w, grad_b, new_del)


(* let w = create_weights 10 10
   let b = create_biases 10 *)
let w = Math.m_sequential 4 5
let b = Math.m_zeros 4 1

let act = Math.m_sequential 5 1
let exp = Math.m_sequential ~a:4. ~step:(-1.) 4 1

let (w',b',a') = get_gradient_layer_test (fullyconnected_l, (w,b)) act exp

let n = [fullyconnected_l, (w,b)]

let out = FullyConnectedLayer.forwardprop (w,b) act
let del = Math.m_scale (Math.m_sub out exp) 2.

let (w'',b'',a'') = FullyConnectedLayer.backprop_gradient (w,b) act del

(*let () = Math.m_print b'; Math.m_print b''
let () = Math.m_print w'; Math.m_print w''*)
let () = Math.m_print a'; Math.m_print a''
