`timescale 1ns / 1ps

module register_file_testbench();

parameter PERIOD = 10;
localparam WIDTH = 32;
localparam DEPTH = 32;

logic clk;
logic [$clog2(DEPTH)-1:0] adress_1, adress_2, adress_3;
logic [WIDTH-1:0] wd;
logic we;
logic [WIDTH-1:0] rd_1;
logic [WIDTH-1:0] rd_2;

register_file dut(.CLK(clk), .A_1(adress_1), .A_2(adress_2), .A_3(adress_3),  .WD(wd), .WE(we), .RD_1(rd_1), .RD_2(rd_2));

always begin
clk = 1'b0;
#(PERIOD/2);
clk = 1'b1;
#(PERIOD/2);
end

initial begin
    int temp_data;
    
    adress_2 = 5'b0;
    @(posedge clk);
    #1;
    $display("Adress = 00000; Data = %b", rd_2); //покажем, что по адресу 0
    
    for(integer i = 1; i < DEPTH; i++) begin //потому что в нулевом адресе всегда лежит 0
        @(posedge clk);
        #1; //задержка в регистрах
        temp_data = $urandom();
        we = 1'b1;
        wd = temp_data; //подаем абсолютно рандомные данные(число)
        adress_3 = i;
        @(posedge clk);
        #1;
        we = 1'b0; //перестаем записывать
        
        adress_1 = i; //проверяем что записали по адресу i на предыдущем шаге
        @(posedge clk);
        #1;
        if(rd_1 != temp_data)
            $display("Bad");
        else
            $display("Good: adress = %b ; data_random = %b ; data_from_memory = %b", adress_1, temp_data[15:0], rd_1[15:0]);
    end
end
endmodule
