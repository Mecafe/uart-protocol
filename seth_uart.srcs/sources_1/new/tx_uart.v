`timescale 1ns/1ps 
module tx_uart(clk,reset,tx_clk,tx_data,wr_en,tx_empty,tx_out);

input clk,reset,tx_clk,wr_en;
input [7:0]tx_data;
output reg tx_empty;
output reg tx_out;

reg[7:0]tx_reg;
reg [2:0]tx_cnt;
reg [1:0]p_s;

parameter IDLE =2'b00, START =2'b01,DATA =2'b10,STOP =2'b11;

always @(posedge clk or negedge reset)
 begin
    if(reset==0)
    begin
        p_s <= IDLE;
        tx_out <= 1'b1;
        tx_empty <= 1'b1;
       p_s<=0;
       tx_reg<=0;       
        tx_cnt <= 3'd0;
    end
    else
    begin
if(p_s== IDLE&&wr_en&&tx_empty)
begin
    tx_reg<=tx_data;
    tx_empty<=0;
    p_s<=START;
 end

if(tx_clk)begin
  case(p_s)
     IDLE: begin
          tx_out <= 1'b1;
          end
     START: begin
         
         tx_cnt <= 3'd0;
         tx_out <= 1'b0;
         p_s<=DATA; 
         end
     DATA: begin
           tx_out<=tx_reg[tx_cnt];
         if(tx_cnt==3'd7)
         begin
         
          p_s<=STOP;    
           end
          else begin
            tx_cnt<=tx_cnt+1;   
            end
            end
     STOP: begin
         tx_out<=1;
         tx_empty<=1;   
         p_s<=IDLE;
         end
     default:begin
        p_s<=IDLE;
        end

  endcase
  end
end
end



endmodule