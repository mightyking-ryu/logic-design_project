module uart_transmitter (
    input uart_samplig_clk,
    input reset,

    output reg RsTx,
    input valid,
    output ready,

    input [7:0] data_to_xmit
);
    reg [1:0] state;
    parameter IDLE = 2'b00;
    parameter XMIT = 2'b01;
    parameter END_XMIT = 2'b10;
    reg ready_reg;
    assign ready = ready_reg;
    reg [3:0] data_count;
    reg [3:0] clk_count;
    reg [7:0] xmit_save;
    always @(posedge uart_samplig_clk ) begin
        if (reset) begin
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    clk_count <= 4'b0;
                    data_count <= 3'b0;
                    if (valid == 1 && ready == 1) begin
                        RsTx <= 0;
                        ready_reg <= 0;

                        xmit_save <= data_to_xmit;
                        state <= XMIT;                        
                    end
                    else begin
                        RsTx <= 1;
                        ready_reg <= 1;
                    end
                end
                XMIT: begin
                    clk_count <= clk_count + 1;
                    if (clk_count == 4'b1111) begin
                        if (data_count == 4'b1000) begin
                            RsTx <= 1;
                            data_count <= data_count + 1;
                        end
                        else if (data_count == 4'b1001) begin
                            RsTx <= 1;
                            ready_reg <= 1;

                            state <= IDLE;
                        end
                        else begin
                            RsTx <= xmit_save[data_count];
                            data_count <= data_count + 1;
                        end
                    end
                end
            endcase
        end
    end

endmodule