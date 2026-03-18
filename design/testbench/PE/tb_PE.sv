////////////////////////////////////////////////
///// Project   : LeNet             
///// Created on: 2026-02-08                   
////////////////////////////////////////////////
import LeNet5_pkg::*;
module tb_PE ;
//////////////////////////////////////
////////////// Signals //////////////
////////////////////////////////////
    logic     clk,rst;
    sum_t     prev_c; // Previous Accumaltion
    weight_t  curr_x; // Current Filter weight
    feature_t curr_y; // Current Feature 
    logic     clear;  // Clear signal 
    sum_t     curr_c;  // Current Accumaltion
    
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
    PE DUT (.*);

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
        repeat(10) @(negedge clk);
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
        prev_c = 'b0; // Previous Accumaltion
        curr_x = 'b0; // Current Filter weight
        curr_y = 'b0; // Current Feature 
        clear  = 'b1;  // Clear signal  
    endtask
    task Main_Scenario();
        // Write your Test Scenario Here
        prev_c = 'd5; // Previous Accumaltion
        curr_x = 'd6; // Current Filter weight
        curr_y = 'd2; // Current Feature 
        clear  = 1'b0;  // Clear signal
        @(posedge clk);
        prev_c = 'd10; // Previous Accumaltion
        curr_x = 'd7; // Current Filter weight
        curr_y = 'd5; // Current Feature 
        clear  = 1'b1;  // Clear signal
        @(posedge clk);
        prev_c = 'd10; // Previous Accumaltion
        curr_x = 'd7; // Current Filter weight
        curr_y = 'd5; // Current Feature 
        clear  = 1'b0;  // Clear signal
    endtask
endmodule
