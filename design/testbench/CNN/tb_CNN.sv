import LeNet5_pkg::*;
module tb_CNN;
//////////////////////////////////////
////////////// Signals //////////////
////////////////////////////////////
    logic clk,rst;
    logic clear;
    logic start;
    feature_t y1,y2,y3,y4,y5,y6;
    weight_t  x1,x2,x3,x4,x5;
    weight_t  bias;
    sum_t     c1,c2,c3,c4;
    
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
    CNN DUT (.*);

//////////////////////////////////////
////////// Testbench Core ///////////
////////////////////////////////////
// Features and Weights
    feature_t f_map [6][6]; // [position][time]
    weight_t  w_map [5][5]; // [position][time]        
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
        repeat(20) @(negedge clk);
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
        // Weights and Features
        f_map = {{11,12,13,14,15,16}
                ,{21,22,23,24,25,26}
                ,{31,32,33,34,35,36}
                ,{41,42,43,44,45,46}
                ,{51,52,53,54,55,56}
                ,{61,62,63,64,65,66}
                }; 
        w_map = {{1,2,3,4,5}
                ,{1,2,3,4,5}
                ,{1,2,3,4,5}
                ,{1,2,3,4,5}
                ,{1,2,3,4,5}
                };
        // Initialize your Signals Here
        clear = 'b1;
        start = 1'b0;
        // Features
         y6 = 'd0; 
         y5 = 'd0;
         y4 = 'd0;
         y3 = 'd0;
         y2 = 'd0;
         y1 = 'd0;
        // Weights
         x5 = 'd0;
         x4 = 'd0;
         x3 = 'd0;
         x2 = 'd0;
         x1 = 'd0;
        // bais
         bias = 'd77;
    endtask
    task Main_Scenario();
    // Patch 1
        start_patch();
        long_pass();
        end_patch(); 
    // Patch 2
        start_patch();
        // Pass 1
        pass();
        end_patch();     
    endtask
    task automatic display_values();
        // // Using %f for floating point. %.4f limits it to 4 decimal places for clarity.
        // $display("y at %0t: %.4f, %.4f, %.4f, %.4f, %.4f, %.4f", 
        //         $time, y1/16.0, y2/16.0, y3/16.0, y4/16.0, y5/16.0, y6/16.0);
                
        // // For signed Q0.7, ensure x variables are declared as 'signed' logic/int 
        // // so the division handles the negative values correctly.
        // $display("x at %0t: %.4f, %.4f, %.4f, %.4f, %.4f", 
        //         $time, x1/128.0, x2/128.0, x3/128.0, x4/128.0, x5/128.0);
                
        // $display("====");

        // $display("y at %0t:%d,%d,%d,%d,%d,%d \n",$time,y1,y2,y3,y4,y5,y6);

        // $display("x at %0t:%d,%d,%d,%d,%d \n",$time,x1,x2,x3,x4,x5);

        // $display("====");
    endtask
    task automatic long_pass();
        @(posedge clk); // Clock 1
         // Features
          y6 = 'd0; 
          y5 = 'd0;
          y4 = 'd0;
          y3 = 'd0;
          y2 = 'd0;
          y1 = f_map[0][0];
         // Weights
          x5 = 'd0;
          x4 = 'd0;
          x3 = 'd0;
          x2 = 'd0;
          x1 = 'd0; 
          display_values();
        @(posedge clk); // Clock 2
         // Features
          y6 = 'd0; 
          y5 = 'd0;
          y4 = 'd0;
          y3 = 'd0;
          y2 = f_map[1][0];
          y1 = f_map[0][1];
         // Weights
          x5 = 'd0;
          x4 = 'd0;
          x3 = 'd0;
          x2 = 'd0;
          x1 = w_map[0][0];
          display_values();
        @(posedge clk); // Clock 3
         // Features
          y6 = 'd0; 
          y5 = 'd0;
          y4 = 'd0;
          y3 = f_map[2][0];
          y2 = f_map[1][1];
          y1 = f_map[0][2];
         // Weights
          x5 = 'd0;
          x4 = 'd0;
          x3 = 'd0;
          x2 = w_map[1][0];
          x1 = w_map[0][1];
          display_values();
        @(posedge clk); // Clock 4
         // Features
          y6 = 'd0; 
          y5 = 'd0;
          y4 = f_map[3][0];
          y3 = f_map[2][1];
          y2 = f_map[1][2];
          y1 = f_map[0][3];
         // Weights
          x5 = 'd0;
          x4 = 'd0;
          x3 = w_map[2][0];
          x2 = w_map[1][1];
          x1 = w_map[0][2];
          display_values();
        @(posedge clk); // Clock 5
         // Features
          y6 = 'd0; 
          y5 = f_map[4][0];
          y4 = f_map[3][1];
          y3 = f_map[2][2];
          y2 = f_map[1][3];
          y1 = f_map[0][4];
         // Weights
          x5 = 'd0;
          x4 = w_map[3][0];
          x3 = w_map[2][1];
          x2 = w_map[1][2];
          x1 = w_map[0][3];
          display_values();
        @(posedge clk); // Clock 6
         // Features
          y6 = f_map[5][0]; 
          y5 = f_map[4][1];
          y4 = f_map[3][2];
          y3 = f_map[2][3];
          y2 = f_map[1][4];
          y1 = f_map[0][5];
         // Weights
          x5 = w_map[4][0];
          x4 = w_map[3][1];
          x3 = w_map[2][2];
          x2 = w_map[1][3];
          x1 = w_map[0][4];
          display_values();
        @(posedge clk); // Clock 7
         // Features
          y6 = f_map[5][1]; 
          y5 = f_map[4][2];
          y4 = f_map[3][3];
          y3 = f_map[2][4];
          y2 = f_map[1][5];
          y1 = f_map[0][0];
         // Weights
          x5 = w_map[4][1];
          x4 = w_map[3][2];
          x3 = w_map[2][3];
          x2 = w_map[1][4];
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 8
         // Features
          y6 = f_map[5][2]; 
          y5 = f_map[4][3];
          y4 = f_map[3][4];
          y3 = f_map[2][5];
          y2 = f_map[1][0];
          y1 = f_map[0][1];
         // Weights
          x5 = w_map[4][2];
          x4 = w_map[3][3];
          x3 = w_map[2][4];
          x2 = 'd0;
          x1 = w_map[0][0];
          display_values();
        @(posedge clk); // Clock 9
         // Features
          y6 = f_map[5][3]; 
          y5 = f_map[4][4];
          y4 = f_map[3][5];
          y3 = f_map[2][0];
          y2 = f_map[1][1];
          y1 = f_map[0][2];
         // Weights
          x5 = w_map[4][3];
          x4 = w_map[3][4];
          x3 = 'd0;
          x2 = w_map[1][0];
          x1 = w_map[0][1];
          display_values();
        @(posedge clk); // Clock 10
          // Features
          y6 = f_map[5][4]; 
          y5 = f_map[4][5];
          y4 = f_map[3][0];
          y3 = f_map[2][1];
          y2 = f_map[1][2];
          y1 = f_map[0][3];
         // Weights
          x5 = w_map[4][4];
          x4 = 'd0;
          x3 = w_map[2][0];
          x2 = w_map[1][1];
          x1 = w_map[0][2];
          display_values();
        @(posedge clk); // Clock 11
         // Features
          y6 = f_map[5][5]; 
          y5 = f_map[4][0];
          y4 = f_map[3][1];
          y3 = f_map[2][2];
          y2 = f_map[1][3];
          y1 = f_map[0][4];
         // Weights
          x5 = 'd0;
          x4 = w_map[3][0];
          x3 = w_map[2][1];
          x2 = w_map[1][2];
          x1 = w_map[0][3];
          display_values();
        @(posedge clk); // Clock 12
         // Features
          y6 = f_map[5][0]; 
          y5 = f_map[4][1];
          y4 = f_map[3][2];
          y3 = f_map[2][3];
          y2 = f_map[1][4];
          y1 = f_map[0][5];
         // Weights
          x5 = w_map[4][0];
          x4 = w_map[3][1];
          x3 = w_map[2][2];
          x2 = w_map[1][3];
          x1 = w_map[0][4];
          display_values();
        @(posedge clk); // Clock 13
         // Features
          y6 = f_map[5][1]; 
          y5 = f_map[4][2];
          y4 = f_map[3][3];
          y3 = f_map[2][4];
          y2 = f_map[1][5];
          y1 = f_map[0][0];
         // Weights
          x5 = w_map[4][1];
          x4 = w_map[3][2];
          x3 = w_map[2][3];
          x2 = w_map[1][4];
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 14
         // Features
          y6 = f_map[5][2]; 
          y5 = f_map[4][3];
          y4 = f_map[3][4];
          y3 = f_map[2][5];
          y2 = f_map[1][0];
          y1 = f_map[0][1];
         // Weights
          x5 = w_map[4][2];
          x4 = w_map[3][3];
          x3 = w_map[2][4];
          x2 = 'd0;
          x1 = w_map[0][0];
          display_values();
        @(posedge clk); // Clock 15
         // Features
          y6 = f_map[5][3]; 
          y5 = f_map[4][4];
          y4 = f_map[3][5];
          y3 = f_map[2][0];
          y2 = f_map[1][1];
          y1 = f_map[0][2];
         // Weights
          x5 = w_map[4][3];
          x4 = w_map[3][4];
          x3 = 'd0;
          x2 = w_map[1][0];
          x1 = w_map[0][1];
          display_values();
        @(posedge clk); // Clock 16
          // Features
          y6 = f_map[5][4]; 
          y5 = f_map[4][5];
          y4 = f_map[3][0];
          y3 = f_map[2][1];
          y2 = f_map[1][2];
          y1 = f_map[0][3];
         // Weights
          x5 = w_map[4][4];
          x4 = 'd0;
          x3 = w_map[2][0];
          x2 = w_map[1][1];
          x1 = w_map[0][2];
          display_values();
        @(posedge clk); // Clock 17
         // Features
          y6 = f_map[5][5]; 
          y5 = f_map[4][0];
          y4 = f_map[3][1];
          y3 = f_map[2][2];
          y2 = f_map[1][3];
          y1 = f_map[0][4];
         // Weights
          x5 = 'd0;
          x4 = w_map[3][0];
          x3 = w_map[2][1];
          x2 = w_map[1][2];
          x1 = w_map[0][3];
          display_values();
        @(posedge clk); // Clock 18
         // Features
          y6 = f_map[5][0]; 
          y5 = f_map[4][1];
          y4 = f_map[3][2];
          y3 = f_map[2][3];
          y2 = f_map[1][4];
          y1 = f_map[0][5];
         // Weights
          x5 = w_map[4][0];
          x4 = w_map[3][1];
          x3 = w_map[2][2];
          x2 = w_map[1][3];
          x1 = w_map[0][4];
          display_values();
        @(posedge clk); // Clock 19
         // Features
          y6 = f_map[5][1]; 
          y5 = f_map[4][2];
          y4 = f_map[3][3];
          y3 = f_map[2][4];
          y2 = f_map[1][5];
          y1 = f_map[0][0];
         // Weights
          x5 = w_map[4][1];
          x4 = w_map[3][2];
          x3 = w_map[2][3];
          x2 = w_map[1][4];
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 20
         // Features
          y6 = f_map[5][2]; 
          y5 = f_map[4][3];
          y4 = f_map[3][4];
          y3 = f_map[2][5];
          y2 = f_map[1][0];
          y1 = f_map[0][1];
         // Weights
          x5 = w_map[4][2];
          x4 = w_map[3][3];
          x3 = w_map[2][4];
          x2 = 'd0;
          x1 = w_map[0][0];
          display_values();
        @(posedge clk); // Clock 21
         // Features
          y6 = f_map[5][3]; 
          y5 = f_map[4][4];
          y4 = f_map[3][5];
          y3 = f_map[2][0];
          y2 = f_map[1][1];
          y1 = f_map[0][2];
         // Weights
          x5 = w_map[4][3];
          x4 = w_map[3][4];
          x3 = 'd0;
          x2 = w_map[1][0];
          x1 = w_map[0][1];
          display_values();
        @(posedge clk); // Clock 22
          // Features
          y6 = f_map[5][4]; 
          y5 = f_map[4][5];
          y4 = f_map[3][0];
          y3 = f_map[2][1];
          y2 = f_map[1][2];
          y1 = f_map[0][3];
         // Weights
          x5 = w_map[4][4];
          x4 = 'd0;
          x3 = w_map[2][0];
          x2 = w_map[1][1];
          x1 = w_map[0][2];
          display_values();
        @(posedge clk); // Clock 23
         // Features
          y6 = f_map[5][5]; 
          y5 = f_map[4][0];
          y4 = f_map[3][1];
          y3 = f_map[2][2];
          y2 = f_map[1][3];
          y1 = f_map[0][4];
         // Weights
          x5 = 'd0;
          x4 = w_map[3][0];
          x3 = w_map[2][1];
          x2 = w_map[1][2];
          x1 = w_map[0][3];
          display_values();
        @(posedge clk); // Clock 24
         // Features
          y6 = f_map[5][0]; 
          y5 = f_map[4][1];
          y4 = f_map[3][2];
          y3 = f_map[2][3];
          y2 = f_map[1][4];
          y1 = f_map[0][5];
         // Weights
          x5 = w_map[4][0];
          x4 = w_map[3][1];
          x3 = w_map[2][2];
          x2 = w_map[1][3];
          x1 = w_map[0][4];
          display_values();
        @(posedge clk); // Clock 25
         // Features
          y6 = f_map[5][1]; 
          y5 = f_map[4][2];
          y4 = f_map[3][3];
          y3 = f_map[2][4];
          y2 = f_map[1][5];
          y1 = f_map[0][0];
         // Weights
          x5 = w_map[4][1];
          x4 = w_map[3][2];
          x3 = w_map[2][3];
          x2 = w_map[1][4];
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 26
         // Features
          y6 = f_map[5][2]; 
          y5 = f_map[4][3];
          y4 = f_map[3][4];
          y3 = f_map[2][5];
          y2 = f_map[1][0];
          y1 = f_map[0][1];
         // Weights
          x5 = w_map[4][2];
          x4 = w_map[3][3];
          x3 = w_map[2][4];
          x2 = 'd0;
          x1 = w_map[0][0];
          display_values();
        @(posedge clk); // Clock 27
         // Features
          y6 = f_map[5][3]; 
          y5 = f_map[4][4];
          y4 = f_map[3][5];
          y3 = f_map[2][0];
          y2 = f_map[1][1];
          y1 = f_map[0][2];
         // Weights
          x5 = w_map[4][3];
          x4 = w_map[3][4];
          x3 = 'd0;
          x2 = w_map[1][0];
          x1 = w_map[0][1];
          display_values();
        @(posedge clk); // Clock 28
          // Features
          y6 = f_map[5][4]; 
          y5 = f_map[4][5];
          y4 = f_map[3][0];
          y3 = f_map[2][1];
          y2 = f_map[1][2];
          y1 = f_map[0][3];
         // Weights
          x5 = w_map[4][4];
          x4 = 'd0;
          x3 = w_map[2][0];
          x2 = w_map[1][1];
          x1 = w_map[0][2];
          display_values();
        @(posedge clk); // Clock 29
         // Features
          y6 = f_map[5][5]; 
          y5 = f_map[4][0];
          y4 = f_map[3][1];
          y3 = f_map[2][2];
          y2 = f_map[1][3];
          y1 = f_map[0][4];
         // Weights
          x5 = 'd0;
          x4 = w_map[3][0];
          x3 = w_map[2][1];
          x2 = w_map[1][2];
          x1 = w_map[0][3];
          display_values();
        @(posedge clk); // Clock 30
         // Features
          y6 = f_map[5][0]; 
          y5 = f_map[4][1];
          y4 = f_map[3][2];
          y3 = f_map[2][3];
          y2 = f_map[1][4];
          y1 = f_map[0][5];
         // Weights
          x5 = w_map[4][0];
          x4 = w_map[3][1];
          x3 = w_map[2][2];
          x2 = w_map[1][3];
          x1 = w_map[0][4];
          display_values();
        @(posedge clk); // Clock 31
         // Features
          y6 = f_map[5][1]; 
          y5 = f_map[4][2];
          y4 = f_map[3][3];
          y3 = f_map[2][4];
          y2 = f_map[1][5];
          y1 = f_map[0][0];
         // Weights
          x5 = w_map[4][1];
          x4 = w_map[3][2];
          x3 = w_map[2][3];
          x2 = w_map[1][4];
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 32
         // Features
          y6 = f_map[5][2]; 
          y5 = f_map[4][3];
          y4 = f_map[3][4];
          y3 = f_map[2][5];
          y2 = f_map[1][0];
          y1 = f_map[0][1];
         // Weights
          x5 = w_map[4][2];
          x4 = w_map[3][3];
          x3 = w_map[2][4];
          x2 = 'd0;
          x1 = w_map[0][0];
          display_values();
        @(posedge clk); // Clock 33
         // Features
          y6 = f_map[5][3]; 
          y5 = f_map[4][4];
          y4 = f_map[3][5];
          y3 = f_map[2][0];
          y2 = f_map[1][1];
          y1 = f_map[0][2];
         // Weights
          x5 = w_map[4][3];
          x4 = w_map[3][4];
          x3 = 'd0;
          x2 = w_map[1][0];
          x1 = w_map[0][1];
          display_values();
        @(posedge clk); // Clock 34
          // Features
          y6 = f_map[5][4]; 
          y5 = f_map[4][5];
          y4 = f_map[3][0];
          y3 = f_map[2][1];
          y2 = f_map[1][2];
          y1 = f_map[0][3];
         // Weights
          x5 = w_map[4][4];
          x4 = 'd0;
          x3 = w_map[2][0];
          x2 = w_map[1][1];
          x1 = w_map[0][2];
          display_values();
        @(posedge clk); // Clock 35
         // Features
          y6 = f_map[5][5]; 
          y5 = f_map[4][0];
          y4 = f_map[3][1];
          y3 = f_map[2][2];
          y2 = f_map[1][3];
          y1 = f_map[0][4];
         // Weights
          x5 = 'd0;
          x4 = w_map[3][0];
          x3 = w_map[2][1];
          x2 = w_map[1][2];
          x1 = w_map[0][3];
          display_values();
        @(posedge clk); // Clock 36
         // Features
          y6 = f_map[5][0]; 
          y5 = f_map[4][1];
          y4 = f_map[3][2];
          y3 = f_map[2][3];
          y2 = f_map[1][4];
          y1 = f_map[0][5];
         // Weights
          x5 = w_map[4][0];
          x4 = w_map[3][1];
          x3 = w_map[2][2];
          x2 = w_map[1][3];
          x1 = w_map[0][4];
          display_values();
        @(posedge clk); // Clock 37
         // Features
          y6 = f_map[5][1]; 
          y5 = f_map[4][2];
          y4 = f_map[3][3];
          y3 = f_map[2][4];
          y2 = f_map[1][5];
          y1 = 'd0;
         // Weights
          x5 = w_map[4][1];
          x4 = w_map[3][2];
          x3 = w_map[2][3];
          x2 = w_map[1][4];
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 38
         // Features
          y6 = f_map[5][2]; 
          y5 = f_map[4][3];
          y4 = f_map[3][4];
          y3 = f_map[2][5];
          y2 = 'd0;
          y1 = 'd0;
         // Weights
          x5 = w_map[4][2];
          x4 = w_map[3][3];
          x3 = w_map[2][4];
          x2 = 'd0;
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 39
         // Features
          y6 = f_map[5][3]; 
          y5 = f_map[4][4];
          y4 = f_map[3][5];
          y3 = 'd0;
          y2 = 'd0;
          y1 = 'd0;
         // Weights
          x5 = w_map[4][3];
          x4 = w_map[3][4];
          x3 = 'd0;
          x2 = 'd0;
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 40
          // Features
          y6 = f_map[5][4]; 
          y5 = f_map[4][5];
          y4 = 'd0;
          y3 = 'd0;
          y2 = 'd0;
          y1 = 'd0;
         // Weights
          x5 = w_map[4][4];
          x4 = 'd0;
          x3 = 'd0;
          x2 = 'd0;
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 41
         // Features
          y6 = f_map[5][5]; 
          y5 = 'd0;
          y4 = 'd0;
          y3 = 'd0;
          y2 = 'd0;
          y1 = 'd0;
         // Weights
          x5 = 'd0;
          x4 = 'd0;
          x3 = 'd0;
          x2 = 'd0;
          x1 = 'd0;
          display_values();  
    endtask //automatic
    task automatic pass();
        @(posedge clk); // Clock 1
         // Features
          y6 = 'd0; 
          y5 = 'd0;
          y4 = 'd0;
          y3 = 'd0;
          y2 = 'd0;
          y1 = f_map[0][0];
         // Weights
          x5 = 'd0;
          x4 = 'd0;
          x3 = 'd0;
          x2 = 'd0;
          x1 = 'd0; 
          display_values();
        @(posedge clk); // Clock 2
         // Features
          y6 = 'd0; 
          y5 = 'd0;
          y4 = 'd0;
          y3 = 'd0;
          y2 = f_map[1][0];
          y1 = f_map[0][1];
         // Weights
          x5 = 'd0;
          x4 = 'd0;
          x3 = 'd0;
          x2 = 'd0;
          x1 = w_map[0][0];
          display_values();
        @(posedge clk); // Clock 3
         // Features
          y6 = 'd0; 
          y5 = 'd0;
          y4 = 'd0;
          y3 = f_map[2][0];
          y2 = f_map[1][1];
          y1 = f_map[0][2];
         // Weights
          x5 = 'd0;
          x4 = 'd0;
          x3 = 'd0;
          x2 = w_map[1][0];
          x1 = w_map[0][1];
          display_values();
        @(posedge clk); // Clock 4
         // Features
          y6 = 'd0; 
          y5 = 'd0;
          y4 = f_map[3][0];
          y3 = f_map[2][1];
          y2 = f_map[1][2];
          y1 = f_map[0][3];
         // Weights
          x5 = 'd0;
          x4 = 'd0;
          x3 = w_map[2][0];
          x2 = w_map[1][1];
          x1 = w_map[0][2];
          display_values();
        @(posedge clk); // Clock 5
         // Features
          y6 = 'd0; 
          y5 = f_map[4][0];
          y4 = f_map[3][1];
          y3 = f_map[2][2];
          y2 = f_map[1][3];
          y1 = f_map[0][4];
         // Weights
          x5 = 'd0;
          x4 = w_map[3][0];
          x3 = w_map[2][1];
          x2 = w_map[1][2];
          x1 = w_map[0][3];
          display_values();
        @(posedge clk); // Clock 6
         // Features
          y6 = f_map[5][0]; 
          y5 = f_map[4][1];
          y4 = f_map[3][2];
          y3 = f_map[2][3];
          y2 = f_map[1][4];
          y1 = f_map[0][5];
         // Weights
          x5 = w_map[4][0];
          x4 = w_map[3][1];
          x3 = w_map[2][2];
          x2 = w_map[1][3];
          x1 = w_map[0][4];
          display_values();
        @(posedge clk); // Clock 7
         // Features
          y6 = f_map[5][1]; 
          y5 = f_map[4][2];
          y4 = f_map[3][3];
          y3 = f_map[2][4];
          y2 = f_map[1][5];
          y1 = 'd0;
         // Weights
          x5 = w_map[4][1];
          x4 = w_map[3][2];
          x3 = w_map[2][3];
          x2 = w_map[1][4];
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 8
         // Features
          y6 = f_map[5][2]; 
          y5 = f_map[4][3];
          y4 = f_map[3][4];
          y3 = f_map[2][5];
          y2 = 'd0;
          y1 = 'd0;
         // Weights
          x5 = w_map[4][2];
          x4 = w_map[3][3];
          x3 = w_map[2][4];
          x2 = 'd0;
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 9
         // Features
          y6 = f_map[5][3]; 
          y5 = f_map[4][4];
          y4 = f_map[3][5];
          y3 = 'd0;
          y2 = 'd0;
          y1 = 'd0;
         // Weights
          x5 = w_map[4][3];
          x4 = w_map[3][4];
          x3 = 'd0;
          x2 = 'd0;
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 10
          // Features
          y6 = f_map[5][4]; 
          y5 = f_map[4][5];
          y4 = 'd0;
          y3 = 'd0;
          y2 = 'd0;
          y1 = 'd0;
         // Weights
          x5 = w_map[4][4];
          x4 = 'd0;
          x3 = 'd0;
          x2 = 'd0;
          x1 = 'd0;
          display_values();
        @(posedge clk); // Clock 11
         // Features
          y6 = f_map[5][5]; 
          y5 = 'd0;
          y4 = 'd0;
          y3 = 'd0;
          y2 = 'd0;
          y1 = 'd0;
         // Weights
          x5 = 'd0;
          x4 = 'd0;
          x3 = 'd0;
          x2 = 'd0;
          x1 = 'd0;
          display_values();
    endtask //automatic
    task automatic end_patch();
        @(posedge clk); // Clock 12
        // Features
          y6 = 'd0; 
          y5 = 'd0;
          y4 = 'd0;
          y3 = 'd0;
          y2 = 'd0;
          y1 = 'd0;
         // Weights
          x5 = 'd0;
          x4 = 'd0;
          x3 = 'd0;
          x2 = 'd0;
          x1 = 'd0;
        @(posedge clk); // Clock 13  
         clear = 1'b1;
    endtask 
    task automatic start_patch();
        @(posedge clk);
        clear = 'b0;
        start = 'b1;
        @(posedge clk);
        start = 'b0;
    endtask //automatic
endmodule
