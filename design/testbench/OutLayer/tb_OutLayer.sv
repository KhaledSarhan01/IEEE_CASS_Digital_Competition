import LeNet5_pkg::*;
module tb_Output_Layer;
// Signals
    logic clk,rst; 
    // Input Features
    feature_t   in_feature;
    logic [3:0] in_address; // to address 10 location, we need 4 bit address
    logic       in_enable;
    logic       in_start; 
    // Output Prediction 
    logic [9:0] prediction;
    logic       predict_valid;
// Instantiation
Output_Layer DUT (.*);
// Clock Generation
    initial begin
        clk = 'b0;
        forever #5 clk = ~clk;
    end
// Data importing
    logic [7:0] inputs_features [9:0];
    initial begin
        $readmemh("../../testbench/OutLayer/inputs.mem",inputs_features);
    end
// Testbench 
    initial begin
        Initialization();
        Reset();
        MainTest();
        // wait
        repeat(2000) @(negedge clk);
        $stop; 
    end
// Tasks 
    task automatic Initialization();
        in_feature = 'b0;
        in_address = 'b0; 
        in_enable  = 'b0;
        in_start   = 'b0; 
    endtask 
    task automatic Reset();
        // Reset 
        rst = 1;
        @(negedge clk);
        rst = 0;
    endtask
    task automatic MainTest();
        for (bit [3:0] i = 0; i <= 9 ;i++) begin
            repeat(84) @(posedge clk);
            in_feature = inputs_features[i];
            in_address = i; 
            in_enable  = 'b1;
            @(posedge clk);
            in_enable  = 'b0; 
        end
        // Start 
        @(posedge clk);
        in_start = 1'b1;
        @(posedge clk);
        in_start = 1'b0;    
    endtask       
endmodule