import LeNet5_pkg::*;
module DNN_Control #(
    parameter NUM_INPUT  = 84,
    parameter NUM_OUTPUT = 10
)(
    input logic clk,rst,
    // Extrenal Interface 
    output  logic [$clog2(NUM_INPUT)-1:0] in_address,
    input   logic                         in_start,
    output  logic[$clog2(NUM_OUTPUT)-1:0] out_address,
    output  logic                         out_enable,
    output  logic                         out_done,
    // input  logic                         out_ready,
    // output   logic                         in_ready,
    // Internal Controls
    output logic [$clog2(NUM_INPUT*NUM_OUTPUT)-1:0] weight_address,
    output logic [$clog2(NUM_OUTPUT)-1:0]           bias_address,    
    output logic                                    bias_en,
    output logic                                    weight_en    
);
// Parameters
    localparam NUM_WEIGHT = NUM_INPUT*NUM_OUTPUT;
    localparam NUM_BIAS   = NUM_OUTPUT;
// Signals   
    logic in_feature_increament;
    logic in_feature_restart;
    logic out_feature_increament;
    logic out_feature_restart;
    logic weight_increament;
    logic weight_restart;
    logic bias_increament;
    logic bias_restart;
// Counters
    // Input Feature Count
        logic current_feature_done;
        logic [$clog2(NUM_INPUT)-1:0] in_feature_count;
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                in_feature_count <= 'b0;
            end else begin
                if(in_feature_restart)begin
                in_feature_count <= 'b0; 
                end else if(in_feature_increament)begin
                    if (in_feature_count == NUM_INPUT-1) begin
                        in_feature_count <= 'b0;
                    end else begin
                        in_feature_count <= in_feature_count + 'd1; 
                    end
                end
            end
        end 
        assign in_address = in_feature_count;
        assign current_feature_done = (in_feature_count == NUM_INPUT-1);    
    // Output Feature Count
        logic all_features_done;
        logic [$clog2(NUM_OUTPUT)-1:0] out_feature_count;
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                out_feature_count <= 'b0;
            end else begin
                if(out_feature_restart)begin
                out_feature_count <= {$clog2(NUM_OUTPUT){1'b1}}; // -1
                end else if(out_feature_increament)begin
                    if (out_feature_count == NUM_OUTPUT-1) begin
                        out_feature_count <= {$clog2(NUM_OUTPUT){1'b1}}; // -1
                    end else begin
                        out_feature_count <= out_feature_count + 'd1; 
                    end
                end
            end
        end 
        assign out_address = out_feature_count;
        assign all_features_done = (out_feature_count == NUM_OUTPUT-1); 
    // Weight Count
        logic [$clog2(NUM_WEIGHT)-1:0] weight_count;
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                weight_count <= 'b0;
            end else begin
                if(weight_restart)begin
                weight_count <= 'b0; 
                end else if(weight_increament)begin
                    if (weight_count == NUM_WEIGHT-1) begin
                        weight_count <= 'b0;
                    end else begin
                        weight_count <= weight_count + 'd1; 
                    end
                end
            end
        end 
        assign weight_address = weight_count; 
    // Bias   Count
        logic [$clog2(NUM_BIAS)-1:0] bias_count;
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                bias_count <= 'b0;
            end else begin
                if(bias_restart)begin
                bias_count <= 'b0; 
                end else if(bias_increament)begin
                    if (bias_count == NUM_BIAS-1) begin
                        bias_count <= 'b0;
                    end else begin
                        bias_count <= bias_count + 'd1; 
                    end
                end
            end
        end 
        assign bias_address = bias_count; 
// DNN Control
    typedef enum logic[3:0] {RESET,IDLE,START,F_START,F_ACCUMLATE,F_DONE_Q1,F_DONE_Q2,F_LOAD,DONE} fsm_t;
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
                    next_state = F_DONE_Q1;
                end else begin
                    next_state = F_ACCUMLATE;
                end
            end
            F_DONE_Q1: next_state = F_DONE_Q2;
            F_DONE_Q2: next_state = F_LOAD;
            F_LOAD: begin
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
    always_comb begin 
        // Controls Output:
        in_feature_increament  = 'b0;
        in_feature_restart     = 'b0;
        out_feature_increament = 'b0;
        out_feature_restart    = 'b0;
        weight_increament      = 'b0;
        weight_restart         = 'b0;
        bias_increament        = 'b0;
        bias_restart           = 'b0;
        bias_en                = 'b0;
        weight_en              = 'b0;
        // Output: 
        out_enable  = 'b0;
        out_done    = 'b0;
        case (current_state)
            RESET: begin // All Zeros
                // Controls Output:
                in_feature_increament  = 'b0;
                in_feature_restart     = 'b0;
                out_feature_increament = 'b0;
                out_feature_restart    = 'b0;
                weight_increament      = 'b0;
                weight_restart         = 'b0;
                bias_increament        = 'b0;
                bias_restart           = 'b0;
                bias_en                = 'b0;
                weight_en              = 'b0;
                // Output: 
                out_enable  = 'b0;
                out_done    = 'b0;
            end
            IDLE: begin // All Zeros
                // Controls Output:
                in_feature_increament  = 'b0;
                in_feature_restart     = 'b0;
                out_feature_increament = 'b0;
                out_feature_restart    = 'b0;
                weight_increament      = 'b0;
                weight_restart         = 'b0;
                bias_increament        = 'b0;
                bias_restart           = 'b0;        
                bias_en                = 'b0;
                weight_en              = 'b0;
                // Output: 
                out_enable  = 'b0;
                out_done    = 'b0;
            end
            START:begin // Restart All counters
                in_feature_restart  = 'b1;
                out_feature_restart = 'b1;
                weight_restart      = 'b1;
                bias_restart        = 'b1;
            end 
            F_START:begin // Enable weight and bias        
                // Enable Weight/Bias
                bias_en                = 'b1;
                weight_en              = 'b0;
                // Increament feature/weight        
                in_feature_increament  = 'b1;
                weight_increament      = 'b1;
            end 
            F_ACCUMLATE:begin //Enable weight and increament feature/weight
                // Enable Weight
                weight_en              = 'b1;
                // Increament feature/weight        
                in_feature_increament  = 'b1;
                weight_increament      = 'b1;
            end
            F_DONE_Q1:begin// Disable Weight / Enable out_enable and Increament Bias/ out_feature_count  
                // Enable Weight
                weight_en              = 'b1;
                // Increament Bias/ out_feature_count        
                bias_increament        = 'b1;
                out_feature_increament = 'b1;
            end
            F_DONE_Q2:begin// Disable Weight / Enable out_enable and Increament Bias/ out_feature_count  
                // Enable Weight
                weight_en              = 'b1;
                // Restart input and weight count
                in_feature_restart = 1'b1;
            end
            F_LOAD: begin
                // Disable Weight / Enable out_enable 
                weight_en  = 'b0;
                out_enable = 'b1;
            end
            DONE:begin // Enable out_done
                out_done = 1'b1;
            end 
            default: begin
                // Controls Output:
                in_feature_increament  = 'b0;
                in_feature_restart     = 'b0;
                out_feature_increament = 'b0;
                out_feature_restart    = 'b0;
                weight_increament      = 'b0;
                weight_restart         = 'b0;
                bias_increament        = 'b0;
                bias_restart           = 'b0;
                // Output: 
                out_enable  = 'b0;
                out_done    = 'b0;
            end
        endcase
    end

endmodule