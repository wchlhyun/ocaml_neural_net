(*
 * [process_args arg_list] processes a list of command line arguments,
 * and runs the specified commands.
 *)
val process_args : ?filename : string option -> ?lout : string option -> ?pout : string option ->
  ?tout : bool -> ?imgout : string option -> ?skip : bool -> ?b_thresh : float ->
  ?l_thresh : float -> ?c_thresh : float -> ?network : int -> string list -> unit

val run : unit
