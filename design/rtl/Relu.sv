import LeNet5_pkg::*;
module relu #(
    parameter OUT_FORMAT = "Q4_4"
)(
    input  clk,rst,
    input  logic     relu_in_en,
    input  sum_t     relu_in,
    output feature_t relu_out,
    output logic     relu_out_en   
);
    // Registering the input 
    sum_t     relu_in_reg;
    logic [1:0] enable_reg;
    always_ff @( posedge clk or posedge rst) begin 
        if (rst) begin
            relu_in_reg <= 'b0;
        end else if(relu_in_en)begin
            relu_in_reg <= relu_in;
        end
    end
    
    // 1. ReLU Operation (Zero out negative values)
    sum_t pre_relu_out,relu_out_comb;
    assign pre_relu_out = (relu_in_reg[15]) ? 16'h0000 : relu_in_reg;

    // 2. Convergent Rounding Logic
    // Target LSB for Q4.3 is index 3. 
    // Add 1 to the bit at index 2 (value 0.0625 in Q8.6) to round to nearest.
    sum_t rounded_val;
    assign rounded_val = pre_relu_out + 16'b0000_0000_0000_0100; // 16'h0004

    // 3. Saturation Detection
    // Q4.3 Max Positive Signed is 0111.111 (Decimal 7.875) or 8'h3F.
    // If you want the full 4-bit integer range (0-15), you'd need 8'h7F (15.875).
    // Let's check if any integer bits above our target Q4 range are high.
    logic is_overflow;
    assign is_overflow = |rounded_val[14:7]; // Checks bits that exceed the Q4.3 range

    // 4. Final Output Mapping with Saturation
    always_comb begin
        if (is_overflow) begin
            // Saturate to max positive Q4.3 Signed (15.875)
            relu_out_comb = 8'h7F; 
        end else begin
            // Map bits: [15] is Sign, [6:3] are Integer bits, [2:0] are Fractional
            // Wait, mapping from Q8.6: 
            // Sign: [15]
            // Integer: [6:3] (These are the 4 bits we keep)
            // Fractional: [2:0] (The 3 bits we keep after rounding)
            // Note: The rounding was added to bit 2, so bits [15:3] are now "rounded"
            relu_out_comb = {rounded_val[15], rounded_val[9:3]};
        end
    end

    always_ff@(posedge clk or posedge rst) begin 
        if (rst) begin
            relu_out <= 'b0;
        end else begin
           if (pre_relu_out == 16'h7FFF) begin // Max Postive Value as input 
            relu_out <= 8'hFF;                // Max Postive Value as output 
            end else begin
                if (OUT_FORMAT == "Q4_4") begin
                    relu_out <= relu_out_comb;    // Truncate the rounded value 
                end else if (OUT_FORMAT == "Q1_7") begin // TODO: Remove OUT_FORMAT
                    relu_out <= relu_out_comb;    // Truncate the rounded value Q1.7 
                end
            end 
        end
    end
    // Enable output 
    always_ff @( posedge clk or posedge rst ) begin 
        if(rst)begin
            enable_reg <= 'b0;
        end else begin
            enable_reg[0] <= relu_in_en;
            enable_reg[1] <= enable_reg[0];
        end
    end
    assign relu_out_en = enable_reg[0];
endmodule