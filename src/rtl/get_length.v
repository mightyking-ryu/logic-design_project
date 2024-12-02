/*
	module name 	: get_length
	@ input			: num_in
	@ output		: len_out
	@ description	: len_out = length of num_in (ex: 1001 => 4)
*/
module get_length(
	clk, rstn, md_start, num_in, 
	len_out, md_end);

input clk, rstn, md_start;
input [63:0] num_in;
output [7:0] len_out;
output md_end;

	//Implement get_length module

	reg [7:0] len_reg;
	reg md_end_reg;

	assign len_out = len_reg;
	assign md_end = md_end_reg;

	reg [7:0] pos;
	reg next_md_end;

	always @(posedge clk) begin
		if(!rstn) begin
			len_reg <= 0;
			md_end_reg <= 0;
		end
		else begin
			len_reg <= pos;
			md_end_reg <= next_md_end;
		end
	end

	always @(*) begin
		if(md_start) begin

		end
		else begin
			pos = 0;
			next_md_end = 0;
		end
	end

endmodule

module get_length_8bit(
	input [7:0] num_in,
	output reg [3:0] len_out
);

	always @(*) begin
		if(num_in[7])
    		len_out = 4'd8;
		else if(num_in[6])
		    len_out = 4'd7;
		else if(num_in[5])
		    len_out = 4'd6;
		else if(num_in[4])
		    len_out = 4'd5;
		else if(num_in[3])
		    len_out = 4'd4;
		else if(num_in[2])
		    len_out = 4'd3;
		else if(num_in[1])
		    len_out = 4'd2;
		else if(num_in[0])
		    len_out = 4'd1;
		else
			len_out = 4'd0;
	end

endmodule