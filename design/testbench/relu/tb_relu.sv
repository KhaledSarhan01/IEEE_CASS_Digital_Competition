`timescale 1ns/1ps
import LeNet5_pkg::*;
module tb_relu();

    // 1. Signals
    logic     clk,rst;
    logic     relu_in_en;
    sum_t     relu_in;
    feature_t relu_out;
    logic     relu_out_en;
    // Clock Generation 
        initial begin
            clk = 1'b0;
            forever #5 clk = ~clk;
        end
    // 2. Instantiate UUT (Unit Under Test)'
    relu UUT (.*);

    // 3. Testing Variables
    real expected_real, input_real, output_real;
    int error_count = 0;

    // 4. Verification Task
    task check_relu(input logic signed [15:0] val, input string msg);
        relu_in = val;
        @(negedge clk); // Allow logic to propagate

        input_real = val / 64.0;
        
        // Golden Model: ReLU Logic
        if (input_real < 0.0) begin
            expected_real = 0.0;
        end else begin
            // Apply Convergent Rounding (Round to nearest, ties to even or away)
            // Here we model "round to nearest" which is standard convergent behavior
            expected_real = real'(int'(input_real * 8.0)) / 8.0;
            
            // Saturation check for Q4.4 (Max is 15.9375)
            if (expected_real > 15.875) expected_real = 15.875;
        end

        @(negedge clk);
        output_real = relu_out / 8.0;

        if (abs_diff(output_real, expected_real) > 0.125) begin
            $display("[FAIL] %s | In: %f | Exp: %f | Got: %f", msg, input_real, expected_real, output_real);
            error_count++;
        end else begin
            $display("[PASS] %s | In: %f -> Out: %f", msg, input_real, output_real);
        end
    endtask

    function real abs_diff(real a, real b);
        return (a > b) ? (a - b) : (b - a);
    endfunction

    // 5. Stimulus
    initial begin
        $display("--- Reset ---");
        rst = 1'b1;
        relu_in_en = 1'b0;
        @(negedge clk);
        rst = 1'b0;
        relu_in_en = 1'b1;
        $display("--- Starting ReLU Rounded Test ---");

        // Test Case 1: Negative Input (ReLU must output 0)
        // Input: -2.0 in Q8.6 is (unsigned equivalent of -128) -> 16'hFF80
        check_relu(16'hFF80, "Negative_Input"); 

        // Test Case 2: Zero Input
        check_relu(16'h0000, "Zero_Input");

        // Test Case 3: Positive - Exact Match (No rounding)
        // 1.0 in Q8.6 is 16'h0040. 
        // Expected output: 8'h08 (1.0 in Q4.3)
        check_relu(16'h0040, "Positive_Exact");

        // Test Case 4: Round Up (Middle point or higher)
        // Threshold for rounding in Q8.6 to Q4.3 is the 3rd fractional bit (value 0.0625).
        // Input: 1.0 + 0.0625 + small_offset 
        // 1.0 (16'h40) + 0.5_of_LSB_output (16'h04) = 16'h0044
        // Expected output: 1.125 (8'h09) because we round up from 1.0625
        check_relu(16'h0045, "Round_Up_Check"); 

        // Test Case 5: Round Down
        // Input: 1.0 + very small fractional (less than half of output LSB)
        // 1.0 (16'h40) + 16'h0002 = 16'h0042
        // Expected output: 1.0 (8'h08)
        check_relu(16'h0042, "Round_Down_Check");

        // Test Case 6: Saturation (The Most Critical Test)
        // Max Q8.6 is ~255.9. Max Q4.3 is 7.875 (8'h3F) or 15.875 (8'h7F) 
        // Since you are using Q4.3 Signed, max positive is 8'h7F (0 1111 111) which is 15.875.
        // Input: 20.0 (16'h0500) -> Should saturate to 15.875 (8'h7F)
        check_relu(16'h0500, "Saturation_Check");

        $display("--- Tests Finished with %0d errors ---", error_count);
        $stop;
    end

endmodule