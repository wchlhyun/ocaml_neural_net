let print_help () =
  print_endline "Image to Latex converter";
  print_endline "Usage: ./main.byte -i <image_file> [options]";
  print_newline ();
  print_endline "Where options are any of:";
  print_endline "-h\t\t\tShow this help menu";
  print_endline "-o <output_latex>\tSave the generated latex file to the given location";
  print_endline "-p <pdf_location>\tConvert the generated latex to a pdf and save it to the given location";
  print_endline "-n\t\t\tChoose which neural network to use to classify. 0: nn with only digits, 1: alphanumeric, 2: all symbols. Set to 2 by default.";
  print_endline "-s\t\t\tSkip image segmentation. The input image must be a single character";
  print_endline "-c <image_location>\t\t\tSkip image classification. The input image is segmented and the resulting images are saved as jpegs in <image_location>.";
  print_endline "-tb <b_t>\t\t\tSets threshold for binarization of image to given float. All pixels with brightness <= <b_t> will be set to 0.";
  print_endline "-tl <l_t>\t\t\tSets threshold for segmentation of image into lines to given float";
  print_endline "-tc <c_t>\t\t\tSets threshold for segmentation of lines into characters to given float.";
  print_endline "-d\t\t\tDisable outputting to the terminal";
  print_newline ();
  print_endline "By default latex output is printed to the terminal."

(** [index el a] is the index of the element [el] in the array [a].
 *  If there are multiple equal elements in the array, the index of the last one is taken.
 *  returns: [None] if [el] is not in [a], or [Some i] where [a.(i) = el].
 *)
(* let index el a = fst @@ Array.fold_left (
    fun (found,iter) el' -> if el' = el then (Some iter,iter+1) else (found,iter+1)
  ) (None, 0) a *)


let rec process_args ?filename:(filename=None) ?lout:(lout=None) ?pout:(pout=None) ?tout:(tout=true) ?imgout:(imgout=None) ?skip:(skip=false)
    ?b_thresh:(bt=0.5) ?l_thresh:(lt=0.0) ?c_thresh:(ct=0.02) ?network:(nn=2) args  =
  let err_msg s = print_endline s; print_help(); ignore (exit 1)
  in match args with
  | "-h"::_ -> print_help (); ignore (exit 1)
  | "-i"::[] -> err_msg "Please specify input file"
  | "-i"::fname::t -> process_args ~filename:(Some fname) ~network:nn ~lout:lout ~pout:pout ~tout:tout ~imgout:imgout ~skip:skip ~b_thresh:bt ~l_thresh:lt ~c_thresh:ct t
  | "-n"::i::t -> begin try process_args ~filename:filename ~network:(int_of_string i) ~lout:lout ~pout:pout ~tout:tout ~imgout:imgout ~skip:skip ~b_thresh:bt ~l_thresh:lt ~c_thresh:ct t
      with Failure s when s = "int_of_string" -> err_msg "Invalid arguments with 'n'. Please ensure you are providing an int." end
  | "-n"::[] -> err_msg "Invalid arguments with 'n'. Please ensure you are providing an int."
  | "-o"::[] -> err_msg "Invalid arguments with '-o'. Please specify output latex file location"
  | "-o"::oname::t -> process_args ~filename:filename ~network:nn ~lout:(Some oname) ~pout:pout ~tout:tout ~imgout:imgout ~skip:skip ~b_thresh:bt ~l_thresh:lt ~c_thresh:ct t
  | "-c"::[] -> err_msg "Invalid arguments with '-o'. Please specify output latex file location"
  | "-c"::cname::t -> process_args ~filename:filename ~network:nn ~lout:lout ~pout:pout ~tout:tout ~imgout:(Some cname) ~skip:skip ~b_thresh:bt ~l_thresh:lt ~c_thresh:ct t
  | "-p"::[] -> err_msg "Invalid arguments with '-p'. Please specify output pdf file location"
  | "-p"::pname::t -> process_args ~filename:filename ~network:nn ~lout:lout ~pout:(Some pname) ~tout:tout ~imgout:imgout ~skip:skip ~b_thresh:bt ~l_thresh:lt ~c_thresh:ct t
  | "-s"::t -> process_args ~filename:filename ~network:nn ~lout:lout ~pout:pout ~tout:tout ~imgout:imgout ~skip:true ~b_thresh:bt ~l_thresh:lt ~c_thresh:ct t
  | "-tb"::[] -> err_msg "Invalid arguments with 'tb'. Please ensure you are providing a float."
  | "-tc"::[] -> err_msg "Invalid arguments with 'tc'. Please ensure you are providing a float."
  | "-tl"::[] -> err_msg "Invalid arguments with 'tl'. Please ensure you are providing a float."
  | "-tb"::bthresh::t -> begin try process_args ~filename:filename ~network:nn ~lout:lout ~pout:pout ~tout:tout ~imgout:imgout ~skip:skip ~b_thresh:(float_of_string bthresh) ~l_thresh:lt ~c_thresh:ct t
    with Failure s when s = "float_of_string" -> err_msg "Invalid arguments with 'tb'. Please ensure you are providing a float." end
  | "-tl"::lthresh::t -> begin try process_args ~filename:filename ~network:nn ~lout:lout ~pout:pout ~tout:tout ~imgout:imgout ~skip:skip ~b_thresh:bt ~l_thresh:(float_of_string lthresh) ~c_thresh:ct t
     with Failure s when s = "float_of_string" -> err_msg "Invalid arguments with 'tl'. Please ensure you are providing a float." end
  | "-tc"::cthresh::t -> begin try process_args ~filename:filename ~network:nn ~lout:lout ~pout:pout ~tout:tout ~imgout:imgout ~skip:skip ~b_thresh:bt ~l_thresh:lt ~c_thresh:(float_of_string cthresh) t
     with Failure s when s = "float_of_string" -> err_msg "Invalid arguments with 'tl'. Please ensure you are providing a float." end
  | "-d"::t -> process_args ~filename:filename ~network:nn ~lout:lout ~pout:pout ~tout:false ~imgout:imgout ~skip:skip t
  | [] ->
    begin
      match filename with
      | None -> err_msg "Invalid arguments"
      | Some f ->
        match imgout with
        | None -> begin
            if(nn > 2 || nn < 0) then (err_msg "Invalid arguments with 'n'. Please enter 0, 1, or 2.");
          let tok = Classifier.classify f ~network:nn ~skipseg:skip bt lt ct in
          let latex =
             tok |> Tokens.string_of_block
          in
          match lout with
          | None -> ()
          | Some s -> (Translator.write_latex tok s);
          match pout with
          | None -> ()
          | Some s ->
            let fn = Filename.remove_extension s |> Filename.basename in
            let dir = Filename.dirname s in
            (Translator.write_latex tok (Filename.concat "tmp" fn));
            ignore (Sys.command ("pdflatex -output-dir=" ^ dir ^ " " ^ (Filename.concat "tmp" fn) ^ ".tex"));
            if (tout) then  print_newline (); print_string ("LATEX: " ^ latex) end
        | Some im -> Classifier.save_chars f im bt lt ct

    end
  | _::t -> process_args ~filename:filename ~network:nn ~lout:lout ~pout:pout ~tout:tout ~skip:skip t

let run = ()

open Math
open Neural_network
open Translator
open Tokens
open Image
open Segmenter


let () = match Array.to_list Sys.argv with
  | [] -> process_args []
  | _::t -> process_args t
