`timescale 1ns/1ps

module baud_rate_generator(
	input clock, reset,
	output reg en_rx, en_tx
);

parameter clk_freq = 100000000;
parameter baud_rate = 9600;
reg [15:0] counter_tx;
reg [15:0] counter_rx;

parameter divisor_tx = clk_freq/baud_rate;
parameter divisor_rx = clk_freq/(16*baud_rate);

always @(posedge clock or posedge reset)
begin 
	if(reset)
		begin
			counter_tx <= 0;
			en_tx <=0;
		end
	else if(counter_tx == divisor_tx - 1)
		begin
			counter_tx<=0;
			en_tx <=1;
		end
	else
		begin 	
			counter_tx<=counter_tx+1;
			en_tx<=0;
		end
end

always @(posedge clock or posedge reset)
begin 
	if(reset)
		begin
			counter_rx <= 0;
			en_rx <=0;
		end
	else if(counter_rx == divisor_rx - 1)
		begin
			counter_rx<=0;
			en_rx <=1;
		end
	else
		begin 	
			counter_rx<=counter_rx+1;
			en_rx<=0;
		end
end
endmodule


