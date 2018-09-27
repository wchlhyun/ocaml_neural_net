open Exceptions
open Images
open OImages

type img = Math.matrix

let threshold = 0.1
let resize_threshold = 3

(* converts an .png image to a matrix img *)
let img_of_image t i =
  Math.init_2d (i#height) (i#width)
    (fun y x -> (
         let br =  255.0 -. (float_of_int (Color.brightness (i#get x y))) in
         if br < (t *. 255.0) then 0.0 else br
       )
    )

let create_img s t =
  try
    let orig = if Str.string_match (Str.regexp ".*\\.png") s 0
                 then
        OImages.rgb24 ((OImages.make (Png.load_as_rgb24 s [])))
                 else
        OImages.rgb24 ((OImages.make (Jpeg.load s [])))
    in
    img_of_image t orig
  with
  | Images.Wrong_file_type -> raise (InvalidImage "Wrong file type")
  | Sys_error s -> raise (NotFound s)
  | Failure u when u = "unsupported" -> raise (InvalidImage "unsupported image type")
  | Failure s when s = "failed to open jpeg file" -> raise (NotFound s)
  | Failure s when s = "failed to open png file" -> raise (NotFound s)


(* [make_square i] returns the data of i centered in a square array.
 * [make_square i s] returns the data of i centered in a square array,
 * padded with 0's to be of size s by s.
 * Requires: s is >= # rows in i and # of cols in i *)
let make_square i s =
  let r = (Math.m_numrows i) in
  let c = (Math.m_numcols i) in
  if s < r || s < c then raise (ImproperInputSize "make_square") else
    let r_diff = (s - r) in
    let c_diff = (s - c) in
    let bot = (r_diff / 2) in
    let top = (r_diff / 2) + (r_diff mod 2) in
    let left = (c_diff / 2) in
    let right = (c_diff / 2) + (c_diff mod 2) in
    let temp = Math.m_concat_vertical i (Math.m_zeros bot c) |>
               Math.m_concat_vertical (Math.m_zeros top c) in
    Math.m_concat_horizontal temp (Math.m_zeros s right) |>
    Math.m_concat_horizontal (Math.m_zeros s left)

(* converts a matrix img to a rgb image *)
let image_of_img i =
  let n = (max (Math.m_numcols i) (Math.m_numrows i)) in
  let i' = make_square i (n) in
  let bytes_of_floats a = Array.map (fun f -> Printf.sprintf "%c" @@
                                     char_of_int (int_of_float (f *. 255.0))) a |>
                          Array.fold_left (^) "" in
  let imgbytes = Math.map_rows
      (fun r -> Math.to_array r |> bytes_of_floats) i'
                 |> Array.fold_left (^) "" |> Bytes.of_string in
  OImages.rgb24 (
    (OImages.make (Rgb24 (Rgb24.create_with n n [] imgbytes))))

(* helper function for epx algorith, determines color to set expanded pixels to,
 * based on adjoining pixels. p is center pixel value, surrounded by
 * [a] - above, [b] - left, [c] - right, [d] - below.*)
let epx_test p a b c d =
  let result = [|p;p;p;p|] in
  (match a,c with
  | Some a', Some c' when a' = c' -> result.(0) <- a'
  | _ -> ());
  (match a,b with
  | Some a', Some b' when a' = b' -> result.(1) <- b'
  | _ -> ());
  (match b,d with
  | Some b', Some d' when b' = d' -> result.(2) <- d'
  | _ -> ());
  (match c,d with
  | Some c', Some d' when c' = d' -> result.(3) <- c'
  | _ -> ());
  (match a,b,c,d with
  | Some a', Some b', Some c', _  when a' = b' && b' = c' ->
    result.(0) <- p; result.(1) <- p; result.(2) <- p; result.(3) <- p
  | Some a',Some b',_,Some d' when a' = b' && b' = d' ->
    result.(0) <- p; result.(1) <- p; result.(2) <- p; result.(3) <- p
  | _,Some b',Some c',Some d' when b' = c' && c' = d' ->
    result.(0) <- p; result.(1) <- p; result.(2) <- p; result.(3) <- p
  | _ -> ());
  Array.to_list result


(* doubles every pixel using EPX
requires: i is square *)
let rec resize_up i =
  let n = (Math.m_numrows i) in
  let temp = (Math.create (2*n) (2*n) 0.0) in
  Math.m_iter (fun x y p ->
    let a = Math.get_opt i x (y-1) in
    let b = Math.get_opt i (x+1) y in
    let c = Math.get_opt i (x-1) y in
    let d = Math.get_opt i x (y+1) in
    match (epx_test p a b c d) with
    | [p1;p2;p3;p4] ->
      Math.m_set temp (x*2) (y*2) p1;
      Math.m_set temp (x*2) (y*2+1) p2;
      Math.m_set temp (x*2+1) (y*2) p3;
      Math.m_set temp (x*2+1) (y*2+1) p4;
    | _ -> ()
    ) i;
  temp

(* uses mean pixel values to size down an img [i] to size [s] by [s]
   requires: [i]'s longest side is larger than [s] pixels*)
let rec resize_down i s =
  let n = (Math.m_numcols i) in
  let n'= if n mod s <> 0 then (n + (s - (n mod s))) else n in
  let i' = make_square i n' in (* pad i to be divisible by s *)
  let splt = n'/s in
  let splt_pts  = Array.make_matrix s s (splt,splt) in
  let get_mean (m:img) : float =  ((Math.m_sum m) /. (float_of_int (splt * splt))) in
  let means =  Math.m_split_vh splt_pts i' |> Array.fold_left (fun acc a ->
      ((Array.fold_left (fun acc' a' -> (get_mean a')::acc') [] a)
       |> List.rev |> Array.of_list )::acc) []
               |> List.rev |> Array.of_list in
  Math.init_2d s s (fun x y -> means.(x).(y))

(* resizes image [i] to [s] by [s] pixels. *)
let rec resize s i =
  let n = (max (Math.m_numcols i) (Math.m_numrows i)) in
  let i' = make_square i n in
  if s = n
    then i'
  else if s < n
  then resize_down i' s
  else
    if s-n < resize_threshold then
      make_square i' s
    else
      resize s (resize_up i')

let save_img s i =
  let n = (max (Math.m_numcols i) (Math.m_numrows i)) in
  let i' = make_square i n in
  let char_of_float f = char_of_int (int_of_float ((255.0-.f))) in
  let bytes_of_floats a = Array.map (fun f -> String.make 3 (char_of_float f)) a |>
                          Array.fold_left (^) "" in
  let imgbytes = Math.map_rows
      (fun r -> Math.to_array r |> bytes_of_floats) i'
                 |> Array.fold_left (^) "" |> Bytes.of_string in
  Images.save s None [] (Rgb24 (Rgb24.create_with n n [] imgbytes));;

let make_standard i s =
  resize s i
