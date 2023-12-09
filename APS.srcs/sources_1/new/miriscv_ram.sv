`timescale 1ns / 1ps

module miriscv_ram
#(
parameter RAM_SIZE = 1024,   // bytes
parameter RAM_INIT_FILE = "program.txt"
)(
// clock, reset
input clk_i,
input rst_n_i,

// instruction memory interface
output logic [31:0] instr_rdata_o,
input [31:0] instr_addr_i,

// data memory interface
output logic [31:0] data_rdata_o,
input data_req_i,
input data_we_i,
input [3:0] data_be_i,
input [31:0] data_addr_i,
input [31:0] data_wdata_i
);

logic [31:0] mem [0:RAM_SIZE/4-1];
logic [31:0] data_int;                                //???

//init RAM
initial begin
    if (RAM_INIT_FILE != "")
        $readmemh(RAM_INIT_FILE, mem);
    else
        $readmemh("init0.sv", mem);
end

// instruction port
assign instr_rdata_o = mem[(instr_addr_i % RAM_SIZE) / 4];

always@(posedge clk_i) begin
    if(!rst_n_i) begin
        data_rdata_o <= 32'b0;
    end
    
    else if(data_req_i) begin
        data_rdata_o <= mem[(data_addr_i  % RAM_SIZE) / 4];

        if(data_we_i && data_be_i[0])
            mem[data_addr_i[31:2]] [7:0]  <= data_wdata_i[7:0];

        if(data_we_i && data_be_i[1])
            mem[data_addr_i[31:2]] [15:8] <= data_wdata_i[15:8];

        if(data_we_i && data_be_i[2])
            mem[data_addr_i[31:2]] [23:16] <= data_wdata_i[23:16];

        if(data_we_i && data_be_i[3])
            mem[data_addr_i[31:2]] [31:24] <= data_wdata_i[31:24];

    end
end
    
endmodule