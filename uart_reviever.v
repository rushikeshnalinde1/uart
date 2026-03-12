`timescale 1ns/1ps

module uart_receiver(
    input clk, rst, rx, rdy_clr, clk_en,
    output reg rdy,
    output reg [7:0] data_out
);

parameter rx_state_start = 2'b00,
          rx_state_data  = 2'b01,
          rx_state_stop  = 2'b10;

reg [1:0] state;
reg [3:0] sample;
reg [3:0] index;
reg [7:0] temp;

always @(posedge clk)
begin
    if(rst)
    begin
        rdy <= 0;
        data_out <= 0;
        state <= rx_state_start;
        sample <= 0;
        index <= 0;
        temp <= 0;
    end
    else
    begin
        if(rdy_clr)
            rdy <= 0;

        if(clk_en)
        begin
            case(state)

            // START BIT DETECTION
            rx_state_start:
            begin
                if(rx == 0)
                    sample <= sample + 1;
                else
                    sample <= 0;

                if(sample == 15)
                begin
                    state <= rx_state_data;
                    index <= 0;
                    sample <= 0;
                    temp <= 0;
                end
            end

            // DATA BIT RECEPTION
            rx_state_data:
            begin
                if(sample == 15)
                    sample <= 0;
                else
                    sample <= sample + 1;

                if(sample == 8)
                begin
                    temp[index] <= rx;
                    index <= index + 1;
                end

                if(index == 7 && sample == 15)
                    state <= rx_state_stop;
            end

            // STOP BIT
            rx_state_stop:
            begin
                if(sample == 15)
                begin
                    state <= rx_state_start;
                    data_out <= temp;
                    rdy <= 1'b1;
                    sample <= 0;
                end
                else
                    sample <= sample + 1;
            end

            default:
                state <= rx_state_start;

            endcase
        end
    end
end

endmodule