(** Type representing a matrix *)
type matrix

(****** Matrix creation functions ******)
(** [m_zeros m n] creates an mxn matrix of zeros *)
val m_zeros : int -> int -> matrix
(** [m_random m n] creates an mxn matrix of random numbers from 0-1 *)
val m_random : int -> int -> matrix
(** [m_eye m] creates an mxm identity matrix *)
val m_eye : int -> matrix
(** [m_empty] creates an empty matrix *)
val m_empty : matrix
(** [m_sequential ~a ~step ~m ~n] creates an mxn matrix
 *    with each value increasing sequentially by [step] starting from [a].
 *    By default, [a] is 0 and [step] is 1 *)
val m_sequential : ?a:float -> ?step:float -> int -> int -> matrix
(** [init_2d m n f] creates an mxn matrix with values initialized by [f],
 *    a function that, given the indexes of a location in the matrix, returns a float *)
val init_2d : int -> int -> (int -> int -> float) -> matrix
(** [create m n d] creates an mxn matrix with all values initialized to [d] *)
val create : int -> int -> float -> matrix
(** [vector_list_to_matrix lst] creates an matrix from the column vectors in [lst]
 *    It merges them horizontally. All matrices in [lst] must be size mx1, and
 *    an mxn matrix will be created, where n is the length of [lst]
 * requires: [lst] is not empty *)
val vector_list_to_matrix : matrix list -> matrix
(** [owl_to_matrix m] converts the Owl.Mat.mat type to Math.matrix type *)
val owl_to_matrix : Owl.Mat.mat -> matrix
(** [m_of_array a m n] creates an mxn matrix from the values of [a].
  * requires: [a] has length m*n *)
val m_of_array : float array -> int -> int -> matrix

(****** Matrix iteration functions ******)
(** Apply the given function to each element in a matrix,
    returning a new matrix *)
val m_map : (float -> float) -> matrix -> matrix
(** Apply the given function to each element in a matrix,
    returning a unit *)
val m_iter : (int -> int -> float -> unit) -> matrix -> unit
(** Apply the given function to each row in a matrix,
    returning an array of all mapped rows *)
val map_rows : (matrix -> 'a) -> matrix -> 'a array

(****** Neural Network layer functions ******)
(** [s_lrelu] is the scalar used in the leaky_relu *)
val s_lrelu : float
(** [m_relu m] applies the relu function to every element of the [m] *)
val m_relu : matrix -> matrix
(** [m_leakyrelu m] applies the leakyrelu function with scalar [s_lrelu] to every element of the [m] *)
val m_leakyrelu : matrix -> matrix
(** [m_softmax m] calculates the softmax of each column of [m], returning a new matrix of those columns *)
val m_softmax : matrix -> matrix
(** [m_ssqr_diff m1 m2] takes the sum squared difference of the elements of [m1] and [m2] *)
val m_ssqr_diff : matrix -> matrix -> float
(** [m_norm m thresh] normalizes [m] by l2norm if l2norm exceeds [thresh] *)
val m_norm : matrix -> float -> matrix

(****** Matrix Modifiers ******)
(** [m_mult m1 m2] is the dot product of [m1] and [m2] *)
val m_mult : matrix -> matrix -> matrix
(** [m_elementwise_mult m1 m2] is the elementwise product of [m1] and [m2] *)
val m_elementwise_mult : matrix -> matrix -> matrix
(** [m_add m1 m2] is the elementwise sum of [m1] and [m2] *)
val m_add : matrix -> matrix -> matrix
(** [m_sub m1 m2] is the elementwise difference of [m1] and [m2] *)
val m_sub : matrix -> matrix -> matrix
(** [m_square m] squares every element of [m] *)
val m_square : matrix -> matrix
(** [m_exp m] takes e to the power of every element of [m] *)
val m_exp : matrix -> matrix
(** [m_div_scalar m scalar] divides every element of [m] by scalar *)
val m_div_scalar : matrix -> float -> matrix
(** [m_div_scalar_inplace m scalar] is [m_div_scalar m scalar] but inplace*)
val m_div_scalar_inplace : matrix -> float -> unit
(** [m_scale m scalar] multiplies every element of [m] by scalar *)
val m_scale : matrix -> float -> matrix
(** [m_reverse m] is [m] backwards *)
val m_reverse : matrix -> matrix
(** [m_mean_cols m] is a matrix consisting of the means of all the cols of [m] *)
val m_mean_cols : matrix -> matrix
(** [m_mean_rows m] is a matrix consisting of the means of all the rows of [m] *)
val m_mean_rows : matrix -> matrix
(** [m_concat_vertical m1 m2] merges the two matrices [m1] and [m2] vertically *)
val m_concat_vertical : matrix -> matrix -> matrix
(** [m_concat_horizontal m1 m2] merges the two matrices [m1] and [m2] horizontally *)
val m_concat_horizontal : matrix -> matrix -> matrix
(** [m_tile m r c] tiles the matrix [m] the number of times specified by [r] and [c] *)
val m_tile : matrix -> int -> int -> matrix
(** [m_repeat ~axis m i] repeats every element of [m] along the axis [axis] [i] times *)
val m_repeat : ?axis:int -> matrix -> int -> matrix
(** [m_transpose m] is the transpose of matrix [m] *)
val m_transpose : matrix -> matrix
(** [m_reshape m a] reshapes [m] into the size specified by [a] *)
val m_reshape : matrix -> int array -> matrix
(** [m_split ~axis a m] splits [m] into many matrices split along [axis] by the dimensions in [a] *)
val m_split : ?axis:int  -> int array -> matrix -> matrix array
(** [m_split_vh a m] splits [m] into many matrices along both axises by the dimension pairs in [a] *)
val m_split_vh : (int*int) array array -> matrix -> matrix array array

(****** Matrix Getters/Setters ******)
(** [m_set m r c v] sets the value in [m] at row [r], col [c] to value [v]*)
val m_set : matrix -> int -> int -> float -> unit
(** [get m r c] is the value in [m] at row [r], col [c] *)
val get : matrix -> int -> int -> float
(** [get_opt m r c] is Some [v] where v is the value in [m] at row [r], col [c], or None if getting fails *)
val get_opt : matrix -> int -> int -> float option

(****** Matrix Consumers ******)
(** [m_numrows m] is the number of rows of matrix [m] *)
val m_numrows : matrix -> int
(** [m_numcols m] is the number of colums of matrix [m] *)
val m_numcols : matrix -> int
(** [m_size m] is the number of entries of matrix [m] *)
val m_size : matrix -> int
(** [m_sum m] is the sum of all the elements of matrix [m] *)
val m_sum : matrix -> float
(** [m_mean ~axis m] is a list of all the means of matrix [m] along axis [axis] *)
val m_mean : ?axis:int -> matrix -> float list
(** [m_equal m1 m2] is true if m1=m2, false otherwise *)
val m_equal : matrix -> matrix -> bool
(** [m_print m] prints matrix [m] to stdout *)
val m_print : matrix -> unit
(** [to_array m] is [m] represented as an array*)
val to_array : matrix -> float array
(** [max_index_of_matrix m] is the index of [m] with the element of the maximum value *)
val max_index_of_matrix : matrix -> int * int
(** [m_shape m] is the shape of matrix [m] *)
val m_shape : matrix -> int * int
(** [m_total_mean m] is the average of all the elements of [m] *)
val m_total_mean : matrix -> float
(** [m_fold_rows f acc m] folds over the rows of matrix [m] *)
val m_fold_rows : ('a -> matrix -> 'a) -> 'a -> matrix -> 'a
