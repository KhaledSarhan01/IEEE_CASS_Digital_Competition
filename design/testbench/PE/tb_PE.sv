////////////////////////////////////////////////
///// Project   : LeNet             
///// Created on: 2026-02-08                   
////////////////////////////////////////////////

module tb_PE ;
//////////////////////////////////////
////////////// Signals //////////////
////////////////////////////////////
    parameter WIDTH = 16;
    logic clk,rst;
    logic Clr; 
    logic Selp;
    logic Seln; 
    logic signed [2*WIDTH:0] Prev;     
    logic signed [WIDTH-1:0] In; 
    logic signed [WIDTH-1:0] W; 
    logic signed [WIDTH-1:0] W_out; 
    logic signed [WIDTH-1:0] In_out; 
    logic signed [2*WIDTH:0] result;
    
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
        repeat(100) @(negedge clk);
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
        Clr  = 'b0; 
        Selp = 'b0;
        Seln = 'b0; 
        Prev = 'd1;     
        In   = 'd5; 
        W    = 'd2; 
    endtask
    task Main_Scenario();
        // Write your Test Scenario Here
    endtask
endmodule
