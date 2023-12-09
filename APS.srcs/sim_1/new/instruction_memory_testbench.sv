`timescale 1ns / 1ps

module instruction_memory_testbench();

localparam WIDTH = 32;
localparam DEPTH = 256;

logic [$clog2(DEPTH)-1:0] adress;
logic [WIDTH-1:0] data;

instruction_memory dut(.A(adress), .RD(data));

integer file_prog;
logic [WIDTH-1:0] new_data;
logic temp;

initial
    file_prog = $fopen("prog.txt", "r");
    
initial begin
    for(integer i = 0; i < DEPTH; i++) begin //������ ����� 7, �.�. � ����� ����� 8 ��������
        //adress = $urandom()%7; //�� �������, �.�. fscanf ��������� ������ �� �������, ����� ��� random ����������� �� �������
        adress = i;
        $fscanf(file_prog, "%b", new_data);
        #10;
        if(new_data === data) begin
            $display($time, "Good!  adress = %d, data_tb = %b, memory = %b", adress, new_data, data);
        end
        else begin
            $display($time, "Bad!  adress = %d, data_tb = %b, memory = %b", adress, new_data, data);
        end
    end
    $fclose(file_prog);
end

endmodule
