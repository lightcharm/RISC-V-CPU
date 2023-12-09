`define WORD_LEN 32
//////////////////////////////////////////////
//  Register File Defines

`define RF_WIDTH 32
//////////////////////////////////////////////
//  Instruction memory defines

`define INSTR_WIDTH 32
`define INSTR_DEPTH 256
//////////////////////////////////////////////
// Instuction format
// B[31] C[30] WS[29:28] ALUop[27:23] RA1[22:18] RA2[17:13] CONST[12:5] WA[4:0]
//////////////////////////////////////////////
//  Instruction parts

//`define INSTR_WA 4:0

`define INSTR_CONST 12:5
`define CONST_LEN 8

//`define INSTR_RA2 17:13
//`define INSTR_RA1 22:18

`define INSTR_WA 11:7
`define INSTR_RA1 19:15
`define INSTR_RA2 24:20

`define INSTR_ALUop 27:23

`define INSTR_WS1 29
`define INSTR_WS2 28
`define INSTR_WS 29:28

`define INSTR_C 30
`define INSTR_B 31
//////////////////////////////////////////////