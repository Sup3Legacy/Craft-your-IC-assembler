open Parser

let keywords = Hashtbl.create 10
let words = [("load", LOAD); ("store", STORE); ("add", ADD); ("sub", SUB); ("xor", XOR);
  ("or", OR); ("loadi", LOADI); ("jmp", JMP); ("nop", NOP); ("mov", MOV)]
let () = List.iter (fun (s, t) -> Hashtbl.add keywords s t) words

let string_to_flag = Hashtbl.create 8
let flags = [("true", 0); (("zero", 1))]
let () = List.iter (fun (s, t) -> Hashtbl.add string_to_flag s t) flags
