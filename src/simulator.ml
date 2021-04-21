open Linker
open Ast

let RAM_SIZE = 64;;

let read_reg regs index =
  if index = 0
     then 0
  else
    regs.(index)

let write_reg regs index data = 
  if 0 < index && index < 15
    then regs.(index) <- data
  else ()

let read_ram ram index =
  if index < RAM_SIZE then
    ram.(index)
  else
    print_string "Just read past the bound of the RAM.";
    0

let write_ram ram index data =
  if index < RAM_SIZE then
    ram.(index) <- data
  else
    print_string "Just written past the bound of the RAM."

let print_screen screen =
  print_string (
    (string_of_int screen.(0) ^ " " ^ (string_of_int screen.(1)) ^ " " ^ (string_of_int screen.(2)))
  )

let position_flags flags integer =
  failwith "Not implemented"

let step instruction ram registers screen flags pc =
  match instruction with
  | L_STORE (reg, mem) -> write_ram ram (read_reg registers reg); pc + 1
  | L_LOAD (reg, mem) -> write_reg registers reg (read_ram ram mem); pc + 1
  | L_ADD (r1, r2, rd) -> write_reg registers rd ((read_reg registers r1) + (read_reg registers r2)); pc + 1
  | L_SUB (r1, r2, rd) -> write_reg registers rd ((read_reg registers r1) - (read_reg registers r2)); pc + 1
  | L_XOR (r1, r2, rd) -> write_reg registers rd ((read_reg registers r1) lxor (read_reg registers r2)); pc + 1
  | L_OR (r1, r2, rd) -> write_reg registers rd ((read_reg registers r1) lor (read_reg registers r2)); pc + 1
  | L_LOADI (imm, reg) -> write_reg registers reg imm; pc + 1
  | L_JMP i -> i
  | L_JOF i -> failwith "Not implemented"
  | L_JNEG i -> failwith "Not implemented"
  | L_JZ i -> failwith "Not implemented"
  | L_PRINT (reg, imm) -> screen.(imm) <- (read_reg register reg); coutner + 1

let simulate rom =
  let RAM = Array.make RAM_SIZE 0 in
  let registers = Array.make 16 0 in
  let screen = Array.make 3 0 in
  let flags = Array.make 4 0 in
  failwith "Not implemented"
