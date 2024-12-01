`timescale 1ns / 1ps

//DO NOT MODIFY THIS MODULE
module OT_top(
    input clk,
    //Use as reset button!
    input btnC,

    //sw[0] slide switch
    input [1:0] sw,

    input RsRx,
    output RsTx,
    output [15:0] led
);

    //Set this module as top module
    //DO NOT MODIFY THIS MODULE

    wire uart_samplig_clk;
    clock_divider UART_CLK_GEN (clk, uart_samplig_clk);

    wire [7:0] data_to_xmit;
    wire tx_valid, tx_ready;
    uart_transmitter UART_TX(
        .uart_samplig_clk ( uart_samplig_clk ),
        .reset            ( btnC            ),
        .RsTx             ( RsTx             ),
        .valid            ( tx_valid            ),
        .ready            ( tx_ready            ),
        .data_to_xmit     ( data_to_xmit     )
    );

    
    wire [7:0] received_data;
    wire rx_valid, rx_ready;
    uart_receiver UART_RX(
        .uart_samplig_clk ( uart_samplig_clk ),
        .reset            ( btnC            ),
        .RsRx             ( RsRx             ),
        .valid            ( rx_valid            ),
        .ready            ( rx_ready            ),
        .received_data    ( received_data    )
    );


      
    wire sender_rx_ready;
    wire sender_tx_valid;
    wire [7:0] sender_tx_data;
    Oblivious_Transfer_sender OT_SENDER(
        .clk      ( uart_samplig_clk      ),
        .reset    ( btnC    ),

        .rx_valid ( sw[0] ? rx_valid : 1'd0 ),
        .rx_ready ( sender_rx_ready ),
        .rx_data  ( received_data  ),

        .tx_valid ( sender_tx_valid ),
        .tx_ready ( sw[0] ? tx_ready : 1'd0 ),
        .tx_data  ( sender_tx_data  )
    );

    wire receiver_rx_ready;
    wire receiver_tx_valid;
    wire [7:0] receiver_tx_data;
    wire [31:0] unpack_result;
    Oblivious_Transfer_receiver OT_RECEIVER(
        .clk      ( uart_samplig_clk      ),
        .reset    ( btnC    ),

        .sel      (sw[1]),

        .rx_valid ( sw[0] ? 1'd0 : rx_valid ),
        .rx_ready ( receiver_rx_ready ),
        .rx_data  ( received_data  ),

        .tx_valid ( receiver_tx_valid ),
        .tx_ready ( sw[0] ? 1'd0 : tx_ready ),
        .tx_data  ( receiver_tx_data  ),

        .unpack_res(unpack_result)
    );

    assign data_to_xmit = sw[0] ? sender_tx_data : receiver_tx_data;
    assign tx_valid = sw[0] ? sender_tx_valid : receiver_tx_valid;

    assign rx_ready = sw[0] ? sender_rx_ready : receiver_rx_ready;

    assign led = unpack_result[15:0];

        
endmodule
