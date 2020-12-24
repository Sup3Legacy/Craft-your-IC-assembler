(* opcodes for all operations *)

let opStore = 0
let opLoad = 1
let opAdd = 2
let opSub = 3
let opXOR = 4
let opOR = 5
let opLoadI = 6
let opJmp = 7

(* flagcodes *)

let flagTrue = 0 (* Jmp inconditionnel *)
let flagEqZero = 1
let flagNeqZero = 2
