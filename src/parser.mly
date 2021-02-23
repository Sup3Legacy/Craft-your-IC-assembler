%{

open Ast

%}

%token <string> LABEL

%token <int> REGISTER
%token <int> IMMEDIATE
%token <int> MEMADRESS
%token <string> LABEL_OCC
%token STORE
%token LOAD
%token ADD
%token SUB
%token OR
%token XOR
%token LOADI
%token JMP
%token JZ
%token JNEG
%token JOF
%token NOP
%token MOV
%token PRINT

%token EOL
%token EOF

%start file
%type <Ast.file> file
%%

file:
    | instructions = list(instruction) EOF {instructions}
;

instruction:
    | l = LABEL {LABEL(l)}
    | STORE r = REGISTER m = MEMADRESS {STORE(r, m)}
    | LOAD r = REGISTER m = MEMADRESS {LOAD(r, m)}
    | ADD r1 = REGISTER r2 = REGISTER r3 = REGISTER {ADD(r1, r2, r3)}
    | SUB r1 = REGISTER r2 = REGISTER r3 = REGISTER {SUB(r1, r2, r3)}
    | XOR r1 = REGISTER r2 = REGISTER r3 = REGISTER {XOR(r1, r2, r3)}
    | OR r1 = REGISTER r2 = REGISTER r3 = REGISTER {OR(r1, r2, r3)}
    | LOADI i = IMMEDIATE r = REGISTER {LOADI(i, r)}
    | JMP r = LABEL_OCC {JMP r}
    | JZ r = LABEL_OCC {JZ r}
    | JNEG r = LABEL_OCC {JNEG r}
    | JOF r = LABEL_OCC {JOF r}
    | NOP {ADD(0, 0, 0)}
    | MOV r1 = REGISTER r2 = REGISTER {ADD(r1, 0, r2)}
    | PRINT r = REGISTER i = IMMEDIATE {PRINT(r, i)}
;
