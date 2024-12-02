module get_length_tb;
    // Registers and wires for testbench
    reg clk;
    reg rstn;
    reg md_start;
    reg [63:0] num_in;
    wire [7:0] len_out;
    wire md_end;

    // DUT instantiation
    get_length dut (
        .clk(clk),
        .rstn(rstn),
        .md_start(md_start),
        .num_in(num_in),
        .len_out(len_out),
        .md_end(md_end)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    // Test scenario
    initial begin
        // Save waveform (optional)
        $dumpfile("get_length_tb.vcd");
        $dumpvars(0, get_length_tb);

        // Initialization
        clk = 0;
        rstn = 0;
        md_start = 0;
        num_in = 64'd0;

        // 1. Activate reset signal
        @(posedge clk); // Wait for the first rising edge
        rstn = 1; // Deactivate reset

        // 2. First test case
        @(posedge clk);
        num_in = 64'd255;  // Input num_in = 255
        md_start = 1;      // Activate md_start
        @(posedge clk);
        md_start = 0;      // Deactivate md_start
        @(posedge clk);
        wait (md_end == 1); // Wait until md_end is HIGH
        $display("Test 1: num_in = %d, len_out = %d", num_in, len_out);

        // 3. Second test case
        @(posedge clk);
        num_in = 64'd1023; // Input num_in = 1023
        md_start = 1;      // Activate md_start
        @(posedge clk);
        md_start = 0;      // Deactivate md_start
        @(posedge clk);
        wait (md_end == 1); // Wait until md_end is HIGH
        $display("Test 2: num_in = %d, len_out = %d", num_in, len_out);

        // 4. Third test case (num_in = 0)
        @(posedge clk);
        num_in = 64'd0;    // Input num_in = 0
        md_start = 1;      // Activate md_start
        @(posedge clk);
        md_start = 0;      // Deactivate md_start
        @(posedge clk);
        wait (md_end == 1); // Wait until md_end is HIGH
        $display("Test 3: num_in = %d, len_out = %d", num_in, len_out);

        // End simulation
        @(posedge clk);
        $finish;
    end
endmodule
