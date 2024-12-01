module receiver_rsa(
    input clk, rstn, sel_bit, gen,
    input  [31:0] received_rand0, received_rand1, N, pub_key, rand_val,
    output reg [31:0] mod_res,
    output reg gen_end
    );

    //Implement receiver_rsa module
    //This module is used to compute "v" value on receiver

    //You will need to use RL binary module
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
