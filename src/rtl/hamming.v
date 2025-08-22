`timescale 1ns / 1ps


module ManchesterEncoder_HQII (
    input clk,   
               
    input reset,                                                                    
    input [95:0] time_msg,                                      
    input start,              
    output wire manchester_out // Manchester encoded çıkış
);

//Bu modül GPS ICD 060A içerisinde HaveQuick TOD formatının dışarı iletimi için kullanılan Manchester II biphase encode işlemini içerir. 
//ICD deki gibi önce 240 saniye boyunca 400 adet 1biti Manchester Encode'a göre modüle edilir ve karşı tarafa bu modülasyon ile yollanır. 
//Ardından 112 bitlik zaman mesajı aynı modülasyon işlemi ile 67.5 ms boyunca karşı tarafa iletilir. 
//Bu işlemler her PPS pulse'unda tekrarlanır. PPS pulse ı nun accurate olmasına gerek yok ancak tfom mesajında accuracy değerinin verilmesini sağlayacağım. /Bu kısımda external bir cihaz kullanılabilir tam düşünmedim burayı.
 

    reg manchester_out_r = 0;        // Manchester output register
    assign manchester_out = manchester_out_r; // Çıkışa atanır

    reg [31:0] counter_m = 0;       // Manchester encoding sayaç
    reg [20:0] bit_index = 0;       // Zaman mesajı bit sırası
    reg [31:0] start_counter = 0;   // Start counter
    reg [31:0] counter_400 = 0;     // 400 bit için sayaç
    reg [1:0] state = 0;            // Durum değişkeni

    localparam IDLE = 2'b00;
    localparam Message_State = 2'b10;
    localparam Valid_State = 2'b01;

   
    localparam COUNT_600_US = 60000; 
    localparam COUNT_400_BITS = 400; 
    
    reg [1:0] bit_send_count = 0;  // 400 bit süresi için sayaç
    reg [111:0] time_msg_r = 0 ;
    always @(posedge clk) begin
        case(state)
        IDLE: begin
            if(start) begin
                state <= Valid_State; 
                  
            end
        end

        Valid_State: begin
            
            if(counter_400 < COUNT_400_BITS) begin
                // İlk 300 mikro saniye boyunca manchester_out_r 1
                if(counter_m < (COUNT_600_US / 2)) begin
                    manchester_out_r <= 1;  // 1 için High
                end else if (counter_m < COUNT_600_US) begin
                    manchester_out_r <= 0;  
                end
                
                
            end
            if(counter_m == COUNT_600_US - 1) begin
                counter_m <= 0;
                counter_400 <= counter_400 + 1; // Sonraki bit
            end else begin
                counter_m <= counter_m + 1;
            end
            if(counter_400 >= 399) begin
                counter_m <= 0 ;
                counter_400 <= 0;
                time_msg_r <= {16'b0001000111101001,time_msg}  ; 
                state <= Message_State;  
            end
        end

        Message_State: begin
           
            // 600 mikro saniye boyunca her bitin Manchester encoding'i
            if(counter_m < (COUNT_600_US / 2)) begin
                if (time_msg_r[bit_index] == 1) begin
                    manchester_out_r <= 1; 
                end else begin
                    manchester_out_r <= 0; 
                end
            end
            else if(counter_m < COUNT_600_US) begin
                if (time_msg_r[bit_index] == 1) begin
                    manchester_out_r <= 0; // 1 için ikinci clock: Low
                end else begin
                    manchester_out_r <= 1; // 0 için ikinci clock: High
                end
            end

            // Bit tamamlandığında
            if(counter_m == COUNT_600_US - 1) begin
                counter_m <= 0;
                bit_index <= bit_index + 1; // Sonraki bit
            end else begin
                counter_m <= counter_m + 1;
            end
             if(bit_index==111)begin
                counter_m<=0 ;
                bit_index<=0;
                counter_400<= 0 ;
                state<=IDLE ;

        end
        end
       
        endcase
    //
    end
endmodule




