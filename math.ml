open Owl

type matrix = Owl.Mat.mat

type ndarray = Owl.Arr.arr

(* Matrix creation functions *)
let m_zeros rows cols = Owl.Mat.zeros rows cols
let m_empty = Owl.Mat.empty 1 1
let m_eye = Owl.Mat.eye
let m_random rows cols = Owl.Mat.uniform rows cols
let m_sequential = Owl.Mat.sequential
let init_2d = Owl.Mat.init_2d
let create = Owl.Mat.create
let vector_list_to_matrix data = Owl.Mat.concatenate ~axis:1 (Array.of_list data)
let owl_to_matrix o = o
let m_of_array = Owl.Mat.of_array


let m_map f m = Owl.Mat.map f m
let m_iter = Owl.Mat.iteri_2d
let map_rows = Owl.Mat.map_rows

(* Neural Network layer functions *)
let m_relu = Owl.Mat.relu
let s_lrelu = 0.01
let m_leakyrelu = Owl.Mat.leaky_relu ~alpha:s_lrelu
let m_softmax m = Owl.Mat.map_by_col (Owl.Mat.row_num m) Owl.Mat.softmax m;;
let m_cross_entropy = Owl.Mat.cross_entropy'
let m_ssqr_diff = Owl.Mat.ssqr_diff'
let m_norm m thresh = let l2 = Owl.Mat.l2norm' m
  in if l2 > thresh
  then Owl.Mat.mul_scalar m (thresh /. l2)
  else m

(* Matrix Modifiers *)
let m_mult = Owl.Mat.dot
let m_elementwise_mult = Owl.Mat.mul
let m_add = Owl.Mat.add
let m_sub = Owl.Mat.sub
let m_mean_cols m = Owl.Mat.mean_cols m
let m_mean_rows m = Owl.Mat.mean_rows m
let m_concat_vertical = Owl.Mat.concat_vertical
let m_concat_horizontal = Owl.Mat.concat_horizontal
let m_tile m numrows numcols = Owl.Mat.tile m [|numrows; numcols|]
let m_repeat = Owl.Mat.repeat
let m_square m = Owl.Mat.pow_scalar m 2.
let m_exp m = Owl.Mat.exp m
let m_div_scalar m s = Owl.Mat.div_scalar m s
let m_div_scalar_inplace m s = Owl.Mat.div_scalar_ m s
let m_scale m f = Owl.Mat.mul_scalar m f
let m_reverse = Owl.Mat.reverse
let m_transpose = Owl.Mat.transpose
let m_reshape = Owl.Mat.reshape
let m_split = Owl.Mat.split
let m_split_vh = Owl.Mat.split_vh

(* Matrix Getters/Setters *)
let m_set = Owl.Mat.set
let get = Owl.Mat.get
let get_opt m i j = try Some (get m i j) with _ -> None

(* Matrix Consumers *)
let m_numrows = Owl.Mat.row_num
let m_numcols = Owl.Mat.col_num
let m_print m = Owl.Mat.print m
let m_mean ?axis:(axis=0) m = Owl.Mat.mean ~axis:axis m |> Owl.Mat.to_array |> Array.to_list
let m_equal = Owl.Mat.equal
let to_array = Owl.Mat.to_array
let max_index_of_matrix m =
  let index = (Owl.Mat.top m 1).(0)
  in index.(0), index.(1)
let m_size = Owl.Mat.numel
let m_sum = Owl.Mat.sum'
let m_shape = Owl.Mat.shape
let m_total_mean m = ((m_sum m) /. (float_of_int (m_numcols m) *. float_of_int (m_numrows m)))
let m_fold_rows = Owl.Mat.fold_rows
