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

    // Relu operation
    sum_t pre_relu_out;
    assign pre_relu_out = (relu_in_reg[2*PARMETER_WIDTH-1])? 'b0: relu_in_reg;

    // Output Mapping using Convergent Rounding with Saturation 
    // Q4.11 signed  = sIIII.FFFFFFFFFFF = sIII_IFFF_FFFF_FFFF
    // Q4.4 unsigned = IIII.FFFF         = xIII_IFFF_Fxxx_xxxx
    // Q1.7 unsigned = I.FFFFFFF         = xxxx_IFFF_FFFF_xxxx
    // Add 1 to fraction in previous postion before Target LSB ``
    sum_t  rounded_val; 
    assign rounded_val = pre_relu_out + 16'b0000_0000_0100_0000; 
    always_ff@(posedge clk or posedge rst) begin 
        if (rst) begin
            relu_out <= 'b0;
        end else begin
           if (pre_relu_out == 16'h7FFF) begin // Max Postive Value as input 
            relu_out <= 8'hFF;                // Max Postive Value as output 
            end else begin
                if (OUT_FORMAT == "Q4_4") begin
                    relu_out <= rounded_val[14:7];    // Truncate the rounded value 
                end else if (OUT_FORMAT == "Q1_7") begin
                    relu_out <= rounded_val[11:4];    // Truncate the rounded value Q1.7 
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
    assign relu_out_en = enable_reg[1];
endmodule