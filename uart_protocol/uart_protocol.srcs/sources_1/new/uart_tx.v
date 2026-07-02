`timescale 1ns / 1ps

module uart_tx(clk,reset,wr_en,tx_din,ld_tx,tx_dout,tx_empty);
//INPUTS
input clk;input reset;input wr_en;input [7:0]tx_din;input ld_tx;
//OUTPUTS
output reg tx_dout;output reg tx_empty;
//PARAMETER AND REG
parameter [1:0]IDLE=2'd0,START=2'd1,DATA=2'd2,STOP=2'd3;
reg [1:0]p_s;
reg [2:0]cnt=0;
reg [7:0]tx_reg;
//LOGIC
always@ (posedge clk or negedge reset)
begin
if(reset==0) begin
             tx_dout<=1'b1;
             tx_empty<=1'b1;
             cnt<=3'b0;
             tx_reg<=8'd0;
             p_s<=IDLE;
             end
else
begin
// if(ld_tx && tx_empty ) begin
          tx_reg<=tx_din;
          tx_empty<=0;
          end
         
case(p_s)
IDLE: begin

      tx_dout<=1;
      // if(wr_en && !tx_empty)begin
           p_s<=START;
                  //     end
      //  else
      //  p_s<=IDLE;
      end
START:begin
      tx_dout<=0;
       p_s<=DATA;
      
      end
DATA: begin
      tx_dout<=tx_reg[cnt];
      
       if(cnt==3'd7) begin
           cnt<=0;
           p_s<=IDLE;
            end
       else begin
        cnt<=cnt+1;
        p_s<=DATA;
         end
      end 
STOP: begin
      tx_dout<=1;
      tx_empty<=1;
           p_s<=IDLE; 
      
      end
default: begin 
         p_s<=IDLE;
         
        
         end
endcase 
end

endmodule   