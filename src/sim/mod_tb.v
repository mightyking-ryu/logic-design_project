`timescale 1ns/1ps

module mod_tb;

    reg clk;
    reg rstn;
    reg gen;
    reg [31:0] dividend;
    reg [31:0] divisor;
    wire gen_end;
    wire [31:0] mod_res;

    // DUT instance
    mod uut (
        .clk(clk),
        .rstn(rstn),
        .gen(gen),
        .dividend(dividend),
        .divisor(divisor),
        .gen_end(gen_end),
        .mod_res(mod_res)
    );

    // Clock generation: period of 10ns -> 100MHz
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk = 1;
        rstn = 0;
        gen = 0;
        dividend = 0;
        divisor = 0;

        // Power-on reset duration
        #20;
        rstn = 1;
        #10;
        
        // Test case 1
        // 100 % 10 = 0
        dividend = 100;
        divisor = 10;
        gen = 1;
        #15;
        gen = 0;

        // Wait until gen_end goes high
        wait(gen_end == 1);
        @(posedge clk);
        $display("Test 1: 100 %% 10 = %d, Expected = 0", mod_res);

        // Test case 2
        // 123 % 7 = 4
        dividend = 123;
        divisor = 7;
        gen = 1;
        #15;
        gen = 0;

        wait(gen_end == 1);
        @(posedge clk);
        $display("Test 2: 123 %% 7 = %d, Expected = 4", mod_res);

        // Test case 3
        // 999 % 1 = 0
        dividend = 999;
        divisor = 1;
        gen = 1;
        #15;
        gen = 0;

        wait(gen_end == 1);
        @(posedge clk);
        $display("Test 3: 999 %% 1 = %d, Expected = 0", mod_res);

        // Test case 4
        // 25 % 4 = 1
        dividend = 25;
        divisor = 4;
        gen = 1;
        #15;
        gen = 0;

        wait(gen_end == 1);
        @(posedge clk);
        $display("Test 4: 25 %% 4 = %d, Expected = 1", mod_res);

        // End of simulation
        $stop;
    end

endmodule