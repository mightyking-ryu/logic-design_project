module uart_receiver (
    input uart_samplig_clk,
    input reset,

    input RsRx,

    //Basic valid & ready handshake
    output valid,
    input ready,

    output reg [7:0] received_data
);

    //Implement UART receiver!

    //Receiver should use valid & ready handshake. 
    //Note that sampling clock is already 16x of baudrate.

    //Hint : Refer to lab06 and 07 code to implement each state for FSM using case statement...
    always @(posedge clk ) begin
        /* ... */
    end

endmodule