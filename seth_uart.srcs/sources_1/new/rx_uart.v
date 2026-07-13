`timescale 1ns/1ps 
module rx_uart(clk,reset,rx_clk,rd_en,rx_empty,rx_in,rx_out);

input clk,reset,rx_clk,rd_en,rx_in;
output reg rx_empty;
output reg [7:0]rx_out;

reg [1:0]p_s;
reg [7:0]rx_reg;
reg[2:0]count_zero;
reg[2:0]count;
reg[3:0]count_mid;

parameter IDLE=2'b00,START=2'B01,DATA=2'b10,STOP=2'b11;

always@(posedge clk or negedge reset)
begin
    if(reset==0)
    begin
        rx_empty<=1;
        rx_out<=8'd0;
        p_s<=2'b0;
        rx_reg<=8'd0;
        count<=3'd0;
        count_mid<=4'd0;
        count_zero<=3'd0;
    end
    else begin
        if(rd_en)
        begin
        rx_empty<=1;
        end
            if(rx_clk)
            
            begin
                case(p_s)
             IDLE: begin
                if(rx_in==0)
                begin
                  count_zero<=0;  
                 
                  p_s<=START;
                end
             end
             START:begin
                if(count_zero==3'd7) begin
                if(rx_in==0)begin
                    count_zero<=0;
                    count_mid<=0;
                    count<=0;
                    p_s<=DATA;
                end
                else begin
                p_s<=IDLE;
                end
             end
             else begin
             count_zero<=count_zero+1;
             end
             end
             DATA:
             begin
                if(count_mid==4'd15)begin
                 rx_reg[count]<=rx_in;
                 count_mid<=0;
                 if(count==3'd7)begin
                 p_s<=STOP;
                 count<=0;
                 end
                
                else begin
                    count<=count+1;
                end
             end
             else begin
             
             count_mid<=count_mid+1;
             end
             end
             STOP:begin
             if(count_mid==4'd15)begin
                count_mid<=0;
                rx_empty<=0;
                rx_out<=rx_reg;
                p_s<=IDLE;
             end
             else begin 
             count_mid<=count_mid+1;
             end
             end
               default:begin
                p_s<=IDLE;
               end
                endcase
            end
        
    end
end 
endmodule