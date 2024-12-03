/*
	module name 	: long_div
	@ input			: num_in, R(= 2^len), modulus
	@ output		: ld_out
	@ description	: ld_out = (num_in * R) % modulus
*/
module long_div(
	clk, rstn, md_start, len, num_in, modulus,
	md_end, ld_out);

input clk, rstn, md_start;
input [7:0] len;
input [31:0] num_in, modulus;
output md_end;
output [31:0] ld_out;

	//Implement long division module

	parameter IDLE = 2'd0;
	parameter CALC = 2'd1;
	parameter DONE = 2'd2;

	reg md_end_reg;
	reg [31:0] ld_out_reg;

	assign md_end = md_end_reg;
	assign ld_out = ld_out_reg;

	reg [1:0] state;
	reg [1:0] next_state;

	reg [95:0] dividend;
	reg [95:0] divisor;
	
	reg [7:0] calc_iter;

	always @(posedge clk) begin
		if(!rstn) begin
			state <= IDLE;
		end
		else begin
			if(state == CALC) begin
				if(dividend >= divisor)
					dividend <= dividend - divisor;

				if(calc_iter != 0) begin
					divisor <= divisor >> 1;
					calc_iter <= calc_iter - 1;
				end
			end
			state <= next_state;
		end
	end

	always @(*) begin
		case(state)
			IDLE: begin
				if(md_start) begin
					next_state = CALC;
					dividend = {64'd0, num_in} << len;
					divisor = {64'd0, modulus} << (96 - len);
					calc_iter = 96 - len;
				end
			end
			CALC: begin
				if(calc_iter == 0)
					next_state = DONE;
			end
			DONE: begin
				next_state = IDLE;
			end
			default: begin
				next_state = IDLE;
			end
		endcase
	end

	always @(*) begin
		if(state == DONE) begin
			md_end_reg = 1;
			ld_out_reg = dividend[31:0];
		end
		else begin
			md_end_reg = 0;
			ld_out_reg = 0;
		end
	end


endmodule