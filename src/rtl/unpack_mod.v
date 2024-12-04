module unpack_mod(
    input clk,rstn,sel_bit,gen,
    input [31:0] message0,message1,N,
    input [31:0] rand_val,
    output [31:0] unpack_res,
    output gen_end
    );

    //Implement unpack_mod module
    //This module calculates 
    //m_b = (m_b' -k) mod N
    //on receiver side

    parameter IDLE = 2'd0;
    parameter RL1 = 2'd1;
    parameter RL2 = 2'd2;
    parameter DONE = 2'd3;

    reg [1:0] state;

    reg [31:0] m_prime_reg, N_reg;
    reg [31:0] m_reg;

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
                        m_prime_reg <= sel_bit ? message1 : message0;

                        rl_start <= 1;
                        rl_base <= rand_val;
                        rl_exp <= 1;

                        state <= RL1;
                    end
                end
                RL1: begin
                    if(rl_end) begin
                        m_reg <= rl_result;

                        rl_start <= 1;
                        rl_base <= m_prime_reg;
                        rl_exp <= 1;

                        state <= RL2;
                    end
                    else begin
                        rl_start <= 0;
                    end
                end
                RL2: begin
                    if(rl_end) begin
                        if(m_reg > rl_result)
                            m_reg <= rl_result - m_reg + N_reg;
                        else
                            m_reg <= rl_result - m_reg;

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
            unpack_res = m_reg;
            gen_end = 1;
        end
        else begin
            unpack_res = 0;
            gen_end = 0;
        end
    end
       
endmodule
