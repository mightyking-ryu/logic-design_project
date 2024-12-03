`timescale 1ns / 1ps

module long_div_tb;

    // ====== Inputs ======
    reg clk;              // Clock signal
    reg rstn;             // Active-low reset
    reg md_start;         // Start signal
    reg [7:0] len;        // Length (log2(R))
    reg [31:0] num_in;    // Input number
    reg [31:0] modulus;   // Modulus

    // ====== Outputs ======
    wire md_end;          // End signal
    wire [31:0] ld_out;   // Output result

    // ====== Instantiate the long_div Module ======
    long_div uut (
        .clk(clk),
        .rstn(rstn),
        .md_start(md_start),
        .len(len),
        .num_in(num_in),
        .modulus(modulus),
        .md_end(md_end),
        .ld_out(ld_out)
    );

    // ====== Clock Generation: 10ns Period ======
    initial begin
        clk = 1;
        forever #5 clk = ~clk; // Clock period of 10ns (100MHz)
    end

    // ====== Test Sequence ======
    initial begin
        // Initialize Inputs
        rstn = 0;          // Assert reset
        md_start = 0;      // Deactivate start signal
        len = 0;
        num_in = 0;
        modulus = 0;

        // Apply Reset
        #10;
        rstn = 1;          // De-assert reset
        #10;

        // ===== Test Case 1 =====
        // Description: Calculate (10 * 16) % 11 = 160 % 11 = 6
        num_in = 32'd10;
        modulus = 32'd11;
        len = 8'd4;         // R = 2^4 = 16
        md_start = 1;      // Start the operation
        #10;
        md_start = 0;      // Deactivate start signal

        // Wait for Operation to Complete
        wait (md_end == 1);
        #10;
        $display("Test 1:");
        $display("num_in = %d, len = %d, modulus = %d", num_in, len, modulus);
        $display("Expected ld_out = (%d * %d) %% %d = %d", num_in, 2**len, modulus, (num_in * (2**len)) % modulus);
        $display("Actual ld_out = %d\n", ld_out);

        // ===== Test Case 2 =====
        // Description: Calculate (15 * 8) % 7 = 120 % 7 = 1
        num_in = 32'd15;
        modulus = 32'd7;
        len = 8'd3;         // R = 2^3 = 8
        md_start = 1;
        #10;
        md_start = 0;

        wait (md_end == 1);
        #10;
        $display("Test 2:");
        $display("num_in = %d, len = %d, modulus = %d", num_in, len, modulus);
        $display("Expected ld_out = (%d * %d) %% %d = %d", num_in, 2**len, modulus, (num_in * (2**len)) % modulus);
        $display("Actual ld_out = %d\n", ld_out);

        // ===== Test Case 3 =====
        // Description: Calculate (20 * 8) % 5 = 160 % 5 = 0
        num_in = 32'd20;
        modulus = 32'd5;
        len = 8'd3;         // R = 2^3 = 8
        md_start = 1;
        #10;
        md_start = 0;

        wait (md_end == 1);
        #10;
        $display("Test 3:");
        $display("num_in = %d, len = %d, modulus = %d", num_in, len, modulus);
        $display("Expected ld_out = (%d * %d) %% %d = %d", num_in, 2**len, modulus, (num_in * (2**len)) % modulus);
        $display("Actual ld_out = %d\n", ld_out);

        // ===== Test Case 4 =====
        // Description: Calculate (25 * 16) % 13 = 400 % 13 = 5
        num_in = 32'd25;
        modulus = 32'd13;
        len = 8'd4;         // R = 2^4 = 16
        md_start = 1;
        #10;
        md_start = 0;

        wait (md_end == 1);
        #10;
        $display("Test 4:");
        $display("num_in = %d, len = %d, modulus = %d", num_in, len, modulus);
        $display("Expected ld_out = (%d * %d) %% %d = %d", num_in, 2**len, modulus, (num_in * (2**len)) % modulus);
        $display("Actual ld_out = %d\n", ld_out);

        // ===== Test Case 5 =====
        // Description: Calculate (100 * 2) % 1 = 200 % 1 = 0 (Edge Case)
        num_in = 32'd100;
        modulus = 32'd1;
        len = 8'd1;         // R = 2^1 = 2
        md_start = 1;
        #10;
        md_start = 0;

        wait (md_end == 1);
        #10;
        $display("Test 5:");
        $display("num_in = %d, len = %d, modulus = %d", num_in, len, modulus);
        $display("Expected ld_out = (%d * %d) %% %d = %d", num_in, 2**len, modulus, (num_in * (2**len)) % modulus);
        $display("Actual ld_out = %d\n", ld_out);

        // ===== Test Case 6 =====
        // Description: Calculate (10 * 1) % 0 = Undefined (modulus = 0)
        num_in = 32'd10;
        modulus = 32'd0;
        len = 8'd0;         // R = 2^0 = 1
        md_start = 1;
        #10;
        md_start = 0;

        wait (md_end == 1);
        #10;
        $display("Test 6:");
        $display("num_in = %d, len = %d, modulus = %d", num_in, len, modulus);
        $display("Expected ld_out = Undefined (modulus = 0)");
        $display("Actual ld_out = %d\n", ld_out);

        // ===== Test Case 7 =====
        // Description: Calculate (0 * 16) % 10 = 0 % 10 = 0
        num_in = 32'd0;
        modulus = 32'd10;
        len = 8'd4;         // R = 2^4 = 16
        md_start = 1;
        #10;
        md_start = 0;

        wait (md_end == 1);
        #10;
        $display("Test 7:");
        $display("num_in = %d, len = %d, modulus = %d", num_in, len, modulus);
        $display("Expected ld_out = (%d * %d) %% %d = %d", num_in, 2**len, modulus, (num_in * (2**len)) % modulus);
        $display("Actual ld_out = %d\n", ld_out);

        // ===== Test Case 8 =====
        // Description: Calculate (14 * 16) % 15 = 224 % 15 = 14
        num_in = 32'd14;
        modulus = 32'd15;
        len = 8'd4;         // R = 2^4 = 16
        md_start = 1;
        #10;
        md_start = 0;

        wait (md_end == 1);
        #10;
        $display("Test 8:");
        $display("num_in = %d, len = %d, modulus = %d", num_in, len, modulus);
        $display("Expected ld_out = (%d * %d) %% %d = %d", num_in, 2**len, modulus, (num_in * (2**len)) % modulus);
        $display("Actual ld_out = %d\n", ld_out);

        // ===== Additional Test Cases =====
        // You can add more test cases as needed

        // ===== Simulation End =====
        #20;
        $finish;
    end

endmodule