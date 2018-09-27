(* Image takes care of loading and processing images to scan*)
(* The type of the image *)
type img = Math.matrix

(* [create_img s t] finds and opens an image given a filepath [s].
 * Partially binarizes s with threshold t, setting all pixels with
   brightness < t to white.
 * raises: Not_found if there is no specified image file
*)
val create_img : string -> float -> img

(* [make_standard i s t] returns a standardized copy of character image [i],
 * of size [s] by [s] pixels, for input to the NN. *)
val make_standard : img -> int -> img

(* [save_img s i] saves [i] as [s] to the root project folder. *)
val save_img : string -> img -> unit
