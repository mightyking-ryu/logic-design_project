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
			if(num_in[63])
    			pos = 0;
			else if(num_in[62])
			    pos = 63;
			else if(num_in[61])
			    pos = 62;
			else if(num_in[60])
			    pos = 61;
			else if(num_in[59])
			    pos = 60;
			else if(num_in[58])
			    pos = 59;
			else if(num_in[57])
			    pos = 58;
			else if(num_in[56])
			    pos = 57;
			else if(num_in[55])
			    pos = 56;
			else if(num_in[54])
			    pos = 55;
			else if(num_in[53])
			    pos = 54;
			else if(num_in[52])
			    pos = 53;
			else if(num_in[51])
			    pos = 52;
			else if(num_in[50])
			    pos = 51;
			else if(num_in[49])
			    pos = 50;
			else if(num_in[48])
			    pos = 49;
			else if(num_in[47])
			    pos = 48;
			else if(num_in[46])
			    pos = 47;
			else if(num_in[45])
			    pos = 46;
			else if(num_in[44])
			    pos = 45;
			else if(num_in[43])
			    pos = 44;
			else if(num_in[42])
			    pos = 43;
			else if(num_in[41])
			    pos = 42;
			else if(num_in[40])
			    pos = 41;
			else if(num_in[39])
			    pos = 40;
			else if(num_in[38])
			    pos = 39;
			else if(num_in[37])
			    pos = 38;
			else if(num_in[36])
			    pos = 37;
			else if(num_in[35])
			    pos = 36;
			else if(num_in[34])
			    pos = 35;
			else if(num_in[33])
			    pos = 34;
			else if(num_in[32])
			    pos = 33;
			else if(num_in[31])
			    pos = 32;
			else if(num_in[30])
			    pos = 31;
			else if(num_in[29])
			    pos = 30;
			else if(num_in[28])
			    pos = 29;
			else if(num_in[27])
			    pos = 28;
			else if(num_in[26])
			    pos = 27;
			else if(num_in[25])
			    pos = 26;
			else if(num_in[24])
			    pos = 25;
			else if(num_in[23])
			    pos = 24;
			else if(num_in[22])
			    pos = 23;
			else if(num_in[21])
			    pos = 22;
			else if(num_in[20])
			    pos = 21;
			else if(num_in[19])
			    pos = 20;
			else if(num_in[18])
			    pos = 19;
			else if(num_in[17])
			    pos = 18;
			else if(num_in[16])
			    pos = 17;
			else if(num_in[15])
			    pos = 16;
			else if(num_in[14])
			    pos = 15;
			else if(num_in[13])
			    pos = 14;
			else if(num_in[12])
			    pos = 13;
			else if(num_in[11])
			    pos = 12;
			else if(num_in[10])
			    pos = 11;
			else if(num_in[9])
			    pos = 10;
			else if(num_in[8])
			    pos = 9;
			else if(num_in[7])
			    pos = 8;
			else if(num_in[6])
			    pos = 7;
			else if(num_in[5])
			    pos = 6;
			else if(num_in[4])
			    pos = 5;
			else if(num_in[3])
			    pos = 4;
			else if(num_in[2])
			    pos = 3;
			else if(num_in[1])
			    pos = 2;
			else if(num_in[0])
			    pos = 1;
			else
			    pos = 0;
			next_md_end = 1;
		end
		else begin
			pos = 0;
			next_md_end = 0;
		end
	end

endmodule