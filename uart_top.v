`timescale 1ns/1ps
module uart_top(
	
	input rst,
	input [7:0] data_in,
	input wr_en, clk,
	input rdy_clr,
	output rdy, busy,
	output [7:0] data_out
);

wire rx_clk_en;
wire tx_clk_en;
wire tx_temp;

baud_rate_generator brg(
	.clock(clk),
	.reset(rst),
	.en_tx(tx_clk_en),
	.en_rx(rx_clk_en)
);

transmitter tm(
	.clock(clk),
	.wr_en(wr_en),
	.enb(tx_clk_en),
	.reset(rst),
	.data_in(data_in),
	.tx(tx_temp),
	.busy(busy)
);

uart_receiver urv(
	.clk(clk),
	.rx(tx_temp),
	.rdy_clr(rdy_clr),
	.rst(rst),
	.clk_en(rx_clk_en),
	.rdy(rdy),
	.data_out(data_out)
);

endmodule






