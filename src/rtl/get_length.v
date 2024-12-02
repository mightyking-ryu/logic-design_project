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

	reg [63:0] num_reg;
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
			integer i;
			for(i = 63; i >= 0; i = i - 1) begin
				if(num_reg[i] == 1 && pos == 0) begin
					pos = i + 1;
				end
			end
			next_md_end = 1;
		end
		else begin
			pos = 0;
			next_md_end = 0;
		end
	end

endmodule