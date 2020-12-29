type register = int
type memory = int
type immediate = int
type flag = int

type instruction =
  | LABEL of string
  | STORE of register * memory
  | LOAD of register * memory
  | ADD of register * register * register
  | SUB of register * register * register
  | XOR of register * register * register
  | OR of register * register * register
  | LOADI of immediate * register
  | JMP of flag * string

type fichier = instruction list
