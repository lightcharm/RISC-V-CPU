`timescale 1ns / 1ps

module top_testbench();

parameter PERIOD = 20;
logic clk;
logic reset;

top dut(
    .CLK100MHZ(clk),
    .CPU_RESETN(reset)
);

always begin
    clk = 1'b0;
    #(PERIOD / 2);
    clk = 1'b1;
    #(PERIOD / 2);
end

initial begin
    reset = 1'b0;
    #200;
    reset = 1'b1;
end

endmodule