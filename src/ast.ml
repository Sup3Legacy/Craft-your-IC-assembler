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
    | JMP of string
    | JOF of string
    | JNEG of string
    | JZ of string
    | PRINT of register * immediate

type file = instruction list

type linked_instruction =
    | L_STORE of register * memory
    | L_LOAD of register * memory
    | L_ADD of register * register * register
    | L_SUB of register * register * register
    | L_XOR of register * register * register
    | L_OR of register * register * register
    | L_LOADI of immediate * register
    | L_JMP of int
    | L_JOF of int
    | L_JNEG of int
    | L_JZ of int
    | L_PRINT of register * immediate

type linked_file = linked_instruction list
