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
endmodule