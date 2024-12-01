/*
	module name 	: RL_binary
	@ input			: base, exp, modulus
	@ output		: r
	@ description	: r = (base ^ exp) % modulus
*/
module RL_binary(
	clk, rstn, md_start, base, exp, modulus,
	r,md_end);

    input clk, rstn, md_start;
    input [31:0] base, exp, modulus;
    output reg [31:0] r;
    output md_end;

	//Implement Right-to-Left Binary modular exponentation method
	//You will need get_length, montgomery multiplication, long division module to implement this module
	//Instantiate the modules that you need to build this module if needed.


    


endmodule