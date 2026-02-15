import LeNet5_pkg::*;
module relu (
    // input clk,rst,
    input  sum_t     relu_in,
    output feature_t relu_out
);
    // Registering the input 
    sum_t     relu_in_reg;
    assign relu_in_reg = relu_in;
    // always_ff @( posedge clk or posedge rst) begin 
    //     if (rst) begin
    //         relu_in_reg <= 'b0;
    //     end else begin
    //         relu_in_reg <= relu_in;
    //     end
    // end

    // Relu operation
    sum_t pre_relu_out;
    assign pre_relu_out = (relu_in_reg[2*PARMETER_WIDTH-1])? 'b0: relu_in_reg;

    // Output Mapping using Convergent Rounding with Saturation 
    // Q4.11 signed  = sIIII.FFFFFFFFFFF = sIII_IFFF_FFFF_FFFF
    // Q4.4 unsigned = IIII.FFFF         = xIII_IFFF_Fxxx_xxxx
    // Add 1 to fraction in previous postion before Target LSB ``
    sum_t  rounded_val; 
    assign rounded_val = pre_relu_out + 16'b0000_0000_0100_0000; 
    always_comb begin 
        if (pre_relu_out == 16'h7FFF) begin // Max Postive Value as input 
           relu_out = 8'hFF;                // Max Postive Value as output 
        end else begin
           relu_out = rounded_val[14:7];    // Truncate the rounded value 
        end
    end

endmodule