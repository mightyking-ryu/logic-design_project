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



endmodule