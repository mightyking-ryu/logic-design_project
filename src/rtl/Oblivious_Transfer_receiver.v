module Oblivious_Transfer_receiver(
    input clk, reset,

    input sel,
    
    input rx_valid,
    output rx_ready,
    input [7:0] rx_data,
    
    output tx_valid,
    input tx_ready,
    output [7:0] tx_data,

    output [31:0] unpack_res

);

    //Implement receiver side of oblivious transfer
    //You can define your own reg, wire ... etc

    

    pseudo_random RANDOM_GENERATOR(
        .clk  (     ),
        .rstn (     ),
        .gen  (     ),
        .N    (     ),
        .q    (     ),
        .gen_end (  )
    );

    receiver_rsa u_receiver_rsa(
        .clk            (       ),
        .rstn           (       ),
        .sel_bit        (       ),
        .gen            (       ),
        .received_rand0 (       ),
        .received_rand1 (       ),
        .N              (       ),
        .pub_key        (       ),
        .rand_val       (       ),
        .mod_res        (       ),
        .gen_end        (       )
    );

    unpack_mod   u_unpack_mod(
        .clk        (       ),
        .rstn       (       ),
        .sel_bit    (       ),
        .gen        (       ),
        .message0   (       ),
        .message1   (       ),
        .N          (       ),
        .rand_val   (       ),
        .unpack_res (       ),
        .gen_end    (       )
    );




endmodule