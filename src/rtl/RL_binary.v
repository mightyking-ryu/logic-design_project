/*
	module name 	: RL_binary
	@ input			: base, exp, modulus
	@ output		: r
	@ description	: r = (base ^ exp) % modulus
*/

module mont_mul_combined(
	input clk, rstn, md_start, 
	input [31:0] a, b, n,
	output reg [31:0] mod,
	output reg md_end
);
	reg [31:0] a_reg;
	reg [31:0] b_reg;
	reg [31:0] n_reg;
	reg get_length_start;
	wire [7:0] len;
	reg [7:0] len_reg;
	wire get_length_end;
	wire get_long_div1_end;
	wire [31:0] long_div_out1;
	reg [31:0] long_div_out1_reg;
	wire get_long_div2_end;
	wire [31:0] long_div_out2;
	// reg [31:0] long_div_out2_reg;
	wire get_long_div_end;
	wire mont_mul_end1;
	wire [31:0] mont_mul_out1;
	reg [31:0] mont_mul_out1_reg;
	wire mont_mul_end2;
	wire [31:0] mont_mul_out2;
	// reg [31:0] mont_mul_out2_reg;

	


	get_length get_length_m(
		.clk(clk),
		.rstn(rstn),
		.md_start(get_length_start),
		.num_in({32'b0,n_reg}),
		.len_out(len), // output
		.md_end(get_length_end) // output
	);
	long_div long_div_m1(
		.clk(clk),
		.rstn(rstn),
		.md_start(get_length_end),
		.len(len),
		.num_in(a_reg),
		.modulus(n_reg),
		.md_end(get_long_div1_end), // output
		.ld_out(long_div_out1) // output
	);
	long_div long_div_m2(
		.clk(clk),
		.rstn(rstn),
		.md_start(get_long_div1_end),
		.len(len_reg),
		.num_in(b_reg),
		.modulus(n_reg),
		.md_end(get_long_div2_end), // output
		.ld_out(long_div_out2) // output
	);
	mont_mult mont_mul_m1(
		.clk(clk),
		.rstn(rstn),
		.md_start(get_long_div2_end),
		.len(len_reg),
		.num_1(long_div_out1_reg),
		.num_2(long_div_out2),
		.modulus(n_reg),
		.md_end(mont_mul_end1), // output
		.mm_out(mont_mul_out1) // output
	);
	mont_mult mont_mul_m2(
		.clk(clk),
		.rstn(rstn),
		.md_start(mont_mul_end1),
		.len(len_reg),
		.num_1(mont_mul_out1),
		.num_2(32'b1),
		.modulus(n_reg),
		.md_end(mont_mul_end2), // output
		.mm_out(mont_mul_out2) // output
	);
	always @(posedge clk) begin
		if (get_long_div1_end) long_div_out1_reg <= long_div_out1;
		if (get_length_end) len_reg <= len;
	end
	always @(posedge clk) begin
		if (!rstn) begin
			md_end <= 1'b0;
			get_length_start <= 1'b0;
		end
		else begin
			if (md_start) begin
				a_reg <= a;
				b_reg <= b;
				n_reg <= n;

				get_length_start <= 1'b1;
			end
			else begin
				get_length_start <= 1'b0;
			end
			if (mont_mul_end2) begin
				md_end <= 1'b1;
				mod <= mont_mul_out2;
			end
			else begin
				md_end <= 1'b0;
				mod <= 0;
			end
		end
	end
endmodule;




module RL_binary(
	clk, rstn, md_start, base, exp, modulus,
	r,md_end);

    input clk, rstn, md_start;
    input [31:0] base, exp, modulus;
    output reg [31:0] r;
    output md_end;

	reg [31:0] base_reg, exp_reg, modulus_reg;
	reg md_end_reg;
	assign md_end = md_end_reg;

	reg [1:0] state;
	localparam IDLE = 2'b00;
	localparam COMPUTE1 = 2'b01;
	localparam COMPUTE2 = 2'b10;
	
	reg modular1_start;
	reg [31:0] a;
	reg [31:0] b;
	wire [31:0] mod1;
	wire modular1_end;
	
	// reg modular2_start;
	// wire [31:0] mod2;
	// wire modular2_end;

	mont_mul_combined modular1(
		.clk(clk),
		.rstn(rstn),
		.md_start(modular1_start),
		.a(a),
		.b(b),
		.n(modulus_reg),
		.mod(mod1),
		.md_end(modular1_end)
	);
	// mont_mul_combined modular2(
	// 	.clk(clk),
	// 	.rstn(rstn),
	// 	.md_start(modular2_start),
	// 	.a(base_reg),
	// 	.b(base_reg),
	// 	.n(modulus_reg),
	// 	.mod(mod2),
	// 	.md_end(modular2_end)
	// );
	//Implement Right-to-Left Binary modular exponentation method
	//You will need get_length, montgomery multiplication, long division module to implement this module
	//Instantiate the modules that you need to build this module if needed.
	always @(posedge clk) begin
		if (!rstn) begin
			state <= IDLE;
			modular1_start <= 1'b0;
		end
		else begin
			case(state) 
				IDLE: begin
					md_end_reg <= 1'b0;
					if (md_start) begin
						base_reg <= base;
						exp_reg <= exp;
						modulus_reg <= modulus;
						state <= COMPUTE1;
						r <= 32'b1;
						modular1_start <= 1'b1;
						a <= 1;
						b <= base;
					end
				end
				COMPUTE1: begin
					if (modular1_start) modular1_start <= 1'b0;
					if (modular1_end) begin
						state <= COMPUTE2;
						modular1_start <= 1'b1;
						a <= base_reg;
						b <= base_reg;
						exp_reg <= exp_reg >> 1;
						if (exp_reg[0]) begin
							r <= mod1;
						end
					end
				end
				COMPUTE2: begin
					if (modular1_start) modular1_start <= 1'b0;
					if (modular1_end) begin
						if (exp_reg == 0) begin
							state <= IDLE;
							md_end_reg <= 1'b1;
						end
						else begin
							state <= COMPUTE1;
							modular1_start <= 1'b1;
							a <= r;
							b <= mod1;
							base_reg <= mod1;
						end
					end
				end
				default:;
			endcase
		end
	end

endmodule;