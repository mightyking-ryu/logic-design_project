`timescale 1ns / 1ps

module Oblivious_Transfer_sender(
    input clk, reset,
    
    input rx_valid,
    output rx_ready,
    input [7:0] rx_data,
    
    output tx_valid,
    input tx_ready,
    output [7:0] tx_data

);

    //Implement sender side of oblivious transfer
    //You can define your own reg, wire ... etc
    reg rstn;
    reg prng_gen0;
    reg prng_gen1;
    reg [31:0] prng_N0;
    reg [31:0] prng_N1;
    wire [31:0] prng_q0;
    wire [31:0] prng_q1;
    reg [31:0] x0;
    reg [31:0] x1;
    wire prng_gen_end0;
    wire prng_gen_end1;
    reg rsa_gen;
    reg [31:0] message0;
    reg [31:0] message1;
    reg [31:0] rsa_N;
    reg [31:0] rsa_d;
    reg [31:0] rand_val0;
    reg [31:0] rand_val1;
    reg [31:0] received_data;
    wire [31:0] packed_data0;
    wire [31:0] packed_data1;
    wire rsa_gen_end;
    reg [31:0] N;
    reg [31:0] e;
    reg [31:0] d;
    reg [7:0] idx;
    reg [3:0] cycle_count;
    reg [31:0] packed_data0_reg;
    reg [31:0] packed_data1_reg;
    reg tx_valid_reg;
    reg [7:0] tx_data_reg;
    reg rx_ready_reg;
    assign tx_valid = tx_valid_reg;
    assign tx_data = tx_data_reg;
    assign rx_ready = rx_ready_reg;
    // reg [31:0] clk_count;
    // reg [3:0] data_count;

    pseudo_random RANDOM_GENERATOR_0(
        .clk  (clk),
        .rstn (rstn),
        .gen  (prng_gen0),
        .N    (prng_N0),
        .q    (prng_q0),
        .gen_end (prng_gen_end0)
    );

    pseudo_random RANDOM_GENERATOR_1(
        .clk  (clk),
        .rstn (rstn),
        .gen  (prng_gen1),
        .N    (prng_N1),
        .q    (prng_q1),
        .gen_end (prng_gen_end1)
    );
    sender_rsa_pack SENDER_RSA (
        .clk           (clk),
        .rstn          (rstn),
        .gen           (rsa_gen),
        .message0      (message0),
        .message1      (message1),
        .N             (rsa_N),
        .d             (rsa_d),
        .rand_val0     (rand_val0),
        .rand_val1     (rand_val1),
        .received_data (received_data),
        .packed_data0  (packed_data0),
        .packed_data1  (packed_data1),
        .gen_end       (rsa_gen_end)
    );
    reg [2:0] state;
    localparam IDLE = 3'b000;
    localparam PRNG = 3'b001;
    localparam SEND1 = 3'b010;
    localparam RECV = 3'b011;
    localparam ENCRYPT = 3'b100;
    localparam SEND2 = 3'b101;
    // localparam baudrate = 32'd115200;
    localparam def_N = 32'd128255609;
    localparam def_e = 32'd17;
    localparam def_d = 32'd75431153;
    localparam m0 = 32'd12345;
    localparam m1 = 32'd67890;
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            rstn <= 1'b0;
            prng_N0 <= 32'b1; // initial prng
            prng_N1 <= 32'b110; // initial prng
            N <= def_N;
            e <= def_e;
            d <= def_d;
        end
        else begin
            case(state)
                IDLE: begin
                    rstn <= 1'b1;
                    state <= PRNG;
                    prng_gen0 <= 1'b1;
                    prng_gen1 <= 1'b1;
                    tx_valid_reg <= 1'b0;
                end
                PRNG: begin
                    if (prng_gen0) prng_gen0 <= 1'b0;
                    if (prng_gen1) prng_gen1 <= 1'b0;
                    if (prng_gen_end0 && prng_gen_end1) begin
                        state <= SEND1;
                        x0 <= prng_q0;
                        x1 <= prng_q1;
                        idx <= 0;
                        cycle_count <= 4'b0;
                    end
                end
                SEND1: begin
                    // if (cycle_count == 4'b1111) cycle_count <= 4'b0000;
                    // else cycle_count <= cycle_count + 1;
                    if (tx_ready && tx_valid_reg == 0) begin
                        tx_valid_reg <= 1'b1;
                        case(idx)
                            8'd0: begin
                                tx_data_reg <= N[7:0]; 
                                idx <= idx + 1;
                            end
                            8'd1: begin
                                tx_data_reg <= N[15:8]; 
                                idx <= idx + 1;
                            end
                            8'd2: begin
                                tx_data_reg <= N[23:16]; 
                                idx <= idx + 1;
                            end
                            8'd3: begin
                                tx_data_reg <= N[31:24]; 
                                idx <= idx + 1;
                            end
                            8'd4: begin
                                tx_data_reg <= e[7:0]; 
                                idx <= idx + 1;
                            end
                            8'd5: begin
                                tx_data_reg <= e[15:8]; 
                                idx <= idx + 1;
                            end
                            8'd6: begin
                                tx_data_reg <= e[23:16]; 
                                idx <= idx + 1;
                            end
                            8'd7: begin
                                tx_data_reg <= e[31:24]; 
                                idx <= idx + 1;
                            end
                            8'd8: begin
                                tx_data_reg <= x0[7:0]; 
                                idx <= idx + 1;
                            end
                            8'd9: begin
                                tx_data_reg <= x0[15:8]; 
                                idx <= idx + 1;
                            end
                            8'd10: begin
                                tx_data_reg <= x0[23:16]; 
                                idx <= idx + 1;
                            end
                            8'd11: begin
                                tx_data_reg <= x0[31:24]; 
                                idx <= idx + 1;
                            end
                            8'd12: begin
                                tx_data_reg <= x1[7:0]; 
                                idx <= idx + 1;
                            end
                            8'd13: begin
                                tx_data_reg <= x1[15:8]; 
                                idx <= idx + 1;
                            end
                            8'd14: begin
                                tx_data_reg <= x1[23:16]; 
                                idx <= idx + 1;
                            end
                            8'd15: begin
                                tx_data_reg <= x1[31:24]; 
                                idx <= idx + 1;
                            end
                        endcase
                    end
                    else begin
                        tx_valid_reg <= 1'b0;
                        if(idx == 8'd16) begin
                            state <= RECV;
                            rx_ready_reg <= 1'b1; 
                            idx <= 0;
                        end
                    end
                end
                RECV: begin
                    if (rx_valid) begin
                        case(idx)
                            8'd0: begin
                                received_data[7:0] <= rx_data; 
                                idx <= idx + 1;
                            end
                            8'd1: begin
                                received_data[15:8] <= rx_data; 
                                idx <= idx + 1;
                            end
                            8'd2: begin
                                received_data[23:16] <= rx_data; 
                                idx <= idx + 1;
                            end
                            8'd3: begin
                                received_data[31:24] <= rx_data; 
                                idx <= 0; 
                                state <= ENCRYPT; 
                                rx_ready_reg <= 1'b0;
                                rsa_gen <= 1'b1;
                                message0 <= m0;
                                message1 <= m1;
                                rsa_N <= N;
                                rsa_d <= d;
                                rand_val0 <= x0;
                                rand_val1 <= x1;
                            end
                        endcase
                    end
                end
                ENCRYPT: begin
                    if (rsa_gen) rsa_gen <= 1'b0;
                    if (rsa_gen_end) begin
                        state <= SEND2;
                        packed_data0_reg <= packed_data0;
                        packed_data1_reg <= packed_data1;
                    end
                end
                SEND2: begin
                    // if (cycle_count == 4'b1111) cycle_count <= 4'b0000;
                    // else cycle_count <= cycle_count + 1;
                    if (tx_ready && tx_valid_reg == 0) begin
                        tx_valid_reg <= 1'b1;
                        case(idx)
                            8'd0: begin
                                tx_data_reg <= packed_data0_reg[7:0]; 
                                idx <= idx + 1;
                            end
                            8'd1: begin
                                tx_data_reg <= packed_data0_reg[15:8]; 
                                idx <= idx + 1;
                            end
                            8'd2: begin
                                tx_data_reg <= packed_data0_reg[23:16]; 
                                idx <= idx + 1;
                            end
                            8'd3: begin
                                tx_data_reg <= packed_data0_reg[31:24]; 
                                idx <= idx + 1;
                            end
                            8'd4: begin
                                tx_data_reg <= packed_data1_reg[7:0]; 
                                idx <= idx + 1;
                            end
                            8'd5: begin
                                tx_data_reg <= packed_data1_reg[15:8]; 
                                idx <= idx + 1;
                            end
                            8'd6: begin
                                tx_data_reg <= packed_data1_reg[23:16]; 
                                idx <= idx + 1;
                            end
                            8'd7: begin
                                tx_data_reg <= packed_data1_reg[31:24]; 
                                idx <= idx + 1;
                            end
                        endcase
                    end
                    else begin
                        tx_valid_reg <= 1'b0;
                        if(idx == 8'd8) begin
                            idx <= 0;
                            state <= IDLE;
                        end
                    end
                end

                default:;
            endcase
        end
    end
endmodule
