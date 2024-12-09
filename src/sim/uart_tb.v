`timescale 1ns / 1ps
module uart_tb ();
    reg clk = 0;
    reg reset = 1;

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

    


    reg [7:0] msg [4:0];
    integer bit_count = 0;
    integer data_count = 0;
    
    reg [7:0] data_sent_by_fpga;
    reg [2:0] data_count_fpga;
    integer data_returned = 0;
    
    reg RsRx = 1'b1;
    wire RsTx;

    //Reset
    initial begin
        #3;
        //Simulation starts with reset
        reset = 1; 
        //Wait for 10 clock cycles for reset to be finished.
        #5500;
        reset = 0;

    end

    initial begin
        #5500;
        uart_start = 5500 + $random%5000;
        
        msg[0] = "H";
        msg[1] = "e";
        msg[2] = "l";
        msg[3] = "l";
        msg[4] = "o";

        //Random UART Rx start
        while ($time < (uart_start)) begin
            #1;
        end

        while (data_count < 5) begin
            //Send start bit
            RsRx = 1'b0;
            #8816;
            while (bit_count < 7) begin
                RsRx = msg[data_count][bit_count];
                #8816;
                bit_count = bit_count + 1;
            end
            RsRx = msg[data_count][7];
            #8816;
            RsRx = 1'b1;
            #8816;
            bit_count = 0;
            data_count = data_count + 1;
            
        end
        

    end
    
    
    uart_top UART(
        .clk  ( clk  ),
        .btnC ( reset ),
        .RsRx ( RsRx ),
        .RsTx  ( RsTx  )
    );

    

    //Check FPGA signals...
    initial begin
        #3;
        #5500;

        while (1'd1) begin
            @(negedge RsTx);
            #30;
            data_count_fpga = 0;
            #8816;#8816;
            while (data_count_fpga != 7) begin
                data_sent_by_fpga[data_count_fpga] = RsTx;
                data_count_fpga = data_count_fpga + 1;
                #8816;
            end
            data_sent_by_fpga[data_count_fpga] = RsTx;

            $display("0x%x  %c", data_sent_by_fpga, data_sent_by_fpga);

            data_returned = data_returned + 1;
            if (data_returned == 5) begin
                $display("[*]The simulation is complete. check waveforms");
                $stop;
            end
        end
        

    end


endmodule


module uart_top (
    //100MHz clock
    input clk,

    //Center button on push button
    //Use this as reset signal.
    input btnC,

    input RsRx,
    output RsTx
);

    wire UART_clk;

    //1.84MHz clock
    clock_divider DIVIDER (clk, UART_clk);

    wire valid, ready;
    wire [7:0] received_data;

    uart_receiver UART_RECEIVER(
        .uart_samplig_clk ( UART_clk ),
        .reset            ( btnC            ),
        .RsRx             ( RsRx             ),
        .valid            ( valid            ),
        .ready            ( ready            ),
        .received_data   ( received_data   )
    );

    uart_transmitter UART_TRANSMITTER(
        .uart_samplig_clk ( UART_clk ),
        .reset            ( btnC            ),
        .RsTx             ( RsTx             ),
        .valid            ( valid            ),
        .ready            ( ready            ),
        .data_to_xmit    ( received_data    )
    );
 
endmodule