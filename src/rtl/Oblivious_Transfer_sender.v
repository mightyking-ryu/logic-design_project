`timescale 1ns / 1ps

module Oblivious_Transfer_sender(
    input clk, reset,
    
    input rx_valid,
    output rx_ready,
    input [7:0] rx_data,
    
    output tx_valid,
    input tx_ready,
    output [7:0] tx_data

);

    //Implement sender side of oblivious transfer
    //You can define your own reg, wire ... etc

    pseudo_random RANDOM_GENERATOR_0(
        .clk  (     ),
        .rstn (     ),
        .gen  (     ),
        .N    (     ),
        .q    (     ),
        .gen_end (  )
    );

    pseudo_random RANDOM_GENERATOR_1(
        .clk  (     ),
        .rstn (     ),
        .gen  (     ),
        .N    (     ),
        .q    (     ),
        .gen_end (  )
    );



    sender_rsa_pack SENDER_RSA (
        .clk           (     ),
        .rstn          (     ),
        .gen           (     ),
        .message0      (     ),
        .message1      (     ),
        .N             (     ),
        .d             (     ),
        .rand_val0     (     ),
        .rand_val1     (     ),
        .received_data (     ),
        .packed_data0  (     ),
        .packed_data1  (     ),
        .gen_end       (     )
    );




endmodule
