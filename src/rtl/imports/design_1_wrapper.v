//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
//Date        : Tue May 20 14:14:09 2025
//Host        : NTS5CG7433WHF running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (clk_0,
    manchester_out_0,
    rst_0,
    start_0,
    tow_sec_0,
    wn10_0);
  input clk_0;
  output manchester_out_0;
  input rst_0;
  input start_0;
  input [19:0]tow_sec_0;
  input [9:0]wn10_0;

  wire clk_0;
  wire manchester_out_0;
  wire rst_0;
  wire start_0;
  wire [19:0]tow_sec_0;
  wire [9:0]wn10_0;

  design_1 design_1_i
       (.clk_0(clk_0),
        .manchester_out_0(manchester_out_0),
        .rst_0(rst_0),
        .start_0(start_0),
        .tow_sec_0(tow_sec_0),
        .wn10_0(wn10_0));
endmodule
