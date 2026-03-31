`timescale 1ns/1ps
import LeNet5_pkg::*;
module tb_multpiler();

    // 1. Signal Declarations
    feature_t   feature_in;
    weight_t    weight_in;
    sum_t       out_q4_11;

    // 2. Instantiate the Unit Under Test (UUT)
    multipler UUT (
    .weight_sq0_7(weight_in),   // Q0.7 signed
    .feature_uq4_4(feature_in), // Q4.4 unsiged
    .out_sq4_11(out_q4_11)      // Q4.11 signed
    );

    // 3. Verification Variables
    real real_feature, real_weight, real_expected, real_got;
    int error_count = 0;

    // 4. Test Task: Simplifies running multiple cases
    task check_case(input [7:0] f, input [7:0] w, input string name);
        feature_in = f;
        weight_in  = w;
        #10; // Wait for combinational logic to settle

        // Convert bits back to real numbers for checking
        real_feature  = feature_in / 8.0;           // Q4.3 -> 2^3
        real_weight   = weight_in  / 8.0;           // Q4.3 -> 2^3
        real_expected = real_feature * real_weight;
        real_got      = out_q4_11 / 64.0;          // Q8.6 -> 2^6

        // Tolerance check (allow 1 LSB of the output precision)
        if (abs_diff(real_got, real_expected) > (1.0/64.0)) begin
            $display("[FAIL] %s | F:%f W:%f | Expected:%f Got:%f", 
                      name, real_feature, real_weight, real_expected, real_got);
            error_count++;
        end else begin
            $display("[PASS] %s | Output: %f", name, real_got);
        end
    endtask

    // Helper function for absolute difference
    function real abs_diff(real a, real b);
        return (a > b) ? (a - b) : (b - a);
    endfunction

    // 5. Main Stimulus Block
    initial begin
        $display("--- Starting Multiplier Tests ---");

        // Case 1: Sparsity Check (Feature is zero)
        check_case(8'h00, 8'h7F, "Sparsity_Feature_Zero");

        // Case 2: Identity (1.0 * 0.5 = 0.5)
        // 1.0 in Q4.4 is 8'h10 | 0.5 in Q0.7 is 8'h40
        check_case(8'h10, 8'h40, "Simple_Positive_Mult");

        // Case 3: Negative Weight (1.0 * -1.0 = -1.0)
        // -1.0 in Q0.7 is 8'h80 (The "most negative" value)
        check_case(8'h10, 8'h80, "Full_Negative_Weight");

        // Case 4: Max Range (Max Positive * Max Positive)
        // 15.9375 * 0.992
        check_case(8'hFF, 8'h7F, "Max_Positive_Range");

        // Case 5: Max Negative Range (Max Positive * Max Negative)
        // 15.9375 * -1.0
        check_case(8'hFF, 8'h80, "Max_Negative_Range");

        // Case 6: Smallest Precision (LSB * LSB)
        check_case(8'h01, 8'h01, "Precision_Check");
        
        // Case 8: Sparsity Check (Feature is zero)
        check_case(8'h00, 8'h7F, "Sparsity_Feature_Zero");
        
        // Case 8: Sparsity Check (Weight is zero)
        check_case(8'h7F, 8'h00, "Sparsity_Feature_Zero");

        // Case 9: Sparsity Check (Both is zero)
        check_case(8'h00, 8'h00, "Sparsity_Feature_Zero");
        // Case 7: Random Case
        repeat(10)begin
            check_case($random(),$random(),"Random");
        end
        // Final Summary
        $display("--- Tests Finished with %0d errors ---", error_count);
        if (error_count == 0) $display("Verification SUCCESS!");
        $stop;
    end

endmodule