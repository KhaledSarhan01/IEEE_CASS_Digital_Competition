import LeNet5_pkg::*;
module Accumalte (
    input  logic    clk,rst,
    input  logic    clear,
    input  logic    i_start,
    input  weight_t i_bias,
    input  sum_t    i_value, 
    output sum_t    o_acc
);
    // bias       = Qs0.7  = SFFF_FFFF
    // bias_q4_11 = Qs4.11 = sIII_IFFF_FFFF_FFFF
    //            = s000_0FFF_FFFF_0000
    sum_t bias_q4_11;
    assign bias_q4_11 = {i_bias[7],4'b0,i_bias[6:0],4'b0};

    // Main Accumaltion Logic
    always_ff @( posedge clk or posedge clk ) begin 
        if (rst) begin
            o_acc <= 'b0;
        end else begin
            if (clear) begin
                o_acc <= 'b0;
            end else if (i_start) begin
                o_acc <= bias_q4_11;
            end else begin
                o_acc <= o_acc + i_value;
            end
        end
    end
endmodule