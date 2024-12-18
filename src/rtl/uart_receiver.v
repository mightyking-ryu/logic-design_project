module uart_receiver (
    input uart_samplig_clk,
    input reset,

    input RsRx,

    //Basic valid & ready handshake
    output valid,
    input ready,

    output reg [7:0] received_data
);

    //Implement UART receiver!

    //Receiver should use valid & ready handshake. 
    //Note that sampling clock is already 16x of baudrate.

    //Hint : Refer to lab06 and 07 code to implement each state for FSM using case statement...
    reg [1:0] state;
    parameter IDLE = 2'b00;
    parameter RECEIVING = 2'b01;
    parameter WAIT = 2'b10;

    reg valid_reg;
    assign valid = valid_reg;
    reg [3:0] data_count;
    reg [3:0] clk_count;
    always @(posedge uart_samplig_clk ) begin
        if (reset) begin
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    valid_reg <= 0;
                    clk_count <= 4'd7;
                    data_count <= 3'b0;
                    if (RsRx == 0) begin
                        state <= RECEIVING;
                    end
                end
                RECEIVING: begin
                    clk_count <= clk_count + 1;
                    if (clk_count == 4'b1111) begin
                        if (data_count == 4'b1001) begin
                            state <= WAIT;
                            data_count <= 4'b0;
                            valid_reg <= 1'b1;
                        end
                        else if (clk_count == 4'b0000) begin
                            data_count <= data_count + 1;
                        end
                        else begin
                            received_data[data_count - 1] <= RsRx;
                            data_count <= data_count + 1;
                        end
                    end
                end
                WAIT: begin
                    if (valid == 1 && ready == 1) begin
                        state <= IDLE;
                        valid_reg <= 0;
                    end
                end
            endcase
        end
    end

endmodule