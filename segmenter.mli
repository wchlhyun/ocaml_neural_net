(* [Segmenter] takes in an image of (neat) handwriting and segments it into
 * smaller images containing either a full line of test, or an individual
 * character or space *)
open Image
open Exceptions

(* images are stored as matrices *)
type img = Math.matrix
(* figure is a representation of a character (img), space, or split (split is
 * an indicator that the segmenter found a separation between two characters) *)
type figure = CharImg of img | Space | Split
(* line is a list of figures, representing a line of writing, or a
 * Break (line break) *)
type line = Chars of figure list | Break
(* imgBlock is a list of lines, which represents a full page of text *)
type imgBlock = line list

(* [segment image i l_t c_t] segments image down to individual characters, maintaining
 *  formatting through an imgBlock.
   [l_t] is the threshold at which the segmenter detects a line break
   [s_t] is the threshold at which the segmenter detects a break between characters. *)
val segment: img -> float -> float -> imgBlock
