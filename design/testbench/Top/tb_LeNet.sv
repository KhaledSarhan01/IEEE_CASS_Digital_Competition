import LeNet5_pkg::*;

module tb_LeNet;
//////////////////////////////////////
////////////// Signals //////////////
////////////////////////////////////
    logic clk,rst;
    // Start Signal 
    logic LeNet_start; 
    // Output Predication 
    logic [9:0] out_argmax_prediction;
    logic out_valid;
    
//////////////////////////////////////
///////// Clock Generation //////////
////////////////////////////////////
    localparam CLK_PERIOD = 10;
    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
//////////////////////////////////////
/////////// Instantiation ///////////
////////////////////////////////////
    LeNet5 DUT (.*);

//////////////////////////////////////
////////// Testbench Core ///////////
////////////////////////////////////

// Core
    initial begin
        Initialization();
        Reset();
        Main_Scenario();
        Finish();
    end
    
    task Reset;
        rst = 1'b1;
        @(negedge clk);
        rst = 1'b0;
    endtask
    
    task Finish;
        repeat(50000) @(negedge clk);
        $stop;
    endtask
// Watch dog works after 10 ms in simulation time 
    initial begin
        #1000000;
        $display("Simulation is not working");
        $stop; 
    end

//////////////////////////////////////
//////// Testbench Scenarios ////////
////////////////////////////////////
    task Initialization;
        // Initialize your Signals Here
        LeNet_start = 'b0;
    endtask
    task Main_Scenario();
        // Write your Test Scenario Here
        @(negedge clk);
        LeNet_start = 1'b1;
        @(negedge clk);
        LeNet_start = 1'b0;
    endtask
//////////////////////////////////////
////// Checking the Testbench ///////
////////////////////////////////////
    feature_t FM3_expected [FEATURE_MAP_3_SIZE-1:0];
    feature_t FM3_computed [FEATURE_MAP_3_SIZE-1:0];

    bit [$clog2(FEATURE_MAP_3_SIZE)-1:0] FM3_address;
    assign FM3_address  = DUT.dense1_address_out;
    feature_t FM3_feature;
    assign FM3_feature   = DUT.dense1_feature_out;
    bit dense1_enable;
    assign dense1_enable = DUT.dense1_write_enable;
    bit dense1_start;
    assign dense1_start  = LeNet_start;
    bit dense1_done;
    assign dense1_done   = DUT.dense1_done;
    
    initial begin
        $readmemh(FEATURE_MAP_3_FILE_PATH,FM3_expected);
    end
    initial begin
        fork
            begin
                // Wait for the process to actually begin
                wait(dense1_start); 
                
                // Keep checking every clock cycle
                forever begin
                    @(posedge clk); 
                    if (dense1_enable) begin
                        FM3_computed[FM3_address] = FM3_feature;
                    end
                    if(dense1_done)begin
                        break;
                    end
                end
            end
        join // Use join_none so it doesn't block the rest of your initial block
        check_array_equality(FM3_expected,FM3_computed);
    end 
    // Task definition
    task check_array_equality (
        input  feature_t expected_arr [FEATURE_MAP_3_SIZE],
        input  feature_t computed_arr [FEATURE_MAP_3_SIZE]
    );
        int error_count;
        error_count = 0; // Initialize counter

        foreach (expected_arr[i]) begin
            // Using !== to catch X or Z mismatches if they occur
            if (expected_arr[i] !== computed_arr[i]) begin
                $display("[ERROR] Mismatch at index %0d: Expected %h, Got %h", 
                        i, expected_arr[i], computed_arr[i]);
                error_count++;
            end
        end

        if (error_count == 0) begin
            $display("[SUCCESS] All %0d elements match!", FEATURE_MAP_3_SIZE);
        end else begin
            $display("[FAILURE] Found %0d total mismatches.", error_count);
        end
    endtask  
endmodule