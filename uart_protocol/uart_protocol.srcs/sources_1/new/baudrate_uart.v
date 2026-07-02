module baudrate_uart(clk, reset, tx_en, rx_en);
input clk, reset, tx_en, rx_en;
reg [14:0] cnt_tx;
reg [10:0] cnt_rx;
output reg rx_en;
output reg tx_en;

always @(posedge clk or negedge reset)
begin
if(!reset)
begin
    cnt <= 0;
    rx_en <= 0;
    tx_en <= 0;
end
else
begin
    if(cnt_tx == 15'd5207)
    begin
        cnt_tx <= 0;
        tx_en <= 1;
    end
    else
    begin
        cnt_tx <= cnt_tx + 1;
        tx_en <= 0;
    end

    if(cnt_rx == 11'd2603)
    begin
        cnt_rx <= 0;
        rx_en <= 1;
    end
    else
    begin
        cnt_rx <= cnt_rx + 1;
        rx_en <= 0;
    end
end
end