import LeNet5_pkg::*;
module DNN #(
    parameter NUM_INPUT  = 84,
    parameter NUM_OUTPUT = 10,
    parameter OUT_FORMAT = "Q4_4",
    parameter string WEIGHT_FILE = "dense3_weight.mem",
    parameter string BIAS_FILE   = "dense3_bias.mem"
)(
    input logic clk,rst, 
    // Input Features bus
    input   feature_t                     in_feature,
    output  logic [$clog2(NUM_INPUT)-1:0] in_address,
    input   logic                         in_start,
    // Output Features bus
    output  feature_t                     out_feature,
    output  logic[$clog2(NUM_OUTPUT)-1:0] out_address,
    output  logic                         out_enable,
    output  logic                         out_done
);
// Paramters
    localparam NUM_WEIGHT = NUM_INPUT * NUM_OUTPUT;
    localparam NUM_BIAS   = NUM_OUTPUT;
// Signals
    logic [$clog2(NUM_WEIGHT)-1:0] weight_address;
    logic [$clog2(NUM_BIAS)-1:0]   bias_address;    
    logic bias_en;
    logic weight_en;
    logic MAC_done;    
// DNN Control
    DNN_Control #(
    .NUM_INPUT (NUM_INPUT),
    .NUM_OUTPUT(NUM_OUTPUT)
    ) u_DNN_Control(
        .clk(clk),
        .rst(rst),
        // Extrenal Interface 
        .in_address(in_address),
        .in_start(in_start),
        .out_address(out_address),
        .out_enable(MAC_done),
        .out_done(out_done),
        // Internal Controls
        .weight_address(weight_address),
        .bias_address(bias_address),    
        .bias_en(bias_en),
        .weight_en(weight_en)    
    );  
// MAC
    weight_t  bias;
    weight_t  weight,weight_reg;
    sum_t     MAC_out;
    // Solve Alignment Problem in Top System
    always_ff @( posedge clk or posedge rst ) begin 
        if(rst)begin
            weight_reg <= 'b0;
        end else begin
            weight_reg <= weight;
        end
    end
    MAC u_DNN_MAC (
        .clk(clk),
        .rst(rst),
        // Weight and input feature per clock cycle
        .feature_in(in_feature),
        .weight(weight_reg),
        .weight_en(weight_en), // Start multiplication if one
        // Bais in the addition Starting 
        .bais(bias),
        .bais_en(bias_en),  // MAC_out = bais if one 
        // Accumalating Output Feature  
        .MAC_out(MAC_out)
    );
// RelU
    relu #(
        .OUT_FORMAT(OUT_FORMAT)
    ) u_DNN_Relu (
        .clk(clk),
        .rst(rst),
        .relu_in(MAC_out),
        .relu_in_en(MAC_done),
        .relu_out(out_feature),
        .relu_out_en(out_enable)
    );
// Weight ROM
    ROM #(
        .MEM_SIZE(NUM_WEIGHT),
        .DATA_WIDTH(PARMETER_WIDTH),
        .FILE_NAME(WEIGHT_FILE)
    ) u_DNN_Weight_ROM (
        .clk(clk),
        .addr(weight_address),
        .data_out(weight)
    );
// Bias ROM
    ROM #(
        .MEM_SIZE(NUM_BIAS),
        .DATA_WIDTH(PARMETER_WIDTH),
        .FILE_NAME(BIAS_FILE)
    ) u_DNN_Bias_ROM (
        .clk(clk),
        .addr(bias_address),
        .data_out(bias)
    ); 
endmodule