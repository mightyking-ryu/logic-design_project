module uart_transmitter (
    input uart_sampling_clk,
    input reset,

    output reg RsTx,

    //Basic valid & ready handshake
    input valid,
    output ready,

    input [7:0] data_to_xmit
);

    //Implement UART transmitter!

    //Transmitter should use valid & ready handshake.
    //Note that sampling clock is already 16x of baudrate.
    
    //Hint : Refer to lab06 and 07 code to implement each state for FSM using case statement...
    always @(posedge uart_sampling_clk ) begin
        /* ... */
    end

endmodule