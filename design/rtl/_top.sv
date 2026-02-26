import LeNet5_pkg::*;
// DNN_BUS_WIDTH = 1 Byte 
module LeNet5(
    input logic clk,rst,
    // Start Signal 
    input logic LeNet_start, // TODO: To be removed when communication protocol is added
    // Output Predication 
    output logic [9:0] out_argmax_prediction,
    output logic out_valid
);
    // CNN Layers
        /* 
         Assume all CNN Layers have computed its values 
         and output it in ROM memory representing the flatten interface 
         */
        // Signals
            logic [$clog2(FEATURE_MAP_2_SIZE)-1:0] dense1_address_in; 
            logic [DNN_BUS_WIDTH-1:0]              dense1_feature_in;
        // ROM
            ROM #(
                .MEM_SIZE(FEATURE_MAP_2_SIZE), 
                .DATA_WIDTH(DNN_BUS_WIDTH),
                .FILE_NAME(FLATTEN_LAYER_PARAMETERS)
            ) u_flatten_layer (
                .clk(clk),
                .addr(dense1_address_in),
                .data_out(dense1_feature_in)
            );
    // Dense 1 Layer
        // Signals
            logic[DNN_BUS_WIDTH-1:0]              dense1_feature_out;
            logic[$clog2(FEATURE_MAP_3_SIZE)-1:0] dense1_address_out;
            logic                                 dense1_write_enable;
            logic                                 dense1_done;

            logic[DNN_BUS_WIDTH-1:0]              dense2_feature_in;
            logic[$clog2(FEATURE_MAP_3_SIZE)-1:0] dense2_address_in;
            logic                                 dense2_start;
        // DNN Layer
            DNN #(
                .NUM_INPUT  (FEATURE_MAP_2_SIZE),
                .NUM_OUTPUT (FEATURE_MAP_3_SIZE),
                .WEIGHT_FILE(DENSE_1_WEIGHT_FILE),
                .BIAS_FILE  (DENSE_1_BIAS_FILE)
            )u_dense1_DNN(
                .clk(clk),
                .rst(rst), 
                // Input Features bus
                .in_feature (dense1_feature_in),
                .in_address (dense1_address_in),
                .in_start   (LeNet_start),
                // Output Features bus
                .out_feature(dense1_feature_out),
                .out_address(dense1_address_out),
                .out_enable (dense1_write_enable),
                .out_done   (dense1_done)
            );
        // Output RAM
            RAM #(
                .MEM_SIZE(FEATURE_MAP_3_SIZE),
                .DATA_WIDTH(DNN_BUS_WIDTH)
            )u_feature_map_3_RAM(
                // Input Write Port
                .in_clk      (clk),
                .write_addr  (dense1_address_out),
                .data_in     (dense1_feature_out),
                .write_enable(dense1_write_enable),
                .in_done     (dense1_done),
                // Output Read Port
                .out_clk  (clk),
                .read_addr(dense2_address_in),
                .data_out (dense2_feature_in),
                .out_done (dense2_start)
            );
    // Dense 2 Layer
        // Signals
            logic[DNN_BUS_WIDTH-1:0]              dense2_feature_out;
            logic[$clog2(FEATURE_MAP_4_SIZE)-1:0] dense2_address_out;
            logic                                 dense2_write_enable;
            logic                                 dense2_done;

            logic[DNN_BUS_WIDTH-1:0]              dense3_feature_in;
            logic[$clog2(FEATURE_MAP_4_SIZE)-1:0] dense3_address_in;
            logic                                 dense3_start;
        // DNN
            DNN #(
                .NUM_INPUT  (FEATURE_MAP_3_SIZE),
                .NUM_OUTPUT (FEATURE_MAP_4_SIZE),
                .WEIGHT_FILE(DENSE_2_WEIGHT_FILE),
                .BIAS_FILE  (DENSE_2_BIAS_FILE)
            )u_dense2_DNN(
                .clk(clk),
                .rst(rst), 
                // Input Features bus
                .in_feature(dense2_feature_in),
                .in_address(dense2_address_in),
                .in_start  (dense2_start),
                // Output Features bus
                .out_feature(dense2_feature_out),
                .out_address(dense2_address_out),
                .out_enable (dense2_write_enable),
                .out_done   (dense2_done)
            );
        // Output RAM
            RAM #(
                .MEM_SIZE(FEATURE_MAP_4_SIZE),
                .DATA_WIDTH(DNN_BUS_WIDTH)
            )u_feature_map_4_RAM(
                // Input Write Port
                .in_clk      (clk),
                .write_addr  (dense2_address_out),
                .data_in     (dense2_feature_out),
                .write_enable(dense2_write_enable),
                .in_done     (dense2_done),
                // Output Read Port
                .out_clk    (clk),
                .read_addr  (dense3_address_in),
                .data_out   (dense3_feature_in),
                .out_done   (dense3_start)
            );
    // Dense 3 Layer
        // Signals
            logic[DNN_BUS_WIDTH-1:0]              dense3_feature_out;
            logic[$clog2(PREDICTION_SIZE)-1:0] dense3_address_out;
            logic                                 dense3_write_enable;
            logic                                 dense3_done;
        // DNN
            DNN #(
                .NUM_INPUT  (FEATURE_MAP_4_SIZE),
                .NUM_OUTPUT (PREDICTION_SIZE),
                .WEIGHT_FILE(DENSE_3_WEIGHT_FILE),
                .BIAS_FILE  (DENSE_3_BIAS_FILE)
            )u_dense3_DNN(
                .clk(clk),
                .rst(rst), 
                // Input Features bus
                .in_feature(dense3_feature_in),
                .in_address(dense3_address_in),
                .in_start  (dense3_start),
                // Output Features bus
                .out_feature(dense3_feature_out),
                .out_address(dense3_address_out),
                .out_enable (dense3_write_enable),
                .out_done   (dense3_done)
            ); 
    // Output Layer 
        /* 
            This is an Architecture for the output layer that uses
            one DNN Module.
            For Faster implementation use 10 DNN Module for each 
            predication Channel. 
        */
        Output_Layer u_output_layer(
            .clk(clk),
            .rst(rst),
            // Input Features
            .in_feature(dense3_feature_out),
            .in_address(dense3_address_out),
            .in_enable (dense3_write_enable),
            .in_start  (dense3_done), 
            // Output Prediction 
            .prediction(out_argmax_prediction),
            .predict_valid(out_valid)
        );                                 
endmodule