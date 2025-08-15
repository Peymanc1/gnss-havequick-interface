//------------------------------------------------------------------
// bcd_source  –  12×4-bit RAM, doldurma “start” pulsunda
//------------------------------------------------------------------
module bcd_source_0 #(
    parameter N_NIBBLES = 12
)(
    input  wire       clk,
    input  wire       rst,

    input  wire       start,      // ► veriler hazır -› RAM’e yaz
    input  wire       ready,      // ◄ encoder handshake

    // 12 nibble giriş
    input  wire [3:0] hh_ms, hh_ls,
    input  wire [3:0] mm_ms, mm_ls,
    input  wire [3:0] ss_ms, ss_ls,
    input  wire [3:0] doy_ms, doy_ds, doy_ls,
    input  wire [3:0] yy_ms, yy_ls,

    output reg  [3:0] data  = 0,
    output reg        valid = 0,
    output reg        done  = 0
);
    /*----------- 12×4-bit senkron RAM -----------------------------*/
    reg [3:0] mem [0:N_NIBBLES-1];

    /*----------- 1)  start ↑  →  RAM’i tek clock’ta doldur --------*/
    always @(posedge clk) begin
      
            mem[0]  <= hh_ms;
            mem[1]  <= hh_ls;
            mem[2]  <= mm_ms;
            mem[3]  <= mm_ls;
            mem[4]  <= ss_ms;
            mem[5]  <= ss_ls;
            mem[6]  <= doy_ms;
            mem[7]  <= doy_ds;
            mem[8]  <= doy_ls;
            mem[9]  <= yy_ms;
            mem[10] <= yy_ls;
            mem[11] <= 4'd1;       // örnek sabit
   
    end
    /*----------- 2)  encoder’e sırayla servis et ------------------*/
    localparam AW = $clog2(N_NIBBLES);   // 4
    reg [AW-1:0] idx = 0;

    always @(posedge clk) begin
        if (rst) begin
            idx   <= 0;
            valid <= 0;
            done  <= 0;
        end else begin
            valid <= 0;

            if (!done && ready) begin
                data  <= mem[idx];   // RAM’den oku
                valid <= 1;
                idx   <= idx + 1;
                if (idx == N_NIBBLES-1)
                    done <= 1;
            end
            /* yeni start geldiğinde sıfırla */
            if (start) begin
                idx  <= 0;
                done <= 0;
            end
        end
    end
endmodule



           
     

  
  


