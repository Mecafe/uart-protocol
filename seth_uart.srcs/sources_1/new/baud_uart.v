`timescale 1ns/1ps
module baud_uart(clk,reset,tx_clk,rx_clk);

input clk,reset;
output reg tx_clk,rx_clk;

reg[12:0]tx_count;
reg[8:0]rx_count;

always @(posedge clk or negedge reset)
begin
    if(reset==0)
    begin
        tx_clk <= 1'b0;
        rx_clk <= 1'b0;
        tx_count<=0;
        rx_count<=0;
    end
    else
    begin
        if(tx_count == 13'd5207)
        begin
            tx_clk <= 1;
            tx_count<=0;
        end
        else
        begin
            tx_count <= tx_count + 1'b1;
                        tx_clk <= 0;
        end
        if(rx_count == 9'd325)
        begin
            rx_clk <= 1;
            rx_count<=0;
        end
        else
        begin
            rx_count <= rx_count + 1'b1;
            rx_clk <= 0;
        end
    end
end
endmodule