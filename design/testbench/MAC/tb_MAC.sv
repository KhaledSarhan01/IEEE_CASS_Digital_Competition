import LeNet5_pkg::*;
module tb_MAC();
// 1. Signals
    // Clock and Reset signals
    logic clk;
    logic rst;
    
    // Inputs
    feature_t feature_in;
    weight_t  weight;
    logic     weight_en;
    weight_t  bais;
    logic     bais_en;
    logic     feature_out_load;
    // Output
    sum_t     MAC_out;
    sum_t     feature_out;
    // Float Conversion
    real weight_real,bais_real,feature_real;
    assign weight_real  = real'(weight) / 128.0;   // Q0.7 Signed
    assign bais_real    = real'(bais) / 128.0;    // Q0.7 Signed
    assign feature_real = real'(feature_in) / 16.0; // Q4.4 Unsigned
    // Internal Verification Variables
    real real_expected = 0.0;
    real real_got;
    int error_count = 0;
    assign real_got   = real'(MAC_out) / 2048.0; // Q4.11 conversion


// 2. Instantiate the MAC Unit
    MAC uut (.*);

// 3. Clock Generation (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;    
    end

// 4. Main Stimulus
    initial begin
        Initialization();
        Reset();
        CorrectSequence();
        CorrectSequence();
        // WeightBaisSameAssertion();
        // UnsafeLoading();
        // $display("--- MAC Tests Finished with %0d errors ---", error_count);
        repeat(10) @(negedge clk);
        $stop;
    end

// 5. Verification Tasks   
    task check_mac(input string step_name);
        // @(negedge clk); // Check on the falling edge to ensure stable signals
    
        if (abs_diff(real_got, real_expected) > 0.001) begin
            $display("[FAIL Time= %0t] %s | Exp: %f | Got: %f",$time, step_name, real_expected, real_got);
            error_count++;
        end else begin
            $display("[PASS] %s | Output: %f", step_name, real_got);
        end
    endtask

    function real abs_diff(real a, real b);
        return (a > b) ? (a - b) : (b - a);
    endfunction

    task  Initialization();
        // Initialize
        feature_out_load = 1;
        feature_in = 0;
        weight = 0;
        weight_en = 0;
        bais = 0;
        bais_en = 0;
        real_expected = 0.0;
    endtask 
    
    task automatic Reset();
        // --- Step 1: Reset ---
        rst = 1;
        @(negedge clk); 
        rst = 0;
    endtask 

    task automatic CorrectSequence();
        // --- Step 2: Load Bias (Initialize Accumulator) ---
        // Let's set bias to 0.5 (Q0.7 = 8'h40)
        @(posedge clk);
        bais = 8'h40; 
        bais_en = 1;
        real_expected = 0.5; 
        
        // // --- Step 3: First MAC Operation ---
        // // Feature = 2.0 (8'h20), Weight = 0.25 (8'h20)
        // // Expected: 0.5 (prev) + (2.0 * 0.25) = 1.0
        @(posedge clk);
        // check_mac("Bias_Load");
        bais_en = 0; // Disable bias load
        
        feature_in = 8'h20;
        weight = 8'h20;
        weight_en = 1;
        
        // // --- Step 4: Second MAC Operation ---
        // // Feature = 4.0 (8'h40), Weight = -0.5 (8'hC0)
        // // Expected: 1.0 (prev) + (4.0 * -0.5) = -1.0
        @(posedge clk);
        feature_in = 8'h40;
        weight = 8'hC0; 
        
        @(posedge clk);
        real_expected = 1.0;
        // check_mac("First_Accumulate");
        // // --- Step 5: Sparsity Check (weight_en = 0) ---
        // // Even if inputs change, the output should stay -1.0
        @(posedge clk);
        real_expected = -1.0;
        // check_mac("Second_Accumulate");

        weight_en = 0;
        feature_in = 8'hFF; 
    
        // @(negedge clk);
        real_expected = -1.0;
        // check_mac("Sparsity_Idle_Check");
    endtask //automatic
    task automatic WeightBaisSameAssertion();
        // --- Step 2: Load Bias (Initialize Accumulator) ---
        // Let's set bias to 0.5 (Q0.7 = 8'h40)
        @(posedge clk);
        bais = 8'h40; 
        bais_en = 1;
        feature_in = 8'h20;
        weight = 8'h20;
        weight_en = 1;

        @(posedge clk);
        bais_en = 0; // Disable bias load
        feature_in = 8'h40;
        weight = 8'hC0;
        // @(negedge clk);

        @(posedge clk);
        @(posedge clk);
        weight_en = 0;
    endtask //automatic
    task automatic UnsafeLoading();
        @(posedge clk);
        bais = 8'h40; 
        bais_en = 1;
        feature_in = 8'h20;
        weight = 8'h20;
        weight_en = 1;

        @(posedge clk);
        bais_en = 0; // Disable bias load
        feature_in = 8'h40;
        weight = 8'hC0;
        // @(negedge clk);

        @(posedge clk);
        @(posedge clk);
        bais = 8'h40; 
        bais_en = 1;
        feature_in = 8'h20;
        weight = 8'h20;
        weight_en = 1;

        @(posedge clk);
        bais_en = 0; // Disable bias load
        feature_in = 8'h40;
        weight = 8'hC0;
        @(posedge clk);
        // @(posedge clk);
        weight_en = 0;
    endtask //automatic

endmodule