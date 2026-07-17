import LeNet5_pkg::*;

module tb_LeNet;
//////////////////////////////////////
////////////// Signals //////////////
////////////////////////////////////
    logic clk,rst;
    // Input Interface 
    logic [7:0] LeNet_write_addr; 
    logic [7:0] LeNet_data_in;
    logic       LeNet_write_enable;
    logic       LeNet_start;
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

// Data importing
    logic [7:0] Test_Map    [FEATURE_MAP_2_SIZE-1:0];
    // logic [7:0] FM2_test_0  [FEATURE_MAP_2_SIZE-1:0];
    logic [7:0] FM2_test_1  [FEATURE_MAP_2_SIZE-1:0];
    // logic [7:0] FM2_test_2  [FEATURE_MAP_2_SIZE-1:0];
    // logic [7:0] FM2_test_3  [FEATURE_MAP_2_SIZE-1:0];
    // logic [7:0] FM2_test_4  [FEATURE_MAP_2_SIZE-1:0];
    // logic [7:0] FM2_test_5  [FEATURE_MAP_2_SIZE-1:0];
    // logic [7:0] FM2_test_6  [FEATURE_MAP_2_SIZE-1:0];
    // logic [7:0] FM2_test_7  [FEATURE_MAP_2_SIZE-1:0];
    // logic [7:0] FM2_test_8  [FEATURE_MAP_2_SIZE-1:0];
    // logic [7:0] FM2_test_9  [FEATURE_MAP_2_SIZE-1:0];
    initial begin
        $readmemh(TEST_MAP_PATH,Test_Map);
        // $readmemh(FLAT_FM2_TEST_0_PATH,FM2_test_0);
        $readmemh(FLAT_FM2_TEST_1_PATH,FM2_test_1);
        // $readmemh(FLAT_FM2_TEST_2_PATH,FM2_test_2);
        // $readmemh(FLAT_FM2_TEST_3_PATH,FM2_test_3);
        // $readmemh(FLAT_FM2_TEST_4_PATH,FM2_test_4);
        // $readmemh(FLAT_FM2_TEST_5_PATH,FM2_test_5);
        // $readmemh(FLAT_FM2_TEST_6_PATH,FM2_test_6);
        // $readmemh(FLAT_FM2_TEST_7_PATH,FM2_test_7);
        // $readmemh(FLAT_FM2_TEST_8_PATH,FM2_test_8);
        // $readmemh(FLAT_FM2_TEST_9_PATH,FM2_test_9);
    end

// Core
    initial begin
        Initialization();
        Reset();
        // Testing Scenario
           // Test Mape
            Main_Scenario(Test_Map);
            wait(out_valid);
            @(negedge clk);
        //     // Test 0
        //     Main_Scenario(FM2_test_0);
        //     wait(out_valid);
        //     @(negedge clk);
        //     // Test 1
        //     Main_Scenario(FM2_test_1);
        //     wait(out_valid);
        //     @(negedge clk);
        //     // Test 2
        //     Main_Scenario(FM2_test_2);
        //     wait(out_valid);
        //     @(negedge clk);
        //     // Test 3
        //     Main_Scenario(FM2_test_3);
        //     wait(out_valid);
        //     @(negedge clk);
        //     // Test 4
        //     Main_Scenario(FM2_test_4);
        //     wait(out_valid);
        //     @(negedge clk);
        //     // Test 5
        //     Main_Scenario(FM2_test_5);
        //     wait(out_valid);
        //     @(negedge clk);
        //     // Test 6
        //     Main_Scenario(FM2_test_6);
        //     wait(out_valid);
        //     @(negedge clk);
        //     // Test 7
        //     Main_Scenario(FM2_test_7);
        //     wait(out_valid);
        //     @(negedge clk);
        //     // Test 8
        //     Main_Scenario(FM2_test_8);
        //     wait(out_valid);
        //     @(negedge clk);
        //     // Test 9
        //     Main_Scenario(FM2_test_9);
        //     wait(out_valid);
        //     @(negedge clk);
        Finish();
    end
    
    task Reset;
        rst = 1'b1;
        @(negedge clk);
        rst = 1'b0;
    endtask
    
    task Finish;
        repeat(500) @(negedge clk);
        $stop;
    endtask
// Watch dog works after 10 ms in simulation time 
    // initial begin
    //     #1000000;
    //     $display("Simulation is not working");
    //     $stop; 
    // end
//////////////////////////////////////
//////// Testbench Scenarios ////////
////////////////////////////////////
    task Initialization;
        // Initialize your Signals Here
        LeNet_write_addr   = 'b0; 
        LeNet_data_in      = 'b0;
        LeNet_write_enable = 'b0;
        LeNet_start        = 'b0;
    endtask
    task Main_Scenario(input logic [7:0] FM2_test  [FEATURE_MAP_2_SIZE-1:0]);
        // Fill the Feature Map
        for (int i = 0; i < FEATURE_MAP_2_SIZE-1; i++) begin
            LeNet_write_enable = 'b1;
            LeNet_write_addr   = i; 
            LeNet_data_in      = FM2_test[i];    
            @(negedge clk);
        end
        // Start the Network
            @(negedge clk);
            LeNet_start        = 'b1;
            LeNet_write_enable = 'b0;
            @(negedge clk);
            LeNet_start = 1'b0;
    endtask

endmodule