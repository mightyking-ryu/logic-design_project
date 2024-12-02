`timescale 1ns/1ps

module pseudo_random(input  clk, rstn, gen, input [31:0] N, output [31:0] q, output gen_end);
    //Implement pseudo random number generator

    reg [31:0] shift_reg;
    reg gen_end_reg;

    assign q = shift_reg;
    assign gen_end = gen_end_reg;

    always @(posedge clk) begin
        if(!rstn) begin
            shift_reg <= N;
            gen_end_reg <= 0;
        end
        else begin
            if(gen) begin
                // Generate random number
                shift_reg <= {shift_reg[30:0], shift_reg[31] ^ shift_reg[21] ^ shift_reg[1] ^ shift_reg[0]};
                gen_end_reg <= 1;
            end
            else begin
                gen_end_reg <= 0;
            end
        end
    end

endmodule
