`timescale 1ns / 1ps


//----------------------------------------------------------------------
// tb_gps2utc_ff.v  –  hızlı (10 Hz) PPS testi
//----------------------------------------------------------------------

`timescale 1ns/1ps

module tb_gps2utc_ff;
    // ----- parametreler ---------------------------------------------
    localparam CLK_PER = 100_000_000;  // 100 ms → 10 Hz PPS (hızlı)
    localparam SIM_SEC = 7;

    // ----- sinyaller -------------------------------------------------
    reg clk = 0, rst = 1, start = 0;

    reg [9:0]  wn10    = 10'd314;      
    reg [19:0] tow_sec = 20'd220007;   

    reg [2:0]  sub_cnt = 0;              // 0-5

    wire valid;
    wire [5:0] hh, mm, ss;
    wire [8:0] doy;
    wire [6:0] yy;

    // ----- DUT -------------------------------------------------------
    gps2utc_ff dut (
        .clk     (clk),
        .rst     (rst),
        .start   (start),
        .wn10    (wn10),
        .tow_sec (tow_sec),
        .valid   (valid),
        .hh      (hh),
        .mm      (mm),
        .ss      (ss),
        .doy     (doy),
        .yy      (yy)
    );

    // clock
    always #5 clk = ~clk;

    // test akışı
    integer i;
    initial begin
        #10 rst = 0;

        for (i = 0; i < SIM_SEC; i = i + 1) begin
            //----------------------------------------------------------
            start = 1;                       // PPS yüksel
            #20 start = 0;

            //----------------------------------------------------------
            // 6-s Z-count güncelle / ara saniye
            //----------------------------------------------------------
            if (sub_cnt == 3'd5) begin
                tow_sec = tow_sec + 6;       // yeni alt-çerçeve
                sub_cnt = 0;
            end else begin
                tow_sec = tow_sec + 1;       // ara saniye
                sub_cnt = sub_cnt + 1;
            end
            #(CLK_PER*9/10);
        end
        #500 $finish;
    end

    // gözlem
    always @(posedge clk)
        if (valid)
            $display("%0t  UTC  20%0d  DOY=%0d  %02d:%02d:%02d",
                     $time, yy, doy, hh, mm, ss);

endmodule
