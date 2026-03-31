import LeNet5_pkg::*;
module multipler (
    //TODO: fix in all multiplier instances
    input weight_t  weight_sq0_7,  // Q4.3 signed
    input feature_t feature_uq4_4, // Q4.3 signed
    output sum_t    out_sq4_11     // Q8.6 signed
);
    //TODO: fix in all multiplier instances
    feature_t feature_sq4_3;
    weight_t  weight_sq4_3;
    assign feature_sq4_3 = feature_uq4_4;
    assign weight_sq4_3 = weight_sq0_7;
    // 1. Sparsity Detection
    // If either input is zero, the result is zero.
    // This prevents the multiplier toggle activity.
    logic is_sparse;
    assign is_sparse = (feature_sq4_3 == 8'h00) || (weight_sq4_3 == 8'h00);

    // 2. Multiplication Logic
    // Total bits: 8 (feature) + 8 (weight) = 16 bits intermediate
    always_comb begin
        if (is_sparse) begin
            out_sq4_11 = 17'h0;
        end else begin
            out_sq4_11 = feature_sq4_3 * weight_sq4_3;
        end
    end

endmodule