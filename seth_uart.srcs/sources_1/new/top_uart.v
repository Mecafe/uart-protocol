`timescale 1ns/1ps 
module top_uart(clk,reset,tx_data,wr_en,rd_en,rx_in,tx_empty,tx_out,rx_empty,rx_out);
 
 input clk,reset,wr_en,rd_en,rx_in; 
 input [7:0]tx_data;
 output  tx_empty,rx_empty,tx_out;
 output [7:0]rx_out;
 

wire tx_clk,rx_clk;

baud_uart b1(clk,reset,tx_clk,rx_clk);
tx_uart t1(clk,reset,tx_clk,tx_data,wr_en,tx_empty,tx_out);
rx_uart r1(clk,reset,rx_clk,rd_en,rx_empty,rx_in,rx_out);

 
endmodule