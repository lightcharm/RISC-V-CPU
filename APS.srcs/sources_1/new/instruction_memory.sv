`timescale 1ns / 1ps

module instruction_memory #(
    parameter WIDTH = 32,
    parameter DEPTH = 256)(
    //input logic [$clog2(DEPTH)-1:0] A, //двоичный логарифм
    input logic [WIDTH-1:0] A,
    output logic [WIDTH-1:0] RD
    );
    
logic [WIDTH-1:0] ROM [0:DEPTH-1];

initial
    $readmemh("program.txt", ROM, 0, DEPTH-1); //файл с инструкциями

logic [31:0] SA_8b;
assign SA_8b = A >> 2;

assign RD = ROM[SA_8b[7:0]];

endmodule
