`timescale 1ns / 1ps

`include "parametres.v"
`include "defines.v"

module top(
    input CLK100MHZ,
    input CPU_RESETN
    );

//instruction
logic [`WORD_LEN-1:0] instruction;

//decoder
logic [1:0] ex_op_a_sel_o;
logic [2:0] ex_op_b_sel_o;
logic [`ALU_OP_WIDTH-1:0] alu_op_o;

logic mem_req_o;
logic mem_we_o;
logic [2:0] mem_size_o;

logic gpr_we_a_o;
logic wb_src_sel_o;

logic illegal_instr_o;
logic branch_o;
logic jal_o;
logic jalr_o;

decoder_riscv block_decoder_riscv(
    .fetched_instr_i(instruction),
    .ex_op_a_sel_o(ex_op_a_sel_o),
    .ex_op_b_sel_o(ex_op_b_sel_o),
    .alu_op_o(alu_op_o),
    .mem_req_o(mem_req_o),
    .mem_we_o(mem_we_o),
    .mem_size_o(mem_size_o),
    .gpr_we_a_o(gpr_we_a_o),
    .wb_src_sel_o(wb_src_sel_o),
    .illegal_instr_o(illegal_instr_o),
    .branch_o(branch_o),
    .jal_o(jal_o),
    .jalr_o(jalr_o)
);

//sign-extend I
logic [`WORD_LEN-1:0] imm_I;
assign imm_I = {{(`WORD_LEN - 12) {instruction[31]}}, instruction[`I_TYPE_IMM]};

//sign-extend S
logic [`WORD_LEN-1:0] imm_S;
assign imm_S = {{(`WORD_LEN - 12) {instruction[31]}}, instruction[`S_TYPE_IMM_11_5], instruction[`S_TYPE_IMM_4_0]};

//sign-extend J
logic [`WORD_LEN-1:0] imm_J;
assign imm_J = {{(`WORD_LEN - 21) {instruction[31]}},   instruction[`J_TYPE_IMM_20], instruction[`J_TYPE_IMM_19_12], instruction[`J_TYPE_IMM_11], instruction[`J_TYPE_IMM_10_1], 1'b0};

//sign-extend B
logic [`WORD_LEN-1:0] imm_B;
assign imm_B = {{(`WORD_LEN - 13) {instruction[31]}},  instruction[`B_TYPE_IMM_12], instruction[`B_TYPE_IMM_11], instruction[`B_TYPE_IMM_10_5], instruction[`B_TYPE_IMM_4_1], 1'b0};

//sign-extend U
logic [`WORD_LEN-1:0] imm_U;
assign imm_U = {instruction[`U_TYPE_IMM_31_12], {(`WORD_LEN - 20) {1'b0}}};

//alu
logic [`WORD_LEN-1:0] alu_result;
logic alu_flag;
logic [`WORD_LEN-1:0] alu_A;
logic [`WORD_LEN-1:0] alu_B;

//program counter
logic [`WORD_LEN-1:0] PC;
logic [`WORD_LEN-1:0] pc_inc;
logic [`WORD_LEN-1:0] pc_inc_imm;

assign pc_inc_imm = branch_o ? imm_B : imm_J;
assign pc_inc = (jal_o || (alu_flag && branch_o)) ? pc_inc_imm : 4;

//instruction memory
instruction_memory #(`INSTR_WIDTH, `INSTR_DEPTH) block_instruction_memory(
    .A(PC),
    .RD(instruction)
);

//data memory
logic [`WORD_LEN-1:0] data_mem_rd;

//register file
logic [`WORD_LEN-1:0] regf_rd_1;
logic [`WORD_LEN-1:0] regf_rd_2;
logic [`WORD_LEN-1:0] regf_wd;

register_file #(`RF_WIDTH, `WORD_LEN) block_register_file(
    .CLK(CLK100MHZ),
    .A_1(instruction[`INSTR_RA1]),
    .A_2(instruction[`INSTR_RA2]),
    .A_3(instruction[`INSTR_WA]),
    .WD(regf_wd),
    .WE(gpr_we_a_o),
    .RD_1(regf_rd_1),
    .RD_2(regf_rd_2)
);

always_comb begin
    case (wb_src_sel_o)
        `WB_EX_RESULT: regf_wd <= alu_result;
        `WB_LSU_DATA: regf_wd <= data_mem_rd;
        default: regf_wd <= 0;
    endcase
end

//program counter
always_ff @(posedge CLK100MHZ or negedge CPU_RESETN) begin
    if(~CPU_RESETN)
        PC <= 1'b0;
    else begin
        if (jalr_o)
            PC <= regf_rd_1 + imm_I;
        else
            PC <= PC + pc_inc;
    end
end

//alu_A
always_comb begin
    case(ex_op_a_sel_o)
        `OP_A_RS1: alu_A <= regf_rd_1;
        `OP_A_CURR_PC: alu_A <= PC;
        `OP_A_ZERO: alu_A <= 1'b0;
        default: alu_A <= 1'b0;
    endcase
end

//alu_B
always_comb begin
    case(ex_op_b_sel_o)
        `OP_B_RS2: alu_B <= regf_rd_2;
        `OP_B_IMM_I: alu_B <= imm_I;
        `OP_B_IMM_U: alu_B <= imm_U;
        `OP_B_IMM_S: alu_B <= imm_S;
        `OP_B_INCR: alu_B <= 4;
        default: alu_B <= 1'b0;
    endcase
end

//alu
alu #(`WORD_LEN) block_alu(
    .ALUOp(alu_op_o),
    .A(alu_A),
    .B(alu_B),
    .Result(alu_result),
    .Flag(alu_flag)
);

//data memory
data_memory #(`INSTR_WIDTH, `INSTR_DEPTH) block_data_memory(
    .CLK(CLK100MHZ),
    .A(alu_result),
    .WD(regf_rd_2),
    .WE(mem_we_o),
    .RD(data_mem_rd)
);
    
endmodule