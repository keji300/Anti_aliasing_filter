

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


//优化串行结构
`timescale 1 ns / 1 ns

module filter_16k_para
               (
                clk,                //串行结构 
                vaild_in,
                clk_enable,       //时钟为采样频率的阶数倍28 * 128k
                rst_n,
                filter_in,
                filter_out,
                filter_real_out,
                phase_27,
                fir_cont
                );
  input vaild_in; 
  input   clk; 
  input   clk_enable; 
  input   rst_n; 
  input   signed [23:0] filter_in; 
  output reg [18:0] fir_cont;
  output  signed [40:0] filter_out; 
   output  signed [23:0] filter_real_out;             
   output phase_27;
    assign filter_real_out  = filter_out [40:17];
////////////////////////////////////////////////////////////////

  parameter signed [15:0] coeff1 = 16'b0000000000110010; 
  parameter signed [15:0] coeff2 = 16'b0000000001100001; 
  parameter signed [15:0] coeff3 = 16'b1111111111100001; 
  parameter signed [15:0] coeff4 = 16'b1111111001111000; 
  parameter signed [15:0] coeff5 = 16'b1111110110111010; 
  parameter signed [15:0] coeff6 = 16'b0000000000001011; 
  parameter signed [15:0] coeff7 = 16'b0000010010110001; 
  parameter signed [15:0] coeff8 = 16'b0000010111100100; 
  parameter signed [15:0] coeff9 = 16'b1111111001001100; 
  parameter signed [15:0] coeff10 = 16'b1111001010000011; 
  parameter signed [15:0] coeff11 = 16'b1111001000111101; 
  parameter signed [15:0] coeff12 = 16'b0000101010000010; 
  parameter signed [15:0] coeff13 = 16'b0011010010010111; 
  parameter signed [15:0] coeff14 = 16'b0101010111111000; 
  parameter signed [15:0] coeff15 = 16'b0101010111111000; 
  parameter signed [15:0] coeff16 = 16'b0011010010010111; 
  parameter signed [15:0] coeff17 = 16'b0000101010000010; 
  parameter signed [15:0] coeff18 = 16'b1111001000111101; 
  parameter signed [15:0] coeff19 = 16'b1111001010000011; 
  parameter signed [15:0] coeff20 = 16'b1111111001001100; 
  parameter signed [15:0] coeff21 = 16'b0000010111100100; 
  parameter signed [15:0] coeff22 = 16'b0000010010110001; 
  parameter signed [15:0] coeff23 = 16'b0000000000001011; 
  parameter signed [15:0] coeff24 = 16'b1111110110111010; 
  parameter signed [15:0] coeff25 = 16'b1111111001111000; 
  parameter signed [15:0] coeff26 = 16'b1111111111100001; 
  parameter signed [15:0] coeff27 = 16'b0000000001100001; 
  parameter signed [15:0] coeff28 = 16'b0000000000110010; 

  // Signals
  reg  [4:0] cur_count; 
  wire phase_27; 
  wire phase_0; 
  reg  signed [23:0] delay_pipeline [0:27] ; 
  wire signed [23:0] inputmux_1; 
  reg  signed [40:0] acc_final; 
  reg  signed [40:0] acc_out_1; 
  wire signed [38:0] product_1; 
  wire signed [15:0] product_1_mux;
  wire signed [39:0] mul_temp; 
  wire signed [40:0] prod_typeconvert_1; 
  wire signed [40:0] acc_sum_1;
  wire signed [40:0] acc_in_1; 
  wire signed [40:0] add_signext; 
  wire signed [40:0] add_signext_1; 
  wire signed [41:0] add_temp;
  reg  signed [40:0] output_register; 

  
  always @ ( posedge clk)
    begin: Counter_process  //cont0~27  count = 0 add---- count = 27 mul
      if (rst_n == 1'b1) begin
        cur_count <= 5'b11011;
      end
      else begin
        if (clk_enable == 1'b1) begin
          if (cur_count == 5'b11011) begin
            cur_count <= 5'b00000;
          end
          else begin
            cur_count <= cur_count + 1;
          end
        end
      end
    end // Counter_process

  assign  phase_27 = (cur_count == 5'b11011 && clk_enable == 1'b1)? 1 : 0;

  assign  phase_0 = (cur_count == 5'b00000 && clk_enable == 1'b1)? 1 : 0;

  always @( posedge clk)
    begin: Delay_Pipeline_process
      if (rst_n == 1'b1) begin
        delay_pipeline[0] <= 0;
        delay_pipeline[1] <= 0;
        delay_pipeline[2] <= 0;
        delay_pipeline[3] <= 0;
        delay_pipeline[4] <= 0;
        delay_pipeline[5] <= 0;
        delay_pipeline[6] <= 0;
        delay_pipeline[7] <= 0;
        delay_pipeline[8] <= 0;
        delay_pipeline[9] <= 0;
        delay_pipeline[10] <= 0;
        delay_pipeline[11] <= 0;
        delay_pipeline[12] <= 0;
        delay_pipeline[13] <= 0;
        delay_pipeline[14] <= 0;
        delay_pipeline[15] <= 0;
        delay_pipeline[16] <= 0;
        delay_pipeline[17] <= 0;
        delay_pipeline[18] <= 0;
        delay_pipeline[19] <= 0;
        delay_pipeline[20] <= 0;
        delay_pipeline[21] <= 0;
        delay_pipeline[22] <= 0;
        delay_pipeline[23] <= 0;
        delay_pipeline[24] <= 0;
        delay_pipeline[25] <= 0;
        delay_pipeline[26] <= 0;
        delay_pipeline[27] <= 0;
      end
      else begin
        if (phase_27 == 1'b1  ) begin
          delay_pipeline[0] <= filter_in;
          delay_pipeline[1] <= delay_pipeline[0];
          delay_pipeline[2] <= delay_pipeline[1];
          delay_pipeline[3] <= delay_pipeline[2];
          delay_pipeline[4] <= delay_pipeline[3];
          delay_pipeline[5] <= delay_pipeline[4];
          delay_pipeline[6] <= delay_pipeline[5];
          delay_pipeline[7] <= delay_pipeline[6];
          delay_pipeline[8] <= delay_pipeline[7];
          delay_pipeline[9] <= delay_pipeline[8];
          delay_pipeline[10] <= delay_pipeline[9];
          delay_pipeline[11] <= delay_pipeline[10];
          delay_pipeline[12] <= delay_pipeline[11];
          delay_pipeline[13] <= delay_pipeline[12];
          delay_pipeline[14] <= delay_pipeline[13];
          delay_pipeline[15] <= delay_pipeline[14];
          delay_pipeline[16] <= delay_pipeline[15];
          delay_pipeline[17] <= delay_pipeline[16];
          delay_pipeline[18] <= delay_pipeline[17];
          delay_pipeline[19] <= delay_pipeline[18];
          delay_pipeline[20] <= delay_pipeline[19];
          delay_pipeline[21] <= delay_pipeline[20];
          delay_pipeline[22] <= delay_pipeline[21];
          delay_pipeline[23] <= delay_pipeline[22];
          delay_pipeline[24] <= delay_pipeline[23];
          delay_pipeline[25] <= delay_pipeline[24];
          delay_pipeline[26] <= delay_pipeline[25];
          delay_pipeline[27] <= delay_pipeline[26];
        end
      end
    end // Delay_Pipeline_process


  assign inputmux_1 = (cur_count == 5'b00000) ? delay_pipeline[0] :
                     (cur_count == 5'b00001) ? delay_pipeline[1] :
                     (cur_count == 5'b00010) ? delay_pipeline[2] :
                     (cur_count == 5'b00011) ? delay_pipeline[3] :
                     (cur_count == 5'b00100) ? delay_pipeline[4] :
                     (cur_count == 5'b00101) ? delay_pipeline[5] :
                     (cur_count == 5'b00110) ? delay_pipeline[6] :
                     (cur_count == 5'b00111) ? delay_pipeline[7] :
                     (cur_count == 5'b01000) ? delay_pipeline[8] :
                     (cur_count == 5'b01001) ? delay_pipeline[9] :
                     (cur_count == 5'b01010) ? delay_pipeline[10] :
                     (cur_count == 5'b01011) ? delay_pipeline[11] :
                     (cur_count == 5'b01100) ? delay_pipeline[12] :
                     (cur_count == 5'b01101) ? delay_pipeline[13] :
                     (cur_count == 5'b01110) ? delay_pipeline[14] :
                     (cur_count == 5'b01111) ? delay_pipeline[15] :
                     (cur_count == 5'b10000) ? delay_pipeline[16] :
                     (cur_count == 5'b10001) ? delay_pipeline[17] :
                     (cur_count == 5'b10010) ? delay_pipeline[18] :
                     (cur_count == 5'b10011) ? delay_pipeline[19] :
                     (cur_count == 5'b10100) ? delay_pipeline[20] :
                     (cur_count == 5'b10101) ? delay_pipeline[21] :
                     (cur_count == 5'b10110) ? delay_pipeline[22] :
                     (cur_count == 5'b10111) ? delay_pipeline[23] :
                     (cur_count == 5'b11000) ? delay_pipeline[24] :
                     (cur_count == 5'b11001) ? delay_pipeline[25] :
                     (cur_count == 5'b11010) ? delay_pipeline[26] :
                     delay_pipeline[27];

  //   ------------------ Serial partition # 1 ------------------

  assign product_1_mux = (cur_count == 5'b00000) ? coeff1 :
                        (cur_count == 5'b00001) ? coeff2 :
                        (cur_count == 5'b00010) ? coeff3 :
                        (cur_count == 5'b00011) ? coeff4 :
                        (cur_count == 5'b00100) ? coeff5 :
                        (cur_count == 5'b00101) ? coeff6 :
                        (cur_count == 5'b00110) ? coeff7 :
                        (cur_count == 5'b00111) ? coeff8 :
                        (cur_count == 5'b01000) ? coeff9 :
                        (cur_count == 5'b01001) ? coeff10 :
                        (cur_count == 5'b01010) ? coeff11 :
                        (cur_count == 5'b01011) ? coeff12 :
                        (cur_count == 5'b01100) ? coeff13 :
                        (cur_count == 5'b01101) ? coeff14 :
                        (cur_count == 5'b01110) ? coeff15 :
                        (cur_count == 5'b01111) ? coeff16 :
                        (cur_count == 5'b10000) ? coeff17 :
                        (cur_count == 5'b10001) ? coeff18 :
                        (cur_count == 5'b10010) ? coeff19 :
                        (cur_count == 5'b10011) ? coeff20 :
                        (cur_count == 5'b10100) ? coeff21 :
                        (cur_count == 5'b10101) ? coeff22 :
                        (cur_count == 5'b10110) ? coeff23 :
                        (cur_count == 5'b10111) ? coeff24 :
                        (cur_count == 5'b11000) ? coeff25 :
                        (cur_count == 5'b11001) ? coeff26 :
                        (cur_count == 5'b11010) ? coeff27 :
                        coeff28;
  assign mul_temp = inputmux_1 * product_1_mux;
  assign product_1 = mul_temp[38:0];

  assign prod_typeconvert_1 = $signed({{2{product_1[38]}}, product_1});

  assign add_signext = prod_typeconvert_1;
  assign add_signext_1 = acc_out_1;
  assign add_temp = add_signext + add_signext_1;
  assign acc_sum_1 = add_temp[40:0];

  assign acc_in_1 = (phase_0 == 1'b1) ? prod_typeconvert_1 :
                   acc_sum_1;

  always @ ( posedge clk)
    begin: Acc_reg_1_process
      if (rst_n == 1'b1) begin
        acc_out_1 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          acc_out_1 <= acc_in_1;
        end
      end
    end // Acc_reg_1_process

  always @ ( posedge clk)
    begin: Finalsum_reg_process
      if (rst_n == 1'b1) begin
        acc_final <= 0;
      end
      else begin
        if (phase_0 == 1'b1) begin
          acc_final <= acc_out_1;
        end
      end
    end // Finalsum_reg_process
//

  always @ ( posedge clk)
    begin: Output_Register_process
      if (rst_n == 1'b1) begin
       fir_cont <= 'd0;
        output_register <= 0;
      end
      else begin
        if (phase_27 == 1'b1) begin
            if (fir_cont >= 'd8)
                begin
                    fir_cont <= 'd0;
                end
            else
                fir_cont <= fir_cont + 1'b1;
          output_register <= acc_final;
        end
      end
    end // Output_Register_process

  assign filter_out = output_register;
endmodule  
