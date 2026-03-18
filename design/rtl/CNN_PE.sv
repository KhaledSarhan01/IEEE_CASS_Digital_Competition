import LeNet5_pkg::*;
module PE (
    input logic     clk,rst,
    input sum_t     prev_c, // Previous Accumaltion
    input weight_t  curr_x, // Current Filter weight
    input feature_t curr_y, // Current Feature 
    input logic     clear,  // Clear signal 
    output sum_t    curr_c  // Current Accumaltion
); 
/*
 - Equation: 
    curr_c = prev_c + curr_x * curr_y
 - inputs (curr_x,curr_y,prev_c) are registered.
 - output curr_c is not registed since it's registered
    from the previous input.
*/
// Registering the inputs
    sum_t     prev_c_reg; // Previous Accumaltion
    weight_t  curr_x_reg; // Current Filter weight
    feature_t curr_y_reg; // Current Feature
    always_ff @( posedge clk or posedge rst ) begin 
        if (rst) begin
            prev_c_reg <= 'b0;
            curr_x_reg <= 'b0;
            curr_y_reg <= 'b0;
        end else begin
            if (clear) begin    
                prev_c_reg <= 'b0;
                curr_x_reg <= 'b0;
                curr_y_reg <= 'b0;
            end else begin 
                prev_c_reg <= prev_c;
                curr_x_reg <= curr_x;
                curr_y_reg <= curr_y; 
            end
        end
    end 
// Muliplication and summution
    sum_t  x_mul_y;
    multipler u_CNN_PE_multipler(
        .weight_sq0_7(curr_y_reg),  // Q0.7 signed
        .feature_uq4_4(curr_x_reg), // Q4.4 unsiged
        .out_sq4_11(x_mul_y)        // Q4.11 signed
    ); 
    assign curr_c = prev_c_reg + x_mul_y;   
endmodule 
