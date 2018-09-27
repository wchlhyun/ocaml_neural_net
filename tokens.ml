(* symbols we are using *)
type symbol = Gamma|Delta|Theta|Lambda|Pi|Sigma|Phi
            |ForAll|Exists|Neq|Geq|Leq|PM|Infinity|In|RightArrow
            |Alpha|Beta|Sum|Div
(* ref: https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols *)

(* represents different characters, and symbols *)
type token =
  | Character of char
  | Digit of int
  | Root of token
  | Power of token * token (* base and exponent *)
  | Symbol of symbol
  | Space

(* maintains lines for formatting *)
type line = token list

(* holds a document's worth of information, in lines which are lists of tokens *)
type block = line list

(* Map from ints (as given by neural net) to tokens *)
module IntMap = Map.Make(
  struct
    type t = int
    let compare = compare
  end)

(* Map from tokens to ints (as given by neural net) *)
module TokenMap = Map.Make(
  struct
    type t = token
    let compare = compare
  end)

(* Map between the neural network's int output, to tokens *)
let intsToTokens = let a = IntMap.add in
  IntMap.empty
  |> a 0 (Digit 0)
  |> a 1 (Digit 1)
  |> a 2 (Digit 2)
  |> a 3 (Digit 3)
  |> a 4 (Digit 4)
  |> a 5 (Digit 5)
  |> a 6 (Digit 6)
  |> a 7 (Digit 7)
  |> a 8 (Digit 8)
  |> a 9 (Digit 9)
  |> a 10 (Character 'a')
  |> a 11 (Character 'b')
  |> a 12 (Character 'c')
  |> a 13 (Character 'd')
  |> a 14 (Character 'e')
  |> a 15 (Character 'f')
  |> a 16 (Character 'g')
  |> a 17 (Character 'h')
  |> a 18 (Character 'i')
  |> a 19 (Character 'j')
  |> a 20 (Character 'k')
  |> a 21 (Character 'l')
  |> a 22 (Character 'm')
  |> a 23 (Character 'n')
  |> a 24 (Character 'o')
  |> a 25 (Character 'p')
  |> a 26 (Character 'q')
  |> a 27 (Character 'r')
  |> a 28 (Character 's')
  |> a 29 (Character 't')
  |> a 30 (Character 'u')
  |> a 31 (Character 'v')
  |> a 32 (Character 'w')
  |> a 33 (Character 'x')
  |> a 34 (Character 'y')
  |> a 35 (Character 'z')
  |> a 36 (Character '-')
  |> a 37 (Character '+')
  |> a 38 (Character '=')
  |> a 39 (Character '!')
  |> a 40 (Character '(')
  |> a 41 (Character ')')
  |> a 42 (Character '[')
  |> a 43 (Character ']')
  |> a 44 (Character '{')
  |> a 45 (Character '}')
  |> a 46 (Character '/')
  |> a 47 (Character '>')
  |> a 48 (Character '<')
  |> a 49 (Character '|')
  |> a 50 (Symbol ForAll)
  |> a 51 (Symbol Exists)
  |> a 52 (Symbol Neq)
  |> a 53 (Symbol Geq)
  |> a 54 (Symbol Leq)
  |> a 55 (Symbol PM)
  |> a 56 (Symbol Infinity)
  |> a 57 (Symbol In)
  |> a 58 (Symbol RightArrow)
  |> a 59 (Symbol Phi)
  |> a 60 (Symbol Div)
  |> a 61 (Symbol Alpha)
  |> a 62 (Symbol Beta)
  |> a 63 (Symbol Gamma)
  |> a 64 (Symbol Delta)
  |> a 65 (Symbol Pi)
  |> a 66 (Symbol Sum)
  |> a 67 (Symbol Lambda)
  |> a 68 (Symbol Theta)
  |> a 69 (Symbol Sigma)

let tokensToInts = List.fold_left (fun acc (v,k) -> TokenMap.add k v acc) TokenMap.empty
    (IntMap.bindings intsToTokens)

(* Given int output from neural network, creates the corresponding token *)
let int_to_token i = if 0 <= i && (IntMap.cardinal intsToTokens) > i && (IntMap.mem i intsToTokens)
  then IntMap.find i intsToTokens
  else failwith "IndexOutOfBounds"(*raise (IndexOutOfBounds i)*)

(* Given a token, returns an int representation *)
let int_of_token t = if TokenMap.mem t tokensToInts
  then TokenMap.find t tokensToInts
  else failwith "TokenNotFound"(*raise TokenNotFound*)

(* Given a string, returns the token of that string, if string invalid
 * fails with TokenNotFound *)
let string_to_token s =
  match s with
  | "0" -> Digit 0
  | "1" -> Digit 1
  | "2" -> Digit 2
  | "3" -> Digit 3
  | "4" -> Digit 4
  | "5" -> Digit 5
  | "6" -> Digit 6
  | "7" -> Digit 7
  | "8" -> Digit 8
  | "9" -> Digit 9
  | "a" -> Character 'a'
  | "b" -> Character 'b'
  | "c" -> Character 'c'
  | "d" -> Character 'd'
  | "e" -> Character 'e'
  | "f" -> Character 'f'
  | "g" -> Character 'g'
  | "h" -> Character 'h'
  | "i" -> Character 'i'
  | "j" -> Character 'j'
  | "k" -> Character 'k'
  | "l" -> Character 'l'
  | "m" -> Character 'm'
  | "n" -> Character 'n'
  | "o" -> Character 'o'
  | "p" -> Character 'p'
  | "q" -> Character 'q'
  | "r" -> Character 'r'
  | "s" -> Character 's'
  | "t" -> Character 't'
  | "u" -> Character 'u'
  | "v" -> Character 'v'
  | "w" -> Character 'w'
  | "x" -> Character 'x'
  | "y" -> Character 'y'
  | "z" -> Character 'z'
  | "-" -> Character '-'
  | "!" -> Character '!'
  | "(" -> Character '('
  | ")" -> Character ')'
  | "[" -> Character '['
  | "]" -> Character ']'
  | "{" -> Character '{'
  | "}" -> Character '}'
  | "+" -> Character '+'
  | "=" -> Character '='
  | "lt" -> Character '<'
  | "gt" -> Character '>'
  | "|" -> Character '|'
  | "forwardslash" -> Character '/'
  | "forall" -> Symbol ForAll
  | "exists" -> Symbol Exists
  | "neq" -> Symbol Neq
  | "geq" -> Symbol Geq
  | "leq" -> Symbol Leq
  | "pm" -> Symbol PM
  | "infty" -> Symbol Infinity
  | "in" -> Symbol In
  | "rightarrow" -> Symbol RightArrow
  | "phi" -> Symbol Phi
  | "alpha" -> Symbol Alpha
  | "beta" -> Symbol Beta
  | "gamma" -> Symbol Gamma
  | "delta" -> Symbol Delta
  | "pi" -> Symbol Pi
  | "sum" -> Symbol Sum
  | "lambda" -> Symbol Lambda
  | "theta" -> Symbol Theta
  | "sigma" -> Symbol Sigma
  | "div" -> Symbol Div
  | a -> failwith ("TokenNotFound: " ^ a)

(* given a token, returns the string representation in LaTeX *)
let rec string_of_token t =
  match t with
  | Character c -> Char.escaped c
  | Digit d -> string_of_int d
  | Root r -> {|$\sqrt{|} ^ string_of_token r ^ "}$" (*only 1 token inside*)
  | Power (b, e) -> string_of_token b ^ " $^ " ^ string_of_token e ^ "$"
  | Symbol s -> begin
      match s with
      | Gamma -> {| $\Gamma$ |}
      | Delta -> {| $\Delta$ |}
      | Theta -> {| $\theta$ |}
      | Lambda -> {| $\lambda$ |}
      | Pi -> {| $\pi$ |}
      | Sigma -> {| $\Sigma$ |}
      | Phi -> {| $\phi$ |}
      | ForAll -> {|$\forall$|}
      | Exists -> {| $\exists$ |}
      | Neq -> {| $\neq$ |}
      | Geq -> {| $\geq$ |}
      | Leq -> {| $\neq$ |}
      | PM -> {| $\pm$ |}
      | Infinity -> {| $\infty$ |}
      | In -> {| $\in$ |}
      | RightArrow -> {| $\rightarrow$ |}
      | Alpha -> {| $\Alpha$ |}
      | Beta -> {| $\Beta$ |}
      | Sum -> {| $\Sigma$ |}
      | Div -> {| $\div$ |}
    (*| Union -> {|$\cup$|}
      | Intersect -> {|$\cap$|}
      | Subset -> {|$\subseteq$|}
      | DNE -> {|DNE|}
      | Difference -> {| $\setminus$ |}
      | And -> {| $\wedge$ |}
      | Or -> {| $\lor$ |} *)
  end
  | Space -> {| |}

(* given a line of characters, outputs the LaTeX of those tokens *)
let rec string_of_line l =
  match l with
  | h::t -> string_of_token h ^ string_of_line t
  | [] -> {|\newline |}

(* [string_of_block] given a block returns a string that is the body of a
 * LaTeX document *)
let rec string_of_block b =
  match b with
  | h::t -> string_of_line h ^ string_of_block t
  | [] -> ""
