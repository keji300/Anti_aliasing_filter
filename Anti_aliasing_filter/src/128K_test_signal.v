`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/22 16:45:53
// Design Name: 
// Module Name: 128K_test_signal
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//(1/128000) / (1/25000000) = 195.3125 个时钟来一个数据

module test_signal_128k(
    input clk,
    input rst_n,
    input start_read_rom,
    output  [12:0] rom_addr,
    output   [24-1:0] data_out,
    output reg start_flag,
    output reg clk_en
    
    );
    
    parameter SAMPLE_PERIODS = 195; //0~195 = 196
    parameter CLKEN_PERIODS = 6;        //0~6 = 7
    reg [9-1:0] adc_data_cont;
    reg [9-1:0] clk_en_cont;
    always @(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                begin
                    start_flag <= 1'b0;
                    clk_en_cont <= 'd0;
                    clk_en <= 1'b0;
                    adc_data_cont <= 'd0;
                end
            else
                begin   
                    if (start_read_rom)
                        begin
                            if (clk_en_cont >= CLKEN_PERIODS)
                                begin   
                                    clk_en_cont <= 'd0;
                                    clk_en <= 1'b1;
                                end
                            else
                                begin
                                    clk_en_cont <= clk_en_cont + 1'b1;
                                    clk_en <= 1'b0;
                                end
                            if (adc_data_cont >=SAMPLE_PERIODS )
                                begin
                                    adc_data_cont <= 'd0;
                                    start_flag <= 1'b1;
                                end
                            else
                                begin
                                    adc_data_cont <= adc_data_cont + 1'b1;
                                    start_flag <= 1'b0;
                                end
                        end
                end
        end
    
    test_128k_data_rom              test_128k_data_rom_inst(
    .clka                                                (clk),
    .ena                                                (start_read_rom),
    .addra                                            (rom_addr),    
    .douta                                            (data_out)
   
    );
        
    reg [12-1:0]addr_cnt1;
    assign rom_addr = addr_cnt1;
    always @(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                begin
                    addr_cnt1 <= 'd0;
                end
            else
            begin
             if (start_read_rom)
                addr_cnt1 <= addr_cnt1 + start_flag;
            else
                addr_cnt1 <= 0; 
            end
        end







endmodule
