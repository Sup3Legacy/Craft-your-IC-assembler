open Parser
open Lexing
open Ast

exception NotImplemented

let get_4_bits number =
  let res = Array.make 4 false in
  res.(0) <- ((number mod 2) = 1);
  res.(1) <- ((number mod 4) / 2 = 1);
  res.(2) <- ((number mod 8) / 4 = 1);
  res.(3) <- ((number mod 16) / 8 = 1);
  res
;;

let get_8_bits number =
  let res = Array.make 8 false in
  res.(0) <- ((number mod 2) = 1);
  res.(1) <- ((number mod 4) / 2 = 1);
  res.(2) <- ((number mod 8) / 4 = 1);
  res.(3) <- ((number mod 16) / 8 = 1);
  res.(4) <- ((number mod 32) / 16 = 1);
  res.(5) <- ((number mod 64) / 32 = 1);
  res.(6) <- ((number mod 128) / 64 = 1);
  res.(7) <- ((number mod 256) / 128 = 1);
  res
;;

let fill_word ?(write_ram=false) ?(halt=false) ?(read_ram=false) ?(incr_pc=false) ?(read1=0) ?(read2=0) ?(write=0) ?(imm=0) ?(or_val=false) ?(xor=false) ?(carry_in=false) ?(flag0=false) ?(flag1=false) matrix index =
  matrix.(index).(0) <- incr_pc;
  matrix.(index).(1) <- flag0;
  matrix.(index).(2) <- flag1;
  matrix.(index).(3) <- halt;
  matrix.(index).(4) <- or_val;
  matrix.(index).(5) <- carry_in;
  matrix.(index).(6) <- xor;


  let r1 = get_4_bits read1 in
  matrix.(index).(7) <- r1.(0);
  matrix.(index).(8) <- r1.(1);
  matrix.(index).(9) <- r1.(2);
  matrix.(index).(10) <- r1.(3);

  let r2 = get_4_bits read2 in
  matrix.(index).(23) <- r2.(0);
  matrix.(index).(24) <- r2.(1);
  matrix.(index).(25) <- r2.(2);
  matrix.(index).(26) <- r2.(3);

  let w = get_4_bits write in
  matrix.(index).(15) <- w.(0);
  matrix.(index).(16) <- w.(1);
  matrix.(index).(17) <- w.(2);
  matrix.(index).(18) <- w.(3);

  let imm = get_8_bits imm in
  matrix.(index).(11) <- imm.(0);
  matrix.(index).(12) <- imm.(1);
  matrix.(index).(13) <- imm.(2);
  matrix.(index).(14) <- imm.(3);
  matrix.(index).(22) <- imm.(4);
  matrix.(index).(21) <- imm.(5);
  matrix.(index).(20) <- imm.(6);
  matrix.(index).(19) <- imm.(7);
;;

let fill_instruction instr matrix index =
  match instr with
  | L_STORE (r, m) -> failwith "Not implemented"
  | L_LOAD (r, m) -> failwith "Not implemented"
  | L_ADD (r1, r2, r3) -> fill_word matrix ~incr_pc:true ~read1:r1 ~read2:r2 ~write:r3 index
  | L_SUB (r1, r2, r3) -> failwith "Not yet implemented"
  | L_XOR (r1, r2, r3) -> fill_word matrix ~incr_pc:true ~xor:true ~read1:r1 ~read2:r2 ~write:r3 index
  | L_OR (r1, r2, r3) -> fill_word matrix ~incr_pc:true ~or_val:true ~read1:r1 ~read2:r2 ~write:r3 index
  | L_LOADI (i, r) -> fill_word matrix ~incr_pc:true ~write:r index
  | L_JMP i -> fill_word matrix ~flag0:false ~flag1:false ~imm:i index
  | L_JOF i -> fill_word matrix ~flag0:true ~flag1:true ~imm:i index
  | L_JNEG i -> fill_word matrix ~flag0:true ~flag1:false ~imm:i index
  | L_JZ i -> fill_word matrix ~flag0:false ~flag1:true ~imm:i index
  | L_PRINT (r, i) -> 
    match i with 
    | 0 -> fill_word matrix ~incr_pc:true ~or_val:true ~read2:r ~halt:true index
    | 1 -> fill_word matrix ~incr_pc:true ~xor:true ~read2:r ~halt:true index
    | 2 -> fill_word matrix ~incr_pc:true ~carry_in:true ~read2:r ~halt:true index
    | _ -> failwith "Wrong number of screen."
;;

let handle parsed_file name =
  let res = Array.make_matrix 128 32 false in
  List.iteri (fun i x -> fill_instruction x res i) parsed_file;
  Printer.output_rom res (Filename.remove_extension (Filename.basename name))
;;