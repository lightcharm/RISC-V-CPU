`timescale 1ns / 1ps

module register_file #(
    parameter WIDTH = 32,
    parameter DEPTH = 32)(
    input logic CLK,
    input logic [$clog2(DEPTH)-1:0] A_1,
    input logic [$clog2(DEPTH)-1:0] A_2,
    input logic [$clog2(DEPTH)-1:0] A_3,
    input logic [WIDTH-1:0]  WD,
    input logic WE,
    output logic [WIDTH-1:0] RD_1,
    output logic [WIDTH-1:0] RD_2
    ); 

logic [WIDTH-1:0] RAM [0:DEPTH-1]; //по адресу 0 не будет €чейки пам€ти, там всегда лежит 0

assign RD_1 = (A_1 == 0) ? 0 : RAM[A_1];
assign RD_2 = (A_2 == 0) ? 0 : RAM[A_2];
  
always_ff @(posedge CLK)
    if (WE)
        RAM[A_3] <= WD;

endmodule