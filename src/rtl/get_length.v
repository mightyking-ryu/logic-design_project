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

	always @(posedge clk) begin
		if(!rstn) begin
			md_end_reg <= 0;
		end
		else begin
			if(md_start) begin
				num_reg <= num_in;
				md_end_reg <= 1;
			end
			else begin
				md_end_reg <= 0;
			end
		end
	end

	always @(*) begin
		if(md_end_reg) begin
			integer i;
			integer pos = 0;
			for(i = 63; i >= 0; i = i - 1) begin
				if(num_reg[i] == 1) begin
					pos = i + 1;
				end
			end
			len_reg = pos;
		end
		else begin
			len_reg = 0;
		end
	end

endmodule