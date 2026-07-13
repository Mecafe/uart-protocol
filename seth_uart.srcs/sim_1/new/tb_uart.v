`timescale 1ns/1ps
module tb_uart();

 reg clk_a,reset_a,wr_en_a,rd_en_a;
 reg [7:0]tx_data_a;
 wire tx_empty_a,rx_empty_a,tx_out_a;
 wire [7:0]rx_out_a;

 reg clk_b,reset_b,wr_en_b,rd_en_b;
 reg [7:0]tx_data_b;
 wire tx_empty_b,rx_empty_b,tx_out_b;
 wire [7:0]rx_out_b;


top_uart t1(clk_a,reset_a,tx_data_a,wr_en_a,rd_en_a,tx_out_b,tx_empty_a,tx_out_a,rx_empty_a,rx_out_a);

top_uart t2(clk_b,reset_b,tx_data_b,wr_en_b,rd_en_b,tx_out_a,tx_empty_b,tx_out_b,rx_empty_b,rx_out_b);

    always #5 clk_a = ~clk_a;
    always #5 clk_b = ~clk_b;


task send_byte_a(input [7:0] data_a);
        begin
            @(posedge clk_a);
            tx_data_a <= data_a;
            wr_en_a   <= 1'b1;
            @(posedge clk_a);
            wr_en_a   <= 1'b0;
        end
    endtask

    task read_byte_a;
        begin
            wait (rx_empty_a == 1'b0);
            $display("Time=%0t  Received data = %h", $time, rx_out_a);
            @(posedge clk_a);
            rd_en_a <= 1'b1;
            @(posedge clk_a);
            rd_en_a <= 1'b0;
        end
    endtask


task send_byte_b(input [7:0] data_b);
        begin
            @(posedge clk_b);
            tx_data_b <= data_b;
            wr_en_b   <= 1'b1;
            @(posedge clk_b);
            wr_en_b   <= 1'b0;
        end
    endtask

    task read_byte_b;
        begin
            wait (rx_empty_b == 1'b0);
            $display("Time=%0t  Received data = %h", $time, rx_out_b);
            @(posedge clk_b);
            rd_en_b <= 1'b1;
            @(posedge clk_b);
            rd_en_b <= 1'b0;
        end
    endtask
    
    
    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0, tb_uart);

        clk_a     = 0;
        reset_a   = 0;
        wr_en_a   = 0;
        rd_en_a   = 0;
        tx_data_a = 8'd0;


        clk_b     = 0;
        reset_b   = 0;
        wr_en_b   = 0;
        rd_en_b   = 0;
        tx_data_b = 8'd0;


        #20 reset_a = 1;
         reset_b = 1;

        send_byte_a(8'hF0);
        read_byte_b();

        send_byte_b(8'h0F);
        read_byte_a();
   fork
            begin
                send_byte_a(8'hF0);
                read_byte_a();   
            end
            begin
                send_byte_b(8'h0F);
                read_byte_b();   
            end
        join

        #2000000;
        $finish;
    end

endmodule