`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/22 14:48:24
// Design Name: 
// Module Name: Anti_aliasing_filter_top
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


module Anti_aliasing_filter_top(
    input clk,
    input rst_n,
    input clk_en_fir1,
    input signed [23:0] original_data_in,
    input valid_in,
    output signed [23:0] doublr_filter_out,
    output  data_valid,
    output signed [23:0] up_sample_data_out
    );

    wire signed [23:0] first_filter_out;
    wire signed [23:0] first_filter_down_out;
    wire valid_out;
    assign data_valid = valid_out;
    wire  [18:0] fir_cont;
    wire phase_27;
    // first filter
    /*
     filter_16k_para         filter_16k_para_inst(
        .clk                (clk),
        .clk_enable         (valid_in)    ,
        .rst_n              (!rst_n),
        .filter_in          (original_data_in),
        .filter_out         (),
        .filter_real_out    (first_filter_out)
    );
*/
// test
         filter_16k_para         filter_16k_serial_inst(
       .clk                (clk),
       .clk_enable         (clk_en_fir1)    ,
       .vaild_in            (valid_in),
       .rst_n              (!rst_n),
       .filter_in          (original_data_in),
       .filter_out         (),
       .filter_real_out    (first_filter_out),
       .phase_27        (phase_27)
       );
//test_end


    // Sampling average
    
    Sampling_average                                Sampling_average_inst(
        .clk                                                        (clk),
        .rst_n                                                     (rst_n),
        .data_in                                                (first_filter_out),
        .valid_in                                                 (phase_27),
        .sample_length                                     (8),
        .down_data_out                                    (first_filter_down_out),
        .valid_out                                               (valid_out)
    
        );


    //second filter out
    // (1/16000) / (1/25000000) = 1562.5
    // 1562.5/28 = 55.8036
    parameter CLKEN_PERIODS2 = 55;
    reg [10:0] clk_en_cont2;
    wire    clk_en_fir2;
    reg start;
        always @(posedge clk or negedge rst_n)
            begin  
                if (!rst_n)
                    begin
                        clk_en_cont2 <= 'd0;
                        start <= 1'b0;
                    end
                else
                    begin
                        if (valid_out)
                            start <= 1'b1;
                        else
                            start <= start;
                        if (start)
                            begin
                                if (clk_en_cont2 >= CLKEN_PERIODS2)
                                    begin
                                        clk_en_cont2 <= 'd0;
                                    end
                                else
                                    begin
                                        clk_en_cont2 <= clk_en_cont2 + 1'b1;
                                    end
                            end
                    end
            end
    assign clk_en_fir2 = (clk_en_cont2 >= CLKEN_PERIODS2 )? 1:0;
 
    filter_2k_para              filter_2k_serial_inst(
        .clk                    (clk),
        .clk_enable             (clk_en_fir2),
        .rst_n                  (!rst_n),
        .filter_in              (first_filter_down_out),
        .filter_out             (),
        .filter_real_out_2k     (doublr_filter_out)
    );
    
    
    // up sample
        up_sample                       up_sample_inst(
          . clk                                     (clk),
          . rst_n                                 (rst_n),
          . data_in                             (doublr_filter_out),
          . data_out                           (up_sample_data_out)
        );

    





endmodule
