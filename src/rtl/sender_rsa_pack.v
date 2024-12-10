module sender_rsa_pack(
    input clk, rstn, gen,
    input [31:0] message0, message1, N, d,
    input [31:0] rand_val0, rand_val1,
    input [31:0] received_data,
    output reg [31:0] packed_data0, packed_data1,
    output reg gen_end
    );

    //Implement sender_rsa_pack module
    //This module is used to compute packed messages on sender

    //You will need to use RL binary module
    //Use other modules if needed.
    reg [2:0] state;
    reg [31:0] message0_reg;
    reg [31:0] message1_reg;
    reg [31:0] N_reg;
    reg [31:0] d_reg;
    reg [31:0] rand_val0_reg;
    reg [31:0] rand_val1_reg;
    reg [31:0] received_data_reg;
    reg goto_COMP1;
    reg md_start;
    reg [31:0] base;
    reg [31:0] exp;
    reg [31:0] modulus;
    wire [31:0] r;
    wire md_end;
    reg mod_start;
    reg [31:0] dividend;
    reg [31:0] divisor;
    wire mod_end;
    wire [31:0] mod_res;

    mod u_mod(
        .clk(clk),
        .rstn(rstn),
        .gen(mod_start),
        .dividend(dividend),
        .divisor(divisor),
        .gen_end(mod_end),
        .mod_res(mod_res)
    );
    RL_binary u_RL_binary(
        .clk      (clk),
        .rstn     (rstn),
        .md_start (md_start),
        .base     (base),
        .exp      (exp),
        .modulus  (modulus),
        .r        (r),
        .md_end   (md_end)
    );
    localparam IDLE = 3'b000;
    localparam COMP1 = 3'b001;
    localparam MODULO1 = 3'b010;
    localparam COMP2 = 3'b011;
    localparam MODULO2 = 3'b100;
    always @(posedge clk) begin
        if (!rstn) begin
            state <= IDLE;
            goto_COMP1 <= 1'b0;
        end
        else begin
            case(state)
                IDLE: begin
                    if (gen) begin
                        message0_reg <= message0;
                        message1_reg <= message1;
                        N_reg <= N;
                        d_reg <= d;
                        rand_val0_reg <= rand_val0;
                        rand_val1_reg <= rand_val1;
                        received_data_reg <= received_data;
                        state <= COMP1;
                        md_start <= 1'b1;
                        base <= received_data > rand_val0 ? received_data - rand_val0 : rand_val0 - received_data; // abs value
                        exp <= d;
                        modulus <= N;
                    end
                    else begin
                        md_start <= 1'b0;
                        mod_start <= 1'b0;
                        gen_end <= 1'b0;
                    end
                end
                COMP1: begin
                    if (md_start) md_start <= 1'b0;
                    if (md_end) begin
                        state <= MODULO1;
                        mod_start <= 1'b1;
                        dividend <= received_data_reg > rand_val0_reg ? message0_reg + r : (d_reg[0] == 0 ? message0_reg + r : message0_reg + N - r);
                        divisor <= N_reg;
                        
                    end
                end
                MODULO1: begin
                    if (mod_start) mod_start <= 1'b0;
                    if (mod_end) begin
                        state <= COMP2;
                        md_start <= 1'b1;
                        packed_data0 <= mod_res;
                        base <= received_data_reg > rand_val1_reg ? received_data_reg - rand_val1_reg : rand_val1_reg - received_data_reg; // abs value
                    end
                end
                COMP2: begin
                    if (md_start) md_start <= 1'b0;
                    if (md_end) begin
                        state <= MODULO2;
                        dividend <= received_data_reg > rand_val1_reg ? message1_reg + r : (d_reg[0] == 0 ? message1_reg + r : message1_reg + N - r);
                        mod_start <= 1'b1;
                    end
                end
                MODULO2: begin
                    if (mod_start) mod_start <= 1'b0;
                    if (mod_end) begin
                        state <= IDLE;
                        packed_data1 <= mod_res;
                        gen_end <= 1'b1;
                    end
                end
                
                default:;
            endcase
        end
    end

    
endmodule

