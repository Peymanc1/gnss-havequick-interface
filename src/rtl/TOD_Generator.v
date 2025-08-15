`timescale 1ns / 1ps

// Peyman Cibalı
// Day Of Year için artık yıl bayarğı oluşturmam lazım şubatın 29  veya 28 çektiğini bilmem gerekiyor.
//---------------------------------------------------------------------
// gps2utc_ff.v   (Fliegel–Van Flandern kapalı form)
//---------------------------------------------------------------------
// gps2utc_ff_clean.sv  —  tüm saatli bloklarda non-blocking
//----------------------------------------------------------------------
// gps2utc_ff.v   –   GPS WN/TOW  →  UTC  (HH,MM,SS, DOY, YY)
//   • rollover genişletme: EPOCH_INDEX parametresi
//   • leap-second düzeltmesi: LEAP_OFFSET parametresi
//   • Fliegel–Van Flandern kapalı formülü (tümü reg/wire, döngü yok)
//----------------------------------------------------------------------

`timescale 1ns/1ps

module gps2utc_ff #(
    parameter [1:0]  EPOCH_INDEX = 2'd2,   // 0:1980,1:1999,2:2019,3:2038
    parameter integer LEAP_OFFSET = 19     // ΔtLS saniye
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        start,           // 1-clk PPS tetik

    input  wire [9:0]  wn10,            // 10-bit Week Number
    input  wire [19:0] tow_sec,         // 0-604 799   (s)

    output reg       valid = 0,       // 1-clk puls
    output reg  [7:0]  hh = 0 ,
    output reg  [7:0]  mm = 0 , 
    output reg  [7:0]  ss = 0 ,
    output reg  [11:0]  doy = 0 ,         // 1-366
    output reg  [7:0]  yy  = 0          // 0-99    
);

    // ---- sabitler ---------------------------------------------------
    localparam [31:0] JD0 = 32'd2444244;   // 1980-01-06 00:00 UTC (0h JD)
    localparam [31:0] A   = 32'd68569;
    localparam [31:0] B   = 32'd146097;
    localparam [31:0] C   = 32'd1461001;
    localparam [31:0] D   = 32'd1461;
    localparam [31:0] E   = 32'd2447;
    localparam [31:0] F   = 32'd80;

    localparam [31:0] SEC_WEEK = 32'd604800;
    localparam [31:0] SEC_DAY  = 32'd86400;
    reg  [7:0]  hh = 0 ;
    reg  [7:0]  mm = 0 ; 
    reg  [7:0]  ss = 0 ;
    reg  [11:0]  doy = 0 ;         // 1-366
    reg  [7:0]  yy  = 0 ;         // 0-99

    // ---- rollover genişletme ---------------------------------------
    wire [15:0] wn_full = {EPOCH_INDEX, wn10};

    // ---- kombine (assign) hesaplar ---------------------------------
    wire [31:0] gps_sec = wn_full * SEC_WEEK + tow_sec ;
    wire [31:0] utc_sec = gps_sec - LEAP_OFFSET;

    // HH-MM-SS
    wire [31:0] sec_day  = utc_sec % SEC_DAY;
    wire [5:0]  hh_c     = sec_day / 32'd3600;
    wire [5:0]  mm_c     = (sec_day / 32'd60) % 6'd60;
    wire [5:0]  ss_c     = sec_day % 32'd60;

    // Fliegel–Van Flandern (kapalı form)
    wire [31:0] days     = utc_sec / SEC_DAY;
    wire [31:0] JDp      = days + JD0;          
    wire [31:0] L1       = JDp + A;             
    wire [31:0] N1       = (4*L1) / B;          
    wire [31:0] L2       = L1 - ((B*N1 + 3)/4); 
    wire [31:0] I1       = (4000*(L2+1)) / C;   
    wire [31:0] L3       = L2 - ((D*I1)/4) + 31;
    wire [31:0] J1       = (F*L3) / E;          
    wire [31:0] Day_c    = L3 - ((E*J1)/F) + 1; 
    wire [31:0] K1       = J1 / 11;             
    wire [31:0] Month_c  = J1 + 2 - 12*K1;      
    wire [15:0] Year_c   = 100*(N1-49) + I1 + K1; 

    // leap-year flag
    wire        leap_c   = ((Year_c % 4) == 0) &&
                           (((Year_c % 100) != 0) || ((Year_c % 400) == 0));

    // kümülatif gün (0-based)
    reg [15:0] cum_c;
    always @* begin
        case (Month_c)
            1:  cum_c = 0;
            2:  cum_c = 31;
            3:  cum_c = leap_c ? 60  : 59;
            4:  cum_c = leap_c ? 91  : 90;
            5:  cum_c = leap_c ? 121 : 120;
            6:  cum_c = leap_c ? 152 : 151;
            7:  cum_c = leap_c ? 182 : 181;
            8:  cum_c = leap_c ? 213 : 212;
            9:  cum_c = leap_c ? 244 : 243;
            10: cum_c = leap_c ? 274 : 273;
            11: cum_c = leap_c ? 305 : 304;
            default: cum_c = leap_c ? 335 : 334;   // December
        endcase
    end

    wire [8:0] doy_c  = cum_c + Day_c;     // 1-366
    wire [6:0] yy_c   = Year_c % 100;      // 0-99

    // ---- saat kenarında register’la --------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid <= 1'b0;
        end
        else begin
               valid <=1 ;
                hh  <= hh_c;
                mm  <= mm_c;
                ss  <= ss_c;
                doy <= doy_c;
                yy  <= yy_c;
            end
        end

    


endmodule
