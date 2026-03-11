`timescale 1ns/1ps

module transmitter(
	input clock, reset, wr_en, enb,
	input [7:0] data_in,
	output reg tx,
	output busy
);

parameter [1:0] state_idle = 2'b00,
		state_start = 2'b01,
		state_data = 2'b10,
		state_stop = 2'b11;

reg [7:0] data = 8'h00;
reg [2:0] bitpos = 3'h0;
reg [1:0] state = state_idle;

always @(posedge clock)
begin
	if(reset)
		tx<=1'b1;
end

always @(posedge clock)
begin
	case(state)
		state_idle:
		begin
			if(wr_en)
			begin
				state<=state_start;
				data<= data_in;
				bitpos <= 3'h0;
			end
		end
		
		state_start:
		begin
			if(enb)
			begin
				state<=state_data;
				tx<=1'b0;
			end
		end
		
		state_data:
		begin
			if(enb)
			begin
				if(bitpos == 3'h7)
					state<=state_stop;
				else
					bitpos = bitpos + 1;

				tx<=data[bitpos];
			end
		end

		state_stop:
		begin
			if(enb)
			begin
				state <= state_idle;
				tx<=1'b1;
			end
		end

		default:
		begin
			state<=state_idle;
			tx<=1'b1;
		end
	endcase
end

assign busy = (state != state_idle);
endmodule