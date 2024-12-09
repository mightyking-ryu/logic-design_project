// module mont_mult(
// 	clk, rstn, md_start, len, num_1, num_2, modulus,
// 	md_end, mm_out);

// 	input clk, rstn, md_start;
// 	input [7:0] len;
// 	input [31:0] num_1, num_2, modulus;
// 	output md_end;
// 	output [31:0] mm_out;

// 	parameter IDLE=2'b00;
// 	parameter COMPUTE=2'b01;

	
// 	reg [7:0] len_reg;
// 	reg [31:0] num_1_reg;
// 	reg [31:0] num_2_reg;
// 	reg [31:0] modulus_reg;
// 	reg md_end_reg;
// 	reg [31:0] mm_out_reg;
// 	assign md_end = md_end_reg;
// 	assign mm_out = mm_out_reg;

// 	reg [1:0] state;
// 	// reg [31:0] S1;
// 	// reg [31:0] S2;
// 	// reg [31:0] S3;
// 	// reg [31:0] S4;
// 	reg [7:0] idx;

// 	// always @(*) begin
// 	// 	S2 = S1 + num_1_reg[idx] * num_2_reg;
// 	// 	S3 = S2 + S2[0] * modulus_reg;
// 	// 	S4 = S3 >> 1;
// 	// end

// 	always @(posedge clk) begin
// 		if (!rstn) begin
// 			state <= IDLE;
// 		end
// 		else begin
// 			case(state)
// 				IDLE: begin
// 					// S1 <= 0;
// 					mm_out_reg <= 0;
// 					idx <= 0;
// 					md_end_reg <= 0;
// 					if (md_start) begin
// 						len_reg <= len;
// 						num_1_reg <= num_1;
// 						num_2_reg <= num_2;
// 						modulus_reg <= modulus;
// 						state <= COMPUTE;
// 					end
// 				end
// 				COMPUTE: begin
// 					if (idx == len_reg-1) begin
// 						md_end_reg <= 1'b1;
// 						mm_out_reg <= mm_out_reg > modulus_reg ? mm_out_reg - modulus_reg : mm_out_reg;
// 						state <= IDLE;
// 						idx <= 0;
// 					end
// 					else begin
// 						idx <= idx + 1;
// 						mm_out_reg <= mm_out_reg + num_1_reg[idx] * num_2_reg + (mm_out_reg[0] ^ (num_1_reg[idx] && num_2_reg[0])) * modulus_reg;

// 					end
// 				end
// 				default:;
// 			endcase
// 		end
// 	end
// endmodule;



module mont_mult(
	clk, rstn, md_start, len, num_1, num_2, modulus,
	md_end, mm_out);

	input clk, rstn, md_start;
	input [7:0] len;
	input [31:0] num_1, num_2, modulus;
	output md_end;
	output [31:0] mm_out;

	parameter IDLE=2'b00;
	parameter COMPUTE=2'b01;

	
	reg [7:0] len_reg;
	reg [31:0] num_1_reg;
	reg [31:0] num_2_reg;
	reg [31:0] modulus_reg;
	reg md_end_reg;
	reg [31:0] mm_out_reg;
	assign md_end = md_end_reg;
	assign mm_out = mm_out_reg;

	reg [1:0] state;
	reg [31:0] S1;
	reg [31:0] S2;
	reg [31:0] S3;
	reg [31:0] S4;
	reg [7:0] idx;

	always @(*) begin
		S2 = S1 + num_1_reg[idx] * num_2_reg;
		S3 = S2 + S2[0] * modulus_reg;
		S4 = S3 >> 1;
	end

	always @(posedge clk) begin
		if (!rstn) begin
			state <= IDLE;
		end
		else begin
			case(state)
				IDLE: begin
					S1 <= 0;
					idx <= 0;
					md_end_reg <= 0;
					if (md_start) begin
						len_reg <= len;
						num_1_reg <= num_1;
						num_2_reg <= num_2;
						modulus_reg <= modulus;
						state <= COMPUTE;
					end
				end
				COMPUTE: begin
					if (idx == len_reg - 1) begin
						md_end_reg <= 1'b1;
						mm_out_reg <= S4 > modulus_reg ? S4 - modulus_reg : S4;
						state <= IDLE;
						idx <= 0;
					end
					else begin
						idx <= idx + 1;
						S1 <= S4;
					end
				end
				default:;
			endcase
		end
	end
endmodule;

