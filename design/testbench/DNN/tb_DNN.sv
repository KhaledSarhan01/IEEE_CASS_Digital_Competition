import LeNet5_pkg::*;
module tb_DNN;
// Signals
    parameter NUM_INPUT  = 84;
    parameter NUM_OUTPUT = 10;
    parameter OUT_FORMAT = "Q1_7";
    parameter WEIGHT_FILE = "../../testbench/DNN/dense3_weight.mem";
    parameter BIAS_FILE   = "../../testbench/DNN/dense3_bias.mem";
    localparam NUM_WEIGHT = NUM_INPUT*NUM_OUTPUT;
    localparam NUM_BIAS   = NUM_OUTPUT;

    logic clk,rst; 
    // Input Features bus
    feature_t                     in_feature;
    logic [$clog2(NUM_INPUT)-1:0] in_address;
    logic                         in_start;
    // Output Features bus
    feature_t                     out_feature;
    logic[$clog2(NUM_OUTPUT)-1:0] out_address;
    logic                         out_enable;
    logic                         out_done;
// Instantiation
DNN #(
    .NUM_INPUT(NUM_INPUT),
    .NUM_OUTPUT(NUM_OUTPUT),
    .WEIGHT_FILE(WEIGHT_FILE),
    .BIAS_FILE(BIAS_FILE)
) DUT(.*);
// Clock Generation
    initial begin
        clk = 'b0;
        forever #5 clk = ~clk;
    end
// Data importing
    logic [7:0] input_features  [NUM_INPUT-1:0];
    // logic [7:0] output_features [NUM_OUTPUT-1:0];
    initial begin
        $readmemh("../../testbench/DNN/input_features.mem",input_features);
        // $readmemh("../../testbench/DNN/output_features.mem",output_features);
    end
    assign in_feature = input_features[in_address];
// Testbench 
    initial begin
        // Initialization
        in_start   = 'b0;
        // Reset 
        rst = 1;
        @(negedge clk);
        rst = 0;
        // start
        @(negedge clk);
        in_start = 1'b1; 
        @(negedge clk);
        in_start = 1'b0;
        // wait
        repeat(2000) @(negedge clk);
        $stop; 
    end 
endmodule