`timescale 1ns / 1ps
`include "defines.v"

module alu #(parameter WORD_LEN = 32)(
    input logic [$clog2(WORD_LEN)-1:0] ALUOp,
    input logic [WORD_LEN -1:0] A,
    input logic [WORD_LEN -1:0] B,
    output logic [WORD_LEN -1:0] Result,
    output logic Flag
    );

always_comb begin : ALU
    case (ALUOp)
        `ALU_ADD:   begin
                    Result = A + B;
                    Flag = 0;
                    end
        `ALU_SUB:   begin
                    Result = A - B;
                    Flag = 0;
                    end
        `ALU_SLL:   begin
                    Result = A << B;
                    Flag = 0;
                    end
        `ALU_SLTS:   begin
                    Result = $signed(A < B);
                    Flag = 0;
                    end
        `ALU_SLTU:  begin
                    Result = A < B;
                    Flag = 0;
                    end
        `ALU_XOR:   begin
                    Result = A ^ B;
                    Flag = 0;
                    end
        `ALU_SRL:   begin
                    Result = A >> B;
                    Flag = 0;
                    end
        `ALU_SRA:   begin
                    Result = $signed(A) >>> B;
                    Flag = 0;
                    end
        `ALU_OR:    begin
                    Result = A | B;
                    Flag = 0;
                    end
        `ALU_AND:   begin
                    Result = A & B;
                    Flag = 0;
                    end
        
        `ALU_EQ:   begin
                    Flag = A == B;
                    Result = 0;
                    end
        `ALU_NE:   begin
                    Flag = A != B;
                    Result = 0;
                    end
        `ALU_LTS:   begin
                    Flag = $signed(A < B);
                    Result = 0;
                    end
        `ALU_GES:   begin
                    Flag = $signed(A >= B);
                    Result = 0;
                    end
        `ALU_LTU:  begin
                    Flag = A < B;
                    Result = 0;
                    end
        `ALU_GEU:  begin
                    Flag = A >= B;
                    Result = 0;
                    end
        default:    begin
                    Result = 0;
                    Flag = 0;
                    end
    endcase
end
endmodule