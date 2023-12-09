`timescale 1ns / 1ps

`define ADD 5'b0_0_000
`define SUB 5'b0_1_000
`define SLL 5'b0_0_001
`define SLT 5'b0_0_010
`define SLTU 5'b0_0_011
`define XOR 5'b0_0_100
`define SRL 5'b0_0_101
`define SRA 5'b0_1_101
`define OR 5'b0_0_110
`define AND 5'b0_0_111
`define BEQ 5'b1_1_000
`define BNE 5'b1_1_001
`define BLT 5'b1_1_100
`define BGE 5'b1_1_101
`define BLTU 5'b1_1_110
`define BGEU 5'b1_1_111

module alu_testbench();

localparam N = 32;
logic [N-1:0] A, B;
logic [4:0] ALUOp;
logic [N-1:0] Result;
logic Flag;

alu dut(ALUOp, A, B, Result, Flag);

initial begin
    
    $display("ADD");
    checking(3,7,`ADD);
    checking(-3,-7,`ADD);
    checking(-3,7,`ADD);
    
    $display("SUB");
    checking(8,7,`SUB);
    checking(3,-7,`SUB);
    checking(-3,7,`SUB);
    
    $display("SLL");
    checking(3,7,`SLL);
    checking(-3,-7,`SLL);
    checking(-3,7,`SLL);
    
    $display("SLT");
    checking(3,7,`SLT);
    checking(-3,-7,`SLT);
    checking(-3,7,`SLT);
    
    $display("SLTU");
    checking(3,7,`SLTU);
    checking(-3,-7,`SLTU);
    checking(-3,7,`SLTU);
    
    $display("XOR");
    checking(3,7,`XOR);
    checking(-3,-7,`XOR);
    checking(-3,7,`XOR);
    
    $display("SRL");
    checking(3,7,`SRL);
    checking(-3,-7,`SRL);
    checking(-3,7,`SRL);
    
    $display("SRA");
    checking(3,7,`SRA);
    checking(-3,-7,`SRA);
    checking(-3,7,`SRA);
    
    $display("OR");
    checking(3,7,`OR);
    checking(-3,-7,`OR);
    checking(-3,7,`OR);
    
    $display("AND");
    checking(3,7,`AND);
    checking(-3,-7,`AND);
    checking(-3,7,`AND);
    
    $display("BEQ");
    checking(3,7,`BEQ);
    checking(7,7,`BEQ);
    checking(-7,7,`BEQ);
    checking(-7,-7,`BEQ);

    $display("BNE");
    checking(3,7,`BNE);
    checking(7,7,`BNE);
    checking(-7,7,`BNE);
    checking(-7,-7,`BNE);
    
    $display("BLT"); //signed
    checking(3,7,`BLT);
    checking(7,7,`BLT);
    checking(7,3,`BLT);
    
    $display("BGE"); //signed
    checking(3,7,`BGE);
    checking(7,7,`BGE);
    checking(7,3,`BGE);
    
    $display("BLTU");
    checking(3,7,`BLTU);
    checking(7,3,`BLTU);
    checking(7,7,`BLTU);
    checking(-7,7,`BLTU);
    checking(7,-7,`BLTU);
    checking(-7,-7,`BLTU);
    
    $display("BGEU");
    checking(3,7,`BGEU);
    checking(7,3,`BGEU);
    checking(7,7,`BGEU);
    checking(-7,7,`BGEU);
    checking(7,-7,`BGEU);
    checking(-7,-7,`BGEU);
    
    $stop;
end

task checking;
input [31:0] a_op, b_op;
input [4:0] choice;
logic [31:0] result_TB;
logic flag_TB;

case (choice)
        `ADD:   begin
                result_TB = a_op + b_op;
                flag_TB = 0;
                end
        `SUB:   begin
                result_TB = a_op - b_op;
                flag_TB = 0;
                end
        `SLL:   begin
                result_TB = a_op << b_op;
                flag_TB = 0;
                end
        `SLT:   begin
                result_TB = $signed(a_op < b_op);
                flag_TB = 0;
                end
        `SLTU:  begin
                result_TB = a_op < b_op;
                flag_TB = 0;
                end
        `XOR:   begin
                result_TB = a_op ^ b_op;
                flag_TB = 0;
                end
        `SRL:   begin
                result_TB = a_op >> b_op;
                flag_TB = 0;
                end
        `SRA:   begin
                result_TB = $signed(a_op) >>> b_op;
                flag_TB = 0;
                end
        `OR:    begin
                result_TB = a_op | b_op;
                flag_TB = 0;
                end
        `AND:   begin
                result_TB = a_op & b_op;
                flag_TB = 0;
                end
        
        `BEQ:   begin
                flag_TB = a_op == b_op;
                result_TB = 0;
                end
        `BNE:   begin
                flag_TB = a_op != b_op;
                result_TB = 0;
                end
        `BLT:   begin
                flag_TB = $signed(a_op < b_op);
                result_TB = 0;
                end
        `BGE:   begin
                flag_TB = $signed(a_op >= b_op);
                result_TB = 0;
                end
        `BLTU:  begin
                flag_TB = a_op < b_op;
                result_TB = 0;
                end
        `BGEU:  begin
                flag_TB = a_op >= b_op;
                result_TB = 0;
                end
        default:    begin
                    result_TB = 0;
                    flag_TB = 0;
                    end
    endcase
    
    begin
    A = a_op;
    B = b_op;
    ALUOp = choice;
    
    #10;
           
    if (result_TB == Result && flag_TB == Flag)    
      $display("Good:    %b %b %b %b", flag_TB, result_TB[7:0], Flag, Result[7:0]);
    else                                        
      $display("No good: %b %b %b %b", flag_TB, result_TB[7:0], Flag, Result[7:0]);    
  end
endtask

endmodule
