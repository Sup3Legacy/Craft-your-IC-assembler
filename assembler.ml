open Parser
open Ast
open Hyper
open Lexing
open Opcodes
open Linker

let usage = "usage: assembler file.s"

let spec = []

let file =
  let file = ref None in
  let set_file s =
    if not (Filename.check_suffix s ".s") then
      raise (Arg.Bad "no .s extension");
    file := Some s
  in
  Arg.parse spec set_file usage;
  match !file with Some f -> f | None -> Arg.usage spec usage; exit 1

let () =
  let c = open_in file in
  let lb = Lexing.from_channel c in
  try
    let f = Parser.fichier Lexer.token lb in
    close_in c;
    let f = link_and_transform f in ()
  with
    | a -> raise a
