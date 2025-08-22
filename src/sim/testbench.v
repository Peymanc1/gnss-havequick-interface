`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2025 01:32:22 PM
// Design Name: 
// Module Name: testbench
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


module testbench
;

reg clk_0;
reg rst_0;
reg start_0;
wire manchhester_out_0;
reg [9:0]wn10_0 ;
reg [19:0]tow_sec_0;


design_1_wrapper dut(
    .wn10_0(wn10_0),
    .tow_sec_0(tow_sec_0),
    .clk_0(clk_0),
    .manchester_out_0(manchester_out_0),
    .rst_0(rst_0),
    .start_0(start_0)



);

initial begin
    start_0 <= 0 ;
    rst_0 <= 1;
    clk_0<= 0;
    wn10_0 <= 10'd314;
    tow_sec_0 <= 20'd220007;
   #10 
   rst_0 <= 0 ;
   #20 start_0 <= 1 ;
  

    
end
integer scnt = 0;  // saniye sayacı
always @(posedge clk_0) begin
        if (rst_0) begin
            scnt  <= 0;
            start_0 <= 0;
        end else begin
            if (scnt == 99999999) begin
                start_0 <= 1;         // 1 clock genişliğinde darbe
                scnt  <= 0;
            end else begin
                start_0 <= 0;
                scnt  <= scnt + 1;
            end
        end
    end

always #5 clk_0= ~clk_0 ;


 





endmodule
