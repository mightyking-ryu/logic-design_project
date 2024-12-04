module receiver_rsa(
    input clk, rstn, sel_bit, gen,
    input  [31:0] received_rand0, received_rand1, N, pub_key, rand_val,
    output reg [31:0] mod_res,
    output reg gen_end
    );

    //Implement receiver_rsa module
    //This module is used to compute "v" value on receiver

    parameter IDLE = 2'd0;
    parameter RL1 = 2'd1;
    parameter RL2 = 2'd2;
    parameter DONE = 2'd3;

    reg [1:0] state;

    reg [31:0] x_reg, N_reg;
    reg [32:0] v_reg;

    reg rl_start;
    reg [31:0] rl_base, rl_exp;
    wire [31:0] rl_result;
    wire rl_end;

    //You will need to use RL binary module
    RL_binary u_RL_binary(
        .clk      ( clk ),
        .rstn     ( rstn ),
        .md_start ( rl_start ),
        .base     ( rl_base ),
        .exp      ( rl_exp ),
        .modulus  ( N_reg ),
        .r        ( rl_result ),
        .md_end   ( rl_end )
    );

    always @(posedge clk) begin
        if(!rstn) begin
            rl_start <= 0;
            state <= IDLE;
        end
        else begin
            case(state)
                IDLE: begin
                    if(gen) begin
                        N_reg <= N;
                        x_reg <= sel_bit ? received_rand1 : received_rand0;

                        rl_start <= 1;
                        rl_base <= rand_val;
                        rl_exp <= pub_key;

                        state <= RL1;
                    end
                end
                RL1: begin
                    if(rl_end) begin
                        v_reg <= rl_result;

                        rl_start <= 1;
                        rl_base <= x_reg;
                        rl_exp <= 1;

                        state <= RL2;
                    end
                    else begin
                        rl_start <= 0;
                    end
                end
                RL2: begin
                    if(rl_end) begin
                        if((v_reg + rl_result) >= N_reg)
                            v_reg <= v_reg + rl_result - N_reg;
                        else
                            v_reg <= v_reg + rl_result;

                        state <= DONE;
                    end
                    else begin
                        rl_start <= 0;
                    end
                end
                DONE: begin
                    rl_start <= 0;
                    state <= IDLE;
                end
                default: begin
                    rl_start <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
	
    always @(*) begin
        if(state == DONE) begin
            mod_res = v_reg[31:0];
            gen_end = 1;
        end
        else begin
            mod_res = 0;
            gen_end = 0;
        end
    end
	   
endmodule
