`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/22 17:25:33
// Design Name: 
// Module Name: test_signal_128k_tb
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


module test_signal_128k_tb;
    reg clk;
    reg rst_n;
    reg start_read_rom;
    wire [12:0] rom_addr;
    wire [23:0] data_out;
    wire start_flag;
    wire clk_en;
    wire clk_en_fir1;
    wire clk_en_fir2;
 test_signal_128k               test_signal_128k_inst(
   . clk                                            (clk),
   . rst_n                                         (rst_n),
   . start_read_rom                       (start_read_rom),
   . rom_addr                                 (rom_addr),
   . data_out                                   (data_out),
    .start_flag                                   (start_flag),
    .clk_en                                        (clk_en_fir1)
    
    );


//
wire [24-1:0] doublr_filter_out;
wire data_valid_Anti_aliasing_filter;
 Anti_aliasing_filter_top       Anti_aliasing_filter_top_inst(
     .clk                                         (clk),
     .rst_n                                     (rst_n),
     .clk_en_fir1                           (clk_en_fir1),
     .original_data_in                  (data_out),
     .valid_in                                 (start_flag),
     .doublr_filter_out                   (doublr_filter_out),
     .data_valid                            (data_valid_Anti_aliasing_filter)
    );

parameter CLK_PERIODS = 40;

initial 
    begin
        clk =0;
    end
    always #(CLK_PERIODS/2) clk =~ clk ;
    
initial 
    begin
        rst_n =0;
        #(CLK_PERIODS*2);
        rst_n = 1;
        start_read_rom = 1;
        
    end













endmodule
