%{

open Ast

%}

%token <int> REGISTER
%token <int> IMMEDIATE
%token <int> MEMADRESS
%token <int> FLAG

%token STORE
%token LOAD
%token ADD
%token SUB
%token OR
%token XOR
%token LOADI
%token JMP
%token NOP
%token MOV

%token EOL
%token EOF

%start fichier
%type <Ast.fichier> fichier
%%

fichier:
  | instructions = separated_list(EOL, instruction) EOF {instructions}
;

instruction:
  | STORE r = REGISTER m = MEMADRESS {STORE(r, m)}
  | LOAD r = REGISTER m = MEMADRESS {LOAD(r, m)}
  | ADD r1 = REGISTER r2 = REGISTER r3 = REGISTER {ADD(r1, r2, r3)}
  | SUB r1 = REGISTER r2 = REGISTER r3 = REGISTER {SUB(r1, r2, r3)}
  | XOR r1 = REGISTER r2 = REGISTER r3 = REGISTER {XOR(r1, r2, r3)}
  | OR r1 = REGISTER r2 = REGISTER r3 = REGISTER {OR(r1, r2, r3)}
  | LOADI i = IMMEDIATE r = REGISTER {LOADI(i, r)}
  | JMP f = FLAG r = MEMADRESS {JMP(f, r)}
  | NOP {ADD(0, 0, 0)}
  | MOV r1 = REGISTER r2 = REGISTER {ADD(r1, 0, r2)}
;
