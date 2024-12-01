/*
	module name 	: mont_mul
	@ input			: num_1, num_2, modulus
	@ output		: mm_out
	@ description	: mm_out = (num_1 * num_2 * R^-1) % modulus
*/
module mont_mult(
	clk, rstn, md_start, len, num_1, num_2, modulus,
	md_end, mm_out);

input clk, rstn, md_start;
input [7:0] len;
input [31:0] num_1, num_2, modulus;
output md_end;
output [31:0] mm_out;

	//Implement montgomery multiplication module



endmodule