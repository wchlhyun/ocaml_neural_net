open Image
open Exceptions
open Neural_network
open Tokens
open Segmenter

(* Represents a neural network that classifies an img to a token*)

(* [classify fn ?nn ?ss bt lt ct] inputs image file [fn],
 * preprocesses it using binarization threshold [bt],
 * segments the image into lines using threshold [lt],
 * segments those lines into characters using threshold [ct],
 * (if [ss] is true it skips these steps) 
 * and converts those characters into tokens using network [nn]. *)
val classify: ?network:int -> ?skipseg:bool -> string -> float -> float -> float -> block


(* [classify fn dir bt lt ct] inputs image file [fn]
 * to the segmenter, and saves all resulting character images in
 * directory dir as pngs.
 * Note: artifacts may appear in saved pngs that do not occur in the actual
 * img matrix, due to compression. *)
val save_chars : string -> string -> float -> float -> float -> unit
