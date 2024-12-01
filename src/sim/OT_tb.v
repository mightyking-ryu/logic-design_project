`timescale 1ns / 1ps

module OT_tb();

    reg clk = 0;
    reg reset = 1;
    reg [1:0] sw;
    

    integer cycle_count = 0;
    integer failcount = 0;

`define CHECK_OUTPUT(OUTPUT, EXPECT, ERR_MSG_FMT) if((OUTPUT) !== (EXPECT)) begin $display ERR_MSG_FMT; failcount = failcount + 1; end

    integer uart_start;

    //100MHz clcok generation
    always begin
        #5 clk = ~clk;
    end

    //Cycle count for clock
    always @(posedge clk ) begin
       cycle_count <= cycle_count + 1;
    end

    

    reg [31:0] msg[3:0];
    reg [31:0] N,e,d;
    integer bit_count = 0;
    integer data_count = 0;
    
    reg [7:0] data_sent_by_fpga;
    reg [3:0] data_count_fpga;
    reg [31:0] total_data[3:0];
    integer data_returned = 0;
    reg [2:0] tot_count_fpga;
    
    wire RsRx;
    wire RsTx;


    //Reset
    initial begin
        #10;
        //Simulation starts with reset
        reset = 1; 
        sw = 1;
        //Wait for 10 clock cycles for reset to be finished.
        #5500;
        reset = 0;

    end

    initial begin
        #5500;
        uart_start = 5500 + $random%5000;
        

    end
    

    //Check FPGA signals...
    initial begin
        #3;
        #5500;

        while (1'd1) begin
            @(negedge RsTx);
            #30;
            data_count_fpga = 0;
            tot_count_fpga = 0;
            #8816;#8816;
            while (data_count_fpga != 7) begin
                data_sent_by_fpga[data_count_fpga] = RsTx;
                data_count_fpga = data_count_fpga + 1;
                #8816;
            end
            data_sent_by_fpga[data_count_fpga] = RsTx;

            $display("0x%x ", data_sent_by_fpga, data_sent_by_fpga);
            
            total_data[tot_count_fpga] = {data_sent_by_fpga,total_data[tot_count_fpga][31:8]};

            data_returned = data_returned + 1;
            if (data_returned == 4) begin
                //$display("total data is 0x%x",total_data);
                tot_count_fpga = tot_count_fpga + 1;
            end
            if (tot_count_fpga == 4) begin
                 $display("[*]The simulation is complete. check waveforms");
                 $stop;
             end
        end
        

    end

    OT_top SENDER(clk,reset,2'b01,RsRx,RsTx);
    OT_top RECEIVER(clk,reset,2'b00,RsTx,RsRx);



endmodule
