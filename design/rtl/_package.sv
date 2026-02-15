package LeNet5_pkg;
    parameter PARMETER_WIDTH = 8;          // Parameter is Weight or Feature
    typedef logic signed [15:0] sum_t;     // Q4.11 signed
    typedef logic signed [7:0]  weight_t;  // Q0.7  signed
    typedef logic        [7:0]  feature_t; // Q4.4  unsiged
endpackage