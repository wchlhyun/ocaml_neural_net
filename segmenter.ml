open Image
open Math

(* representation of an image, is a matrix *)
type img = Math.matrix
(* figure is a character image, space, or split (split is any space between
 * characters too small to be a space) *)
type figure = CharImg of img | Space | Split
(* line is a list of char imgs or a line break *)
type line = Chars of figure list | Break
(* imgBlock is a list of lines representing a page of text *)
type imgBlock = line list

(* space_ratio used to determine what is a split and what is a space
 * for example: lines are 100 px tall, so a space would be any "white" area
 * between characters that is more than 25 px wide, if space_ratio is 0.25 *)
let space_ratio = 0.25

(* Makes a list of places to split the Matrix for line segmentation
   r is the matrix of the means of each row
   i is the current row
   l is the list of places to split (sum of l = height of r)
   t is the threshold
   a is the accumulator to keep track of what to add to the list
*)
let find_split_lines r t =
  let rec find_split_rows r i l t a =
    if(i < m_numrows r) then
      if (get r i 0) > t then
        find_split_rows r (i + 1) l t (a + 1)
      else find_split_rempties r (i + 1) (a :: l) t 1
    else List.rev (a::l)
  and find_split_rempties r i l t a =
    if(i < m_numrows r) then
      if (get r i 0) <= t then
        find_split_rempties r (i + 1) l t (a + 1)
      else find_split_rows r (i + 1) (a :: l) t 1
    else List.rev (a::l) in
if (get r 0 0) > t then
  find_split_rows r 0 [] t 0
else
  find_split_rempties r 0 [] t 0


(* Segments a page of text into lines *)
let rec segment_line i t =
  let row_means = m_mean_cols i in
  let split_ar = find_split_lines row_means t in
  m_split ~axis:0 (Array.of_list split_ar) i


(* Makes a list of places to split the Matrix for character segmentation
   c is the matrix of the means of each column
   i is the current col
   l is the list of places to split (sum of l = widt of c)
   t is the threshold
   a is the accumulator to keep track of what to add to the list
*)
let find_split_chars r t =
  let rec find_split_cols r i l t a =
    if(i < m_numcols r) then
      if (get r 0 i) > t then
        find_split_cols r (i + 1) l t (a + 1)
      else find_split_cempties r (i + 1) (a :: l) t 1
    else List.rev (a::l)
  and find_split_cempties r i l t a =
    if(i < m_numcols r) then
      if (get r 0 i) <= t then
        find_split_cempties r (i + 1) l t (a + 1)
      else find_split_cols r (i + 1) (a :: l) t 1
    else List.rev (a::l) in
  if (get r 0 0) > t then
    find_split_cols r 0 [] t 0
  else
    find_split_cempties r 0 [] t 0

(* removes whitespace from top and bottom of charimg i *)
let cut_whitespace i t =
  let splts = ref (segment_line i t) in
  let len = (fun () -> Array.length !splts) in
  if m_total_mean (!splts.(0)) <= t
  then
    splts := Array.sub !splts 1 (len ()-1)
  else ();
  if m_total_mean (!splts.(len () - 1)) <= t
  then
    splts := Array.sub !splts 0 (len ()-1)
  else ();
  Array.fold_left (Math.m_concat_vertical)
      (Math.m_zeros 1 (Math.m_numcols !splts.(0))) !splts

(* Segments a line into characters, returns an imgBlock that is a list of
   figures (AKA a Line)
   for each vertical bar, if it's >threshold then add to prev figure,
   else start new figure, if figure is
   i is the image of a line
   t is the threshold
*)
let rec segment_chars t i =
  let col_means = m_mean_rows i in
  let split_ar = find_split_chars col_means t in
  let splt = m_split ~axis:1 (Array.of_list split_ar) i in
  Array.map (fun c ->
            if (m_total_mean c) <= t
              then
                if (float_of_int (m_numcols c) < space_ratio *. float_of_int (m_numrows c))
                  then
                    Split
                  else
                    Space
              else
                (CharImg (cut_whitespace c 0.0))) splt
  |> Array.to_list


(* Segments an image into lines of characters, each of which is a space or a
   character
   i is the Image
   l_t is the line threshold
   c_t is the char threshold
*)
let rec segment i l_t c_t =
  let l_t = l_t *. 255.0 in
  let c_t = c_t *. 255.0 in
  (Array.fold_right
              (fun c acc -> (if (m_total_mean c <= l_t) then Break
                             else (Chars (segment_chars c_t c)))::acc)
                   (segment_line i l_t) [])
