`timescale 1ns/1ps
import LeNet5_pkg::*;
module tb_relu();

    // 1. Signals
    sum_t relu_in_q4_11;
    feature_t relu_out_q4_4;

    // 2. Instantiate UUT (Unit Under Test)'
    relu UUT (
        // .clk(clk),
        // .rst(rst),
        .relu_in(relu_in_q4_11),
        .relu_out(relu_out_q4_4)
    );

    // 3. Testing Variables
    real expected_real, input_real, output_real;
    int error_count = 0;

    // 4. Verification Task
    task check_relu(input logic signed [15:0] val, input string msg);
        relu_in_q4_11 = val;
        #10; // Allow logic to propagate

        input_real = val / 2048.0;
        
        // Golden Model: ReLU Logic
        if (input_real < 0.0) begin
            expected_real = 0.0;
        end else begin
            // Apply Convergent Rounding (Round to nearest, ties to even or away)
            // Here we model "round to nearest" which is standard convergent behavior
            expected_real = real'(int'(input_real * 16.0)) / 16.0;
            
            // Saturation check for Q4.4 (Max is 15.9375)
            if (expected_real > 15.9375) expected_real = 15.9375;
        end

        output_real = relu_out_q4_4 / 16.0;

        if (abs_diff(output_real, expected_real) > 0.001) begin
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
        $display("--- Starting ReLU Rounded Test ---");

        // Test Case 1: Negative Input (Should be 0)
        check_relu(16'hF000, "Negative_Input"); // -2.0

        // Test Case 2: Zero Input
        check_relu(16'h0000, "Zero_Input");

        // Test Case 3: Positive - No rounding needed
        // 1.0 in Q4.11 is 16'h0800
        check_relu(16'h0800, "Positive_Exact");

        // Test Case 4: Round Up (0.5 LSB of output)
        // 1.0 + slightly more than half of 1/16
        // Input: 1.0 + 0.03125 + tiny (approx 1.04) -> Should round to 1.0625 (1/16)
        check_relu(16'h0841, "Round_Up_Check"); 

        // Test Case 5: Round Down
        // Input: 1.0 + 0.01 (approx 1.01) -> Should round to 1.0
        check_relu(16'h0810, "Round_Down_Check");

        // Test Case 6: Boundary/Saturation
        // Max Q4.11 is approx 15.99 -> Should saturate to 15.9375 (8'hFF)
        check_relu(16'h7FFF, "Saturation_Check");

        $display("--- Tests Finished with %0d errors ---", error_count);
        $stop;
    end

endmodule