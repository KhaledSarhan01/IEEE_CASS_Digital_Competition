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
// bais(Q0.7 Signed)  = sFFFFFFF           
// bais(Q4.11 Signed) = sIIIIFFFFFFFFFFF = ssss_sFFF_FFFF_0000 
    sum_t bais_qs4_11;
    assign bais_qs4_11 = {{5{bais[7]}},bais,4'b0};

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
// 2.5 Combinational Saturating Addition
// Extend by 1 bit to catch the overflow/carry
    wire signed [16:0] extended_sum;
    assign extended_sum = MAC_out + product;

    // Detect overflow by checking the sign bits (Bit 15 for a 16-bit signal)
    wire pos_overflow = (~MAC_out[15] & ~product[15] &  extended_sum[15]);
    wire neg_overflow = ( MAC_out[15] &  product[15] & ~extended_sum[15]);

    // Clamp to Max/Min 16-bit values if overflow occurs
    wire signed [15:0] saturated_sum;
    assign saturated_sum = pos_overflow ? 16'h7FFF :  // Max positive (0111...1)
                        neg_overflow ? 16'h8000 :  // Max negative (1000...0)
                        extended_sum[15:0];        // Normal sum

// 3. Accumulation and output 
    always_ff @(posedge clk or posedge rst) begin 
        if (rst) begin
            MAC_out <= 'b0;
        end else begin
            if (bais_en) begin
                // Load the initial bias
                MAC_out <= bais_qs4_11;
            end else if(weight_en) begin
                // Accumulate using the safe, saturated sum
                MAC_out <= saturated_sum; 
            end
        end 
    end  
endmodule