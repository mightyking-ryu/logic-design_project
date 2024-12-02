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

	reg md_end_reg;
	reg [31:0] ld_out_reg;

	assign md_end = md_end_reg;
	assign ld_out = ld_out_reg;

	reg next_md_end;
	reg next_ld_out;

	reg [95:0] dividend;
	reg [31:0] remainder;

	always @(posedge clk) begin
		if(!rstn) begin
			md_end_reg <= 0;
			ld_out_reg <= 0;
		end
		else begin
			md_end_reg <= next_md_end;
			ld_out_reg <= next_ld_out;
		end
	end

	always @(*) begin
		if(md_start) begin
			dividend = num_in << len;
		end
		else begin
			next_md_end = 0;
			next_ld_out = 0;
		end
	end


endmodule