import LeNet5_pkg::*;
module Accumalte (
    input logic clk,rst,
    input  logic clear,
    input  sum_t i_value, 
    output sum_t o_acc
);
    always_ff @( posedge clk or posedge clk ) begin 
        if (rst) begin
            o_acc <= 'b0;
        end else begin
            if (clear) begin
                o_acc <= 'b0;
            end else begin
                o_acc <= o_acc + i_value;
            end
        end
    end
endmodule