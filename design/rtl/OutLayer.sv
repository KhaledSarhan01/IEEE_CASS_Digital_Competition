import LeNet5_pkg::*;
module Output_Layer(
    input logic clk,
    input logic rst,
    // Input Features
    input feature_t   in_feature,
    input logic [3:0] in_address, // to address 10 location, we need 4 bit address
    input logic       in_enable,
    input logic       in_start, 
    // Output Prediction 
    output logic [9:0] prediction,
    output logic       predict_valid
);
    /*
        Design:
        1. Register input in its respective place using in_enable.
        2. after in_start= 1, start comparing sequence to know the highest.
        3. output the argmax prediction.
    */
    // DUMMY OUTPUTS
    assign prediction    = 'b0;
    assign predict_valid = 'b0;
endmodule