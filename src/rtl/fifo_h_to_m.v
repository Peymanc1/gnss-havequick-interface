`timescale 1ns / 1ps

module hamming_encoder #(
    parameter integer MAX_BYTES = 12               // product genişliği = 8×MAX_BYTES
)(
    input  wire                       clk,
    input  wire                       rst,
    input  wire                       od,

    /*-------------------- 4‑bit giriş handshake -----------------------*/
    input  wire        [3:0]          data,
    input  wire                       done,      // kaynaktan
    output reg                        ready = 1,  // kabul edebilirim?

    /*-------------------- çıktı‑tarafı --------------------------------*/
    output wire        [7:0]          encoded,    // son üretilen byte (izleme için)
    output reg [MAX_BYTES*8-1:0]      product = 0,
    output reg [3:0] byte_cnt = 0,
    output reg                        product_valid = 0
);
    /*-------------------- Hamming (8,4) kodlayıcı ---------------------*/
    wire p1 = data[0] ^ data[1] ^ data[3];
    wire p2 = data[0] ^ data[2] ^ data[3];
    wire p4 = data[1] ^ data[2] ^ data[3];
    wire p8 = p1 ^ p2 ^ p4 ^ data[0] ^ data[1] ^ data[2] ^ data[3];

    wire [7:0] enc_next = {p8, data[3], data[2], data[1], p4, data[0], p2, p1};
    assign encoded = enc_next;

    /*-------------------- Byte sayacı ----------------------------------*/
    localparam C_W = $clog2(MAX_BYTES);
    

    /*-------------------- Ana süreç -----------------------------------*/
    always @(posedge clk) begin
        if (rst) begin
            byte_cnt      <= 0;
            product       <= 0;
            product_valid <= 0;
            ready         <= 1;
        end else begin
            product_valid <= 0;               // tek‑cycle puls

            /* Kabul edebilecek miyim? */
            ready <= (byte_cnt < MAX_BYTES);
            if(od) begin
            /* El sıkışma: valid & ready aynı cycle’da 1 ise */
            if (!done && ready) begin
                product[byte_cnt*8 +: 8] <= enc_next;
                byte_cnt <= byte_cnt + 1;

                /* Tampon doldu mu? */
                if (byte_cnt == MAX_BYTES-1) begin
                    product_valid <= 1;       // bir clock’ta 1
                    byte_cnt      <= 0;       // başa döneriz
                   ready<= 0 ; 
                end
            end
        end
    end
    end

endmodule

    
    
    
    
    
    
    

