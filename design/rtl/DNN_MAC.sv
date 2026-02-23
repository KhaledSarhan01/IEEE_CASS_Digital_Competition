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
    feature_t feature_in_reg;
    always_ff @( posedge clk or posedge rst ) begin 
        if (rst) begin
            feature_in_reg <= 'b0;
            // weight_reg <= 'b0;
        end else begin
            feature_in_reg <= feature_in;
            // weight_reg <= weight;
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
        .weight_sq0_7(weight),      // Q0.7 signed
        .feature_uq4_4(feature_in_reg), // Q4.4 unsiged
        .out_sq4_11(product_comb)       // Q4.11 signed
    );
// 3. Accumaltion and output 
    always_ff @( posedge clk or posedge rst) begin 
        if (rst) begin
            MAC_out <= 'b0;
        end else begin
            if (bais_en) begin
                MAC_out <= bais_qs4_11;
            end else if(weight_en) begin
                MAC_out <= MAC_out + product;
            end
        end 
    end   
endmodule