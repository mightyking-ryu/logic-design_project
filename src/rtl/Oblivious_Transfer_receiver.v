module Oblivious_Transfer_receiver(
    input clk, reset,

    input sel,
    
    input rx_valid,
    output rx_ready,
    input [7:0] rx_data,
    
    output tx_valid,
    input tx_ready,
    output [7:0] tx_data,

    output [31:0] unpack_res

);

    //Implement receiver side of oblivious transfer
    //You can define your own reg, wire ... etc

    // PRNG seed
    reg [31:0] seed = 32'd2555;

    // States
    parameter IDLE = 3'd0;
    parameter IN1 = 3'd1;
    parameter PRNG = 3'd2;
    parameter RSA = 3'd3;
    parameter OUT = 3'd4;
    parameter IN2 = 3'd5;
    parameter UNPACK = 3'd6;
    parameter DONE = 3'd7;

    reg [2:0] state;

    // Outputs
    reg rx_ready_reg;
    reg tx_valid_reg;
    reg [7:0] tx_data_reg;
    reg [31:0] unpack_res_reg;

    assign rx_ready = rx_ready_reg;
    assign tx_valid = tx_valid_reg;
    assign tx_data = tx_data_reg;
    assign unpack_res = unpack_res_reg;

    // Variables
    reg [31:0] N_reg, e_reg, x0_reg, x1_reg;
    reg [31:0] k_reg;
    reg [31:0] v_reg;
    reg [31:0] m0_prime_reg, m1_prime_reg;
    reg [31:0] m_reg;
    reg sel_reg;

    reg prng_start, rsa_start, up_start;
    wire prng_end, rsa_end, up_end;
    wire [31:0] prng_res, rsa_res, up_res;

    reg [1:0] variable_count;
    reg [1:0] byte_count;

    pseudo_random RANDOM_GENERATOR(
        .clk  ( clk ),
        .rstn ( !reset ),
        .gen  ( prng_start ),
        .N    ( seed ),
        .q    ( prng_res ),
        .gen_end ( prng_end )
    );

    receiver_rsa u_receiver_rsa(
        .clk            ( clk ),
        .rstn           ( !reset ),
        .sel_bit        ( sel_reg ),
        .gen            ( rsa_start ),
        .received_rand0 ( x0_reg ),
        .received_rand1 ( x1_reg ),
        .N              ( N_reg ),
        .pub_key        ( e_reg ),
        .rand_val       ( k_reg ),
        .mod_res        ( rsa_res ),
        .gen_end        ( rsa_end )
    );

    unpack_mod   u_unpack_mod(
        .clk        ( clk ),
        .rstn       ( !reset ),
        .sel_bit    ( sel_bit ),
        .gen        ( up_start ),
        .message0   ( m0_prime_reg ),
        .message1   ( m1_prime_reg ),
        .N          ( N_reg ),
        .rand_val   ( k_reg ),
        .unpack_res ( up_res ),
        .gen_end    ( up_end )
    );

    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            rx_ready_reg <= 1;
            tx_valid_reg <= 0;
        end
        else begin
            case(state)
                IDLE: begin
                    if(rx_valid) begin
                        sel_reg <= sel;

                        N_reg[7:0] <= rx_data;
                        variable_count <= 3;
                        byte_count <= 2;

                        state <= IN1;
                    end
                end
                IN1: begin
                    if(rx_valid) begin
                        case(variable_count)
                            3: begin
                                case(byte_count)
                                    2: begin
                                        N_reg[15:8] <= rx_data;
                                        byte_count <= 1;
                                    end
                                    1: begin
                                        N_reg[23:16] <= rx_data;
                                        byte_count <= 0;
                                    end
                                    0: begin
                                        N_reg[31:24] <= rx_data;
                                        variable_count <= 2;
                                        byte_count <= 3;
                                    end
                                endcase
                            end
                            2: begin
                                case(byte_count)
                                    3: begin
                                        e_reg[7:0] <= rx_data;
                                        byte_count <= 2;
                                    end
                                    2: begin
                                        e_reg[15:8] <= rx_data;
                                        byte_count <= 1;
                                    end
                                    1: begin
                                        e_reg[23:16] <= rx_data;
                                        byte_count <= 0;
                                    end
                                    0: begin
                                        e_reg[31:24] <= rx_data;
                                        variable_count <= 1;
                                        byte_count <= 3;
                                    end
                                endcase
                            end
                            1: begin
                                case(byte_count)
                                    3: begin
                                        x0_reg[7:0] <= rx_data;
                                        byte_count <= 2;
                                    end
                                    2: begin
                                        x0_reg[15:8] <= rx_data;
                                        byte_count <= 1;
                                    end
                                    1: begin
                                        x0_reg[23:16] <= rx_data;
                                        byte_count <= 0;
                                    end
                                    0: begin
                                        x0_reg[31:24] <= rx_data;
                                        variable_count <= 0;
                                        byte_count <= 3;
                                    end
                                endcase
                            end
                            0: begin
                                case(byte_count)
                                    3: begin
                                        x1_reg[7:0] <= rx_data;
                                        byte_count <= 2;
                                    end
                                    2: begin
                                        x1_reg[15:8] <= rx_data;
                                        byte_count <= 1;
                                    end
                                    1: begin
                                        x1_reg[23:16] <= rx_data;
                                        byte_count <= 0;
                                    end
                                    0: begin
                                        x1_reg[31:24] <= rx_data;

                                        rx_ready_reg <= 0;
                                        prng_start <= 1;
                                        state <= PRNG;
                                    end
                                endcase
                            end
                        endcase
                    end
                end
                PRNG: begin
                    if(prng_end) begin
                        k_reg <= prng_res;

                        prng_start <= 0;
                        rsa_start <= 1;

                        state <= RSA;
                    end
                end
                RSA: begin
                    if(rsa_end) begin
                        v_reg <= rsa_res;

                        rsa_start <= 0;
                        variable_count <= 1;
                        byte_count <= 3;

                        state <= OUT;
                    end
                end
                OUT: begin
                    if(variable_count == 1) begin
                        if(tx_ready) begin
                            tx_valid_reg <= 1;
                            case(byte_count)
                                3: begin
                                    tx_data_reg <= v_reg[7:0];
                                    byte_count <= 2;
                                end
                                2: begin
                                    tx_data_reg <= v_reg[15:8];
                                    byte_count <= 1;
                                end
                                1: begin
                                    tx_data_reg <= v_reg[23:16];
                                    byte_count <= 0;
                                end
                                0: begin
                                    tx_data_reg <= v_reg[31:24];

                                    variable_count <= 0;
                                end
                            endcase
                        end
                        else begin
                            tx_valid_reg <= 0;
                        end
                    end
                    else begin
                        tx_valid_reg <= 0;
                        rx_ready_reg <= 1;

                        variable_count <= 1;
                        byte_count <= 3;

                        state <= IN2;
                    end
                end
                IN2: begin
                    if(rx_valid) begin
                        case(variable_count)
                            1: begin
                                case(byte_count)
                                    3: begin
                                        m0_prime_reg[7:0] <= rx_data;
                                        byte_count <= 2;
                                    end
                                    2: begin
                                        m0_prime_reg[15:8] <= rx_data;
                                        byte_count <= 1;
                                    end
                                    1: begin
                                        m0_prime_reg[23:16] <= rx_data;
                                        byte_count <= 0;
                                    end
                                    0: begin
                                        m0_prime_reg[31:24] <= rx_data;
                                        variable_count <= 0;
                                        byte_count <= 3;
                                    end
                                endcase
                            end
                            0: begin
                                case(byte_count)
                                    3: begin
                                        m1_prime_reg[7:0] <= rx_data;
                                        byte_count <= 2;
                                    end
                                    2: begin
                                        m1_prime_reg[15:8] <= rx_data;
                                        byte_count <= 1;
                                    end
                                    1: begin
                                        m1_prime_reg[23:16] <= rx_data;
                                        byte_count <= 0;
                                    end
                                    0: begin
                                        m1_prime_reg[31:24] <= rx_data;

                                        rx_ready_reg <= 0;
                                        up_start <= 1;
                                        state <= UNPACK;
                                    end
                                endcase
                            end
                        endcase
                    end
                end
                UNPACK: begin
                    if(up_end) begin
                        m_reg <= up_res;

                        up_start <= 0;
                        state <= DONE;                        
                    end
                end
                DONE: begin
                    state <= DONE;
                end
                default: begin
                    state <= IDLE;
                    rx_ready_reg <= 1;
                    tx_valid_reg <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        if(state == DONE)
            unpack_res_reg = m_reg;
        else
            unpack_res_reg = 0;
    end


endmodule