import LeNet5_pkg::*;
module MAC (
    input logic clk,rst,
    // Weight and input feature per clock cycle
    input feature_t feature_in,
    input weight_t  weight,
    input logic     weight_en, // Start multiplication if one
    // Bais in the addition Starting 
    input weight_t  bais,
    input logic     bais_en,  // MAC_out = bais if one 
    // Accumalating Output Feature  
    output sum_t MAC_out
);
// NOTE: DNN Control is reponsible to choose when MAC_out = feature_out

// 1. Input Registering 
    feature_t feature_in_reg [1:0];
    weight_t  weight_reg;
    always_ff @( posedge clk or posedge rst ) begin 
        if (rst) begin
            feature_in_reg[0] <= 'b0;
            feature_in_reg[1] <= 'b0;
            weight_reg <= 'b0;
        end else begin
            feature_in_reg[0] <= feature_in;
            feature_in_reg[1] <= feature_in_reg[0];
            weight_reg <= weight;
        end
    end
// Bias (Q4.3 Signed) = [7]Sign [6:3]Integer [2:0]Fractional
// Bias (Q8.6 Signed) = [15:14]Sign [13:6]Integer [5:0]Fractional

    sum_t bais_qs8_6;

    assign bais_qs8_6 = {
        {6{bais[7]}},  // Sign extend (2 original sign bits + 4 padding for Q8 range)
        bais[6:3],     // Original 4 Integer bits (I3, I2, I1, I0)
        bais[2:0],     // Original 3 Fractional bits (F1, F2, F3)
        3'b000         // Pad 3 new fractional bits with zero to maintain value
    };
// 2. Multiplication Operation and Registering
    sum_t product,product_comb;
    always_ff @( posedge clk or posedge rst) begin 
        if (rst) begin
            product <= 'b0;
        end else begin
            if (~weight_en) begin
                product <= 'b0;
            end else begin
                product <= product_comb;    
            end
        end
    end    
    multipler u_DNN_MAC_multipler(
        .weight_sq0_7(weight_reg),      // Q0.7 signed
        .feature_uq4_4(feature_in_reg[1]), // Q4.4 unsiged
        .out_sq4_11(product_comb)       // Q4.11 signed
    );
// 3. Accumaltion and output 
    always_ff @( posedge clk or posedge rst) begin 
        if (rst) begin
            MAC_out <= 'b0;
        end else begin
            if (bais_en) begin
                MAC_out <= bais_qs8_6;
            end else if(weight_en) begin
                MAC_out <= MAC_out + product;
            end
        end 
    end   
endmodule