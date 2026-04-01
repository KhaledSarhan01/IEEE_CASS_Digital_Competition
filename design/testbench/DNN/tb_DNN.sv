import LeNet5_pkg::*;
module tb_DNN;
// Signals
    parameter OUT_FORMAT = "Q4_4";
    
    parameter NUM_INPUT            = FEATURE_MAP_3_SIZE;
    parameter NUM_OUTPUT           = FEATURE_MAP_4_SIZE;
    parameter WEIGHT_FILE          = "../../../software/Parameters/Weight/dense2/dense2_weight.mem";
    parameter BIAS_FILE            = "../../../software/Parameters/Weight/dense2/dense2_bias.mem";
    parameter INPUT_FEATURES_FILE  = "../../../software/Parameters/Tests/3/FM_3/Feature_Map_3.mem";
    parameter OUTPUT_FEATURES_FILE = "../../../software/Parameters/Tests/3/FM_4/Feature_Map_4.mem";
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
    feature_t input_features  [NUM_INPUT-1:0];
    feature_t computed_feautures [NUM_OUTPUT-1:0];
    feature_t output_features [NUM_OUTPUT-1:0];
    initial begin
        $readmemh(INPUT_FEATURES_FILE,input_features);
        $readmemh(OUTPUT_FEATURES_FILE,output_features);
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
        repeat(40000) @(negedge clk);
        $stop; 
    end 
    initial begin
        fork
            begin
                // Wait for the process to actually begin
                wait(in_start); 
                
                // Keep checking every clock cycle
                forever begin
                    @(posedge clk); 
                    if (out_enable) begin
                        computed_feautures[out_address] = out_feature;
                        // $display("computed_feature[%0d]= %4f",out_address,out_feature/8.0);
                        $display("%4f",out_feature/8.0);
                    end
                    if(out_done)begin
                        break;
                    end
                end
            end
        join // Use join_none so it doesn't block the rest of your initial block
        // check_array_equality(output_features,computed_feautures);
    end 
    task check_array_equality (
        input  feature_t expected_arr [NUM_OUTPUT],
        input  feature_t computed_arr [NUM_OUTPUT]
    );
        int error_count;
        error_count = 0; // Initialize counter

        for (int i = 0; i <= NUM_OUTPUT-1; i++) begin
            // Using !== to catch X or Z mismatches if they occur
            if ((expected_arr[i] - computed_arr[i])>0.25) begin
                $display("[ERROR] Mismatch at index %0d: Expected %4f, Got %4f", 
                        i, expected_arr[i]/8.0, computed_arr[i]/8.0);
                error_count++;
            end
        end

        if (error_count == 0) begin
            $display("[SUCCESS] All %0d elements match!", FEATURE_MAP_3_SIZE);
        end else begin
            $display("[FAILURE] Found %0d total mismatches.", error_count);
        end
    endtask 
endmodule