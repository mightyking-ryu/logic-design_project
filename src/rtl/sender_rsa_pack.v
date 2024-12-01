module sender_rsa_pack(
    input clk, rstn, gen,
    input [31:0] message0, message1, N, d,
    input [31:0] rand_val0, rand_val1,
    input [31:0] received_data,
    output reg [31:0] packed_data0, packed_data1,
    output reg gen_end
    );

    //Implement sender_rsa_pack module
    //This module is used to compute packed messages on sender

    //You will need to use RL binary module
    //Use other modules if needed.
    RL_binary u_RL_binary(
        .clk      (        ),
        .rstn     (        ),
        .md_start (        ),
        .base     (        ),
        .exp      (        ),
        .modulus  (        ),
        .r        (        ),
        .md_end   (        )
    );

    
endmodule

