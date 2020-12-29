{
  open Ast
  open Lexing
  open Parser
  open Hyper
}

let chiffre = ['0'-'9']
let nombre = chiffre+

let char = ['a'-'z'] | '_'
let ident = char+

let spaces = ' ' | '\t'

rule token = parse
  | '.' ident as i {LABEL i}
  | '%' nombre as i {REGISTER (int_of_string i)}
  | '$' nombre as i {IMMEDIATE (int_of_string i)}
  | '(' nombre as i ')' {MEMADRESS (int_of_string i)}
  | ident as c { (* Peut être un identificateur d'instruction ou bien de flag *)
    match Hashtbl.find_opt Hyper.keywords c with
    | None ->
      begin
        match Hashtbl.find_opt Hyper.string_to_flag c with
        | None -> failwith ("unrecognized string " ^ c)
        | Some f -> FLAG f
      end
    | Some ins -> ins
  }
  | spaces* {token lexbuf}
  | '\n' {EOL}
  | eof {EOF}
