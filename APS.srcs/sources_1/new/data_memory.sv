`timescale 1ns / 1ps

module data_memory#(
    parameter WIDTH = 32,
    parameter DEPTH = 256)(
    input logic CLK,
    //input logic [$clog2(DEPTH)-1:0] A,
    input logic [WIDTH-1:0] A,
    input logic [WIDTH-1:0] WD,
    input logic WE,
    output logic [WIDTH-1:0] RD
    );

logic [WIDTH-1:0] RAM [0:DEPTH-1];

assign RD = RAM[A[9:2]];

always_ff @(posedge CLK)
    if (WE)
        RAM [A[9:2]] <= WD;
        
endmodule