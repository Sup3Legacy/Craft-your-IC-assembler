open Parser

let keywords = Hashtbl.create 17
let words = [
    ("load", LOAD);
    ("store", STORE);
    ("add", ADD);
    ("sub", SUB);
    ("xor", XOR);
    ("or", OR);
    ("loadi", LOADI);
    ("jmp", JMP);
    ("nop", NOP);
    ("mov", MOV);
    ("jz", JZ);
    ("jof", JOF);
    ("jneg", JNEG);
    ("print", PRINT)]
let () = List.iter (fun (s, t) -> Hashtbl.add keywords s t) words
