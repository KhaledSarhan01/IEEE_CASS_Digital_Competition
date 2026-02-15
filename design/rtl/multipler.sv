import LeNet5_pkg::*;
module multipler (
    input weight_t  weight_sq0_7,  // Q0.7 signed
    input feature_t feature_uq4_4, // Q4.4 unsiged
    output sum_t    out_sq4_11     // Q4.11 signed
);
    // 1. Prepare the operands
    // We must cast the feature to signed. To keep it positive, 
    // we add a leading 0 (sign extension). This makes it 9 bits.
    logic signed [8:0] s_feature;
    assign s_feature = $signed({1'b0, feature_uq4_4});

    // 2. Sparsity Detection
    // If either input is zero, the result is zero.
    // This prevents the multiplier toggle activity.
    logic is_sparse;
    assign is_sparse = (feature_uq4_4 == 8'h00) || (weight_sq0_7 == 8'h00);

    // 3. Multiplication Logic
    // Total bits: 9 (feature) + 8 (weight) = 17 bits intermediate
    logic signed [16:0] full_product;
    
    always_comb begin
        if (is_sparse) begin
            full_product = 17'h0;
        end else begin
            full_product = s_feature * weight_sq0_7;
        end
    end

    // 4. Output Mapping
    // s_feature has 4 fractional bits, weight has 7. 
    // 4 + 7 = 11 fractional bits. The alignment is perfect.
    // We take the lower 16 bits to fit Q4.11 (dropping the extra sign bit).
    assign out_sq4_11 = full_product[15:0];
    
endmodule