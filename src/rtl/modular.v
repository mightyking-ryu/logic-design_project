/*
   module name    : mod
   @ input         : dividend, divisor
   @ output      : mod_res
   @ description   : mod_res = dividend % divisor
*/

module mod(
    input clk,
    input rstn,
    input gen,
    input [31:0] dividend,
    input [31:0] divisor,
    output gen_end,
    output [31:0] mod_res
);

parameter IDLE = 2'd0;
parameter CALC = 2'd1;
parameter DONE = 2'd2;

reg [1:0] state;

reg [31:0] dividend_reg;
reg [62:0] divisor_reg;
reg gen_end_reg;
reg [31:0] mod_res_reg;

assign gen_end = gen_end_reg;
assign mod_res = mod_res_reg;

reg [4:0] bit_count;

always @(posedge clk) begin
    if(!rstn) begin
        state <= IDLE;
    end
    else begin
        case(state)
            IDLE: begin
                if(gen) begin
                    state <= CALC;
                    dividend_reg <= dividend;
                    divisor_reg <= {divisor, 31'd0};
                    bit_count <= 0;
                end
            end
            CALC: begin
                if(dividend_reg >= divisor_reg)
                    dividend_reg <= dividend_reg - divisor_reg;

                if(bit_count == 31) begin
                    state <= DONE;
                end
                else begin
                    divisor_reg <= divisor_reg >> 1;
                    bit_count <= bit_count + 1;
                end
            end
            DONE: begin
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

always @(*) begin
    if(state == DONE) begin
        mod_res_reg = dividend_reg;
        gen_end_reg = 1;
    end
    else begin
        mod_res_reg = 0;
        gen_end_reg = 0;
    end
end

endmodule