open Parser
open Lexing
open Ast

(* Conversion to binary. *)
let get_4_bits number =
    let res = Array.make 4 false in
    res.(0) <- ((number mod 2) = 1);
    res.(1) <- ((number mod 4) / 2 = 1);
    res.(2) <- ((number mod 8) / 4 = 1);
    res.(3) <- ((number mod 16) / 8 = 1);
    res

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

(* Fill a word of ROM. *)
let fill_word ?(write_ram=false) ?(print=false) ?(read_ram=false) ?(incr_pc=false) ?(read1=0) ?(read2=0) ?(write=0) ?(imm=0) ?(or_val=false) ?(xor=false) ?(carry_in=false) ?(flag0=false) ?(flag1=false) ?(halt=false) rom addr =
    (* Convert to binary. *)
    let read1 = get_4_bits read1 in
    let read2 = get_4_bits read2 in
    let write = get_4_bits write in
    let imm   = get_8_bits imm   in

    rom.(addr) <- [|
        (* Control. *)
        incr_pc;
        flag0;
        flag1;
        print;

        (* ALU control and screen address. *)
        or_val;
        carry_in;
        xor;

        (* Read address 1. *)
        read1.(0);
        read1.(1);
        read1.(2);
        read1.(3);

        (* First bits of the immediate. *)
        imm.(0);
        imm.(1);
        imm.(2);
        imm.(3);

        (* Write address. *)
        write.(0);
        write.(1);
        write.(2);
        write.(3);

        (* Last bits of the immediate. *)
        imm.(7);
        imm.(6);
        imm.(5);
        imm.(4);

        (* Read address 2. *)
        read2.(0);
        read2.(1);
        read2.(2);
        read2.(3);

        (* Useless bits. *)
        false;
        false;
        false;
        false;

        (* Halt. *)
        halt; |]

(* Fill a word of ROM with a given instruction. *)
let fill_instruction instr rom addr = match instr with
    | L_STORE (r, m) -> failwith "Not implemented"
    | L_LOAD (r, m) -> failwith "Not implemented"
    | L_ADD (r1, r2, r3) -> fill_word rom ~incr_pc:true ~read1:r1 ~read2:r2 ~write:r3 addr
    | L_SUB (r1, r2, r3) -> failwith "Not yet implemented"
    | L_XOR (r1, r2, r3) -> fill_word rom ~incr_pc:true ~xor:true ~read1:r1 ~read2:r2 ~write:r3 addr
    | L_OR (r1, r2, r3) -> fill_word rom ~incr_pc:true ~or_val:true ~read1:r1 ~read2:r2 ~write:r3 addr
    | L_LOADI (i, r) -> fill_word rom ~imm:i ~incr_pc:true ~write:r addr
    | L_JMP i -> fill_word rom ~flag0:false ~flag1:false ~imm:i addr
    | L_JOF i -> fill_word rom ~flag0:true ~flag1:true ~imm:i addr
    | L_JNEG i -> fill_word rom ~flag0:true ~flag1:false ~imm:i addr
    | L_JZ i -> fill_word rom ~flag0:false ~flag1:true ~imm:i addr
    | L_PRINT (r, i) -> match i with
        | 0 -> fill_word rom ~incr_pc:true ~or_val:true ~read2:r ~print:true addr
        | 1 -> fill_word rom ~incr_pc:true ~xor:true ~read2:r ~print:true addr
        | 2 -> fill_word rom ~incr_pc:true ~carry_in:true ~read2:r ~print:true addr
        | _ -> failwith "Wrong number of screen."

(* Create the ROM from the parsed file. *)
let handle parsed_file name =
    let res = Array.make_matrix 128 32 false in
    List.iteri (fun i x -> fill_instruction x res i) parsed_file;
    Printer.output_rom res (Filename.remove_extension (Filename.basename name))
