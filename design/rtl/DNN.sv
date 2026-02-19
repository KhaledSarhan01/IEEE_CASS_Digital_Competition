import LeNet5_pkg::*;
module DNN #(
    parameter NUM_INPUT  = 84,
    parameter NUM_OUTPUT = 10,
    parameter string WEIGHT_FILE = "dense3_weight.mem",
    parameter string BIAS_FILE   = "dense3_bias.mem",
)(
    input logic clk,rst, 
    // Input Features bus
    input   feature_t                     in_feature,
    output  logic [$clog2(NUM_INPUT)-1:0] in_address,
    input   logic                         in_start,
    input   logic                         in_ready,
    // Output Features bus
    output  feature_t                     out_feature,
    output  logic [$clog2(NUM_INPUT)-1:0] out_address,
    output  logic                         out_enable,
    output  logic                         out_done,
    output  logic                         out_ready
);
// Paramters
    localparam NUM_WEIGHT = NUM_INPUT * NUM_OUTPUT;
    localparam NUM_BIAS   = NUM_OUTPUT;
// Counters
    // Input  Feature Count 
    // Output Feature Count
    // Weight Count 
    // Bias   Count
// DNN Control
    typedef enum logic[3:0] {RESET,IDLE,START,F_START,F_ACCUMLATE,F_DONE,DONE} fsm_t;
    fsm_t current_state,next_state;
    // Sequential current_state Logic
    always_ff @( posedge clk or posedge rst ) begin 
        if (rst) begin
            current_state <= RESET;
        end else begin
            current_state <= next_state;
        end
    end  
    // Combinational next_state logic
    always_comb begin 
        case (current_state)
            RESET: next_state = IDLE;
            IDLE:begin
                if (in_start) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end
            START:  next_state = F_START;
            F_START:next_state = F_ACCUMLATE; 
            F_ACCUMLATE:begin
                if (current_feature_done) begin
                    next_state = F_DONE;
                end else begin
                    next_state = F_ACCUMLATE;
                end
            end
            F_DONE: begin
                if(all_features_done)begin
                    next_state = DONE;
                end else begin
                    next_state = F_START;
                end
            end
            DONE: next_state = IDLE;
            default: next_state = RESET;
        endcase 
    end
    // output logic 
// MAC
// RelU
// Weight ROM
// Bias ROM 
endmodule