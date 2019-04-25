`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/22 15:06:10
// Design Name: 
// Module Name: Sampling_average
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 128k数据进来抽样成128k / sample_length的数据长度
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Sampling_average(
    input clk,
    input rst_n,
    input [23:0] data_in,
    input valid_in,
//    input [18:0] sum_cont,
    input [7-1:0] sample_length,
    output reg [23:0] down_data_out,
    output reg valid_out

    );

    
reg [18:0] sum_cont;
    always@(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                sum_cont <= 'd0;
            else
                begin
                    if (valid_in)
                        begin
                            if (sum_cont >= sample_length-1)      // 0~7 
                                sum_cont <= 'd0;
                            else
                                sum_cont <= sum_cont + 1'b1;
                        end
                end
        end
  //

        
    reg valid_out_tmp;
    reg [40:0] sum_value;
    reg [24-1:0] down_data_tmp;
    always@(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                begin
                    valid_out_tmp <= 'd0;
                    sum_value <= 'd0;
                    down_data_tmp <= 'd0;
                end
            else if (valid_in)
                begin
                    if (sum_cont == sample_length-1)
                        begin
                            valid_out_tmp <= 1'b1;
                            down_data_tmp <= sum_value >> 3;
                            sum_value <= 'd0;
                        end
                    else
                        begin
                            sum_value <= sum_value + data_in;
                            down_data_tmp <= down_data_tmp;
                        end
                end
             else
                valid_out_tmp <= 1'b0;
        end

    always @(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                begin
                    down_data_out <= 'd0;
                end
            else if (valid_in)
                begin
                    down_data_out <= down_data_tmp;
                end
        end

    always @(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                begin
                    valid_out <= 1'b0;
                end
            else if (valid_in)
                begin
                    if (sum_cont == 'd0)
                        begin
                            valid_out <= 1'b1;
                        end
                    else
                        valid_out <= 1'b0;
                end
             else
                valid_out <= 1'b0;
           end





endmodule
