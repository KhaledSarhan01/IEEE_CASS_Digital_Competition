package LeNet5_pkg;
    // Paths are relative to sim folder 
    parameter PARMETER_WIDTH = 8;          // Parameter is Weight or Feature
    parameter DNN_BUS_WIDTH  = PARMETER_WIDTH; // Represent the input/output feature bus for DNN
    typedef logic signed [15:0] sum_t;     // Q4.11 signed
    typedef logic signed [7:0]  weight_t;  // Q0.7  signed
    typedef logic        [7:0]  feature_t; // Q4.4  unsiged
    // Feature Maps
    parameter FLATTEN_LAYER_PARAMETERS = "../../../software/Quantized_Weights/FM_2/_flatten_FM2.mem";
    
    parameter FEATURE_MAP_2_SIZE = 256;
    parameter FEATURE_MAP_3_SIZE = 120;
    parameter FEATURE_MAP_4_SIZE = 84;
    parameter PREDICTION_SIZE   = 10;
        
    // Layers
    parameter DENSE_1_WEIGHT_FILE = "../../../software/Quantized_Weights/dense1/dense1_weight.mem";
    parameter DENSE_1_BIAS_FILE   = "../../../software/Quantized_Weights/dense1/dense1_bias.mem";
    parameter DENSE_2_WEIGHT_FILE = "../../../software/Quantized_Weights/dense2/dense2_weight.mem";
    parameter DENSE_2_BIAS_FILE   = "../../../software/Quantized_Weights/dense2/dense2_bias.mem";
    parameter DENSE_3_WEIGHT_FILE = "../../../software/Quantized_Weights/dense3/dense3_weight.mem";
    parameter DENSE_3_BIAS_FILE   = "../../../software/Quantized_Weights/dense3/dense3_bias.mem";
endpackage