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

	wire [3:0] pos_1, pos_2, pos_3, pos_4, pos_5, pos_6, pos_7, pos_8;

	get_length_8bit U1 (.num_in( num_in[7:0]   ), .len_out( pos_1 ));
	get_length_8bit U2 (.num_in( num_in[15:8]  ), .len_out( pos_2 ));
	get_length_8bit U3 (.num_in( num_in[23:16] ), .len_out( pos_3 ));
	get_length_8bit U4 (.num_in( num_in[31:24] ), .len_out( pos_4 ));
	get_length_8bit U5 (.num_in( num_in[39:32] ), .len_out( pos_5 ));
	get_length_8bit U6 (.num_in( num_in[47:40] ), .len_out( pos_6 ));
	get_length_8bit U7 (.num_in( num_in[55:48] ), .len_out( pos_7 ));
	get_length_8bit U8 (.num_in( num_in[63:56] ), .len_out( pos_8 ));

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
			if(pos_8 != 0)
				pos = pos_8 + 56;
			else if(pos_7 != 0)
				pos = pos_7 + 48;
			else if(pos_6 != 0)
				pos = pos_6 + 40;
			else if(pos_5 != 0)
				pos = pos_5 + 32;
			else if(pos_4 != 0)
				pos = pos_4 + 24;
			else if(pos_3 != 0)
				pos = pos_3 + 16;
			else if(pos_2 != 0)
				pos = pos_2 + 8;
			else
				pos = pos_1;
			
			next_md_end = 1;
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