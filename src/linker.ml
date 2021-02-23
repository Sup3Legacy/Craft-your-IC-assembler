open Ast

module Lmap = Map.Make(String)

let label_map = Lmap.empty

let rec add_labels liste ligne label_map = 
  match liste with 
  | [] -> label_map
  | (LABEL s) :: q -> add_labels q ligne (Lmap.add s ligne label_map)
  | _ :: q -> add_labels q (ligne + 1) label_map
;;

let rec transforms liste label_map =
  match liste with 
  | [] -> []
  | (LABEL s) :: q -> transforms q label_map
  | STORE (r, m) :: q -> L_STORE (r, m) :: (transforms q label_map)
  | LOAD (r, m) :: q -> L_LOAD (r, m) :: (transforms q label_map)
  | ADD (r1, r2, r3) :: q -> L_ADD (r1, r2, r3) :: (transforms q label_map)
  | SUB (r1, r2, r3) :: q -> L_SUB (r1, r2, r3) :: (transforms q label_map)
  | XOR (r1, r2, r3) :: q -> L_XOR (r1, r2, r3) :: (transforms q label_map)
  | OR (r1, r2, r3) :: q -> L_OR (r1, r2, r3) :: (transforms q label_map)
  | LOADI (imm, r) :: q -> L_LOADI (imm, r) :: (transforms q label_map)
  | JMP s :: q -> L_JMP (Lmap.find s label_map) :: (transforms q label_map)
  | JZ s :: q -> L_JZ (Lmap.find s label_map) :: (transforms q label_map)
  | JNEG s :: q -> L_JNEG (Lmap.find s label_map) :: (transforms q label_map)
  | JOF s :: q -> L_JOF (Lmap.find s label_map) :: (transforms q label_map)
  | PRINT (r, s) :: q -> L_PRINT (r, s) :: (transforms q label_map)
;;

let link_and_transform file = 
  transforms file (add_labels file 0 (Lmap.empty))
;;