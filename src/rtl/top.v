`timescale 1ns / 1ps



module top(
    input ready,
    input clk, 
    input dv_1,
    input dv_2,
    input dv_3 ,
    input dv_4 ,
    input dv_5,
    input [7:0] hh,
    input [7:0] mm,
    input [7:0] ss,
    input [11:0]doy,
    input [7:0] yy,
    output reg done,
    output reg [3:0] data=0,
    output reg od= 0 


    );
reg [3:0] mem [10:0] ;

localparam IDLE = 1'b0;
localparam DATA = 1'b1 ;
wire [3:0]hh_s = hh[3:0] ; 
wire [3:0]hh_m =hh[7:4];
wire [3:0]mm_m= mm[7:4] ;
wire [3:0]mm_s = mm[3:0];
wire [3:0]ss_m =ss[7:4];
wire [3:0]ss_s =ss[3:0];
wire [3:0]doy_m=doy[11:8];
wire [3:0]doy_d=doy[7:4];
wire [3:0]doy_s=doy[3:0];
wire [3:0]yy_m=yy[7:4];
wire [3:0]yy_s =yy[3:0];
wire a = dv_1 & dv_2 & dv_3 & dv_4 & dv_5 ;
reg state = 0 ;
reg [3:0]idx = 0 ;
reg valid = 0 ;
reg done= 0 ;

always@(posedge clk) begin
;
if(a)
valid<=1 ;
if(valid) begin
case(state) 

IDLE : begin


mem[0]<= hh_m ;
mem[1]<= hh_s ;
mem[2]<= mm_m ;
mem[3]<= mm_s ; 
mem[4]<= ss_m;
mem[5]<= ss_s ;
mem[6]<= doy_m;
mem[7]<= doy_d;
mem[8]<= doy_s ; 
mem[9]<= yy_m ;
mem[10]<=yy_s ; 
done <= 0 ;
state<= DATA ;
od<=1 ;
end


DATA : begin
if(!done & ready) begin

    data <= mem[idx];
    idx   <= idx + 1;

                if (idx == 10)begin

                    done <= 1;
                    valid<= 0 ;
                end
            end



end




endcase 
end
end 









endmodule
