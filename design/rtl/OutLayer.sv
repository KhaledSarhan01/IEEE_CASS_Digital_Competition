import LeNet5_pkg::*;
module Output_Layer(
    input logic clk,
    input logic rst,
    // Input Features
    input feature_t   in_feature,
    input logic [3:0] in_address, // to address 10 location, we need 4 bit address
    input logic       in_enable,
    input logic       in_start, 
    // Output Prediction 
    output logic [9:0] prediction,
    output logic       predict_valid
);
/*
    Design:
    1. Register input in its respective place using in_enable.
    2. after in_start= 1, start comparing sequence to know the highest.
    3. output the argmax prediction.
*/
// 1. Registering the inputs 
    feature_t feature_reg [15:0];  
    always_ff @( posedge clk or posedge rst) begin 
        if (rst) begin
            for (int i = 0; i <= 15; i++) begin
                feature_reg[i] <= 'b0;
            end
        end else if(in_enable) begin
            feature_reg[in_address] <= in_feature;
        end
    end
    logic [4:0] strat_reg;
    always_ff @( posedge clk or posedge rst ) begin 
        if (rst) begin
            strat_reg <= 'b0;
        end else begin
            strat_reg[0] <= in_start;
            strat_reg[1] <= strat_reg[0];
            strat_reg[2] <= strat_reg[1];
            strat_reg[3] <= strat_reg[2];
            strat_reg[4] <= strat_reg[3];
        end
    end
// 2. Compartor Tree
    // First Layer 
        // feature_reg[0] vs feature_reg[1]
        feature_t   winner_1_q1_value,winner_1_q1_value_comb;
        logic [9:0] winner_1_q1_id,winner_1_q1_id_comb;
        always_comb begin 
            if (feature_reg[0] > feature_reg[1]) begin
                winner_1_q1_value_comb = feature_reg[0];
                winner_1_q1_id_comb    = 10'b00000_00001;
            end else begin
                winner_1_q1_value_comb = feature_reg[1];
                winner_1_q1_id_comb    = 10'b00000_00010;
            end
        end
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                winner_1_q1_id    <= 'b0;
                winner_1_q1_value <= 'b0;
            end else if(strat_reg[1]) begin
                winner_1_q1_id    <= winner_1_q1_id_comb;
                winner_1_q1_value <= winner_1_q1_value_comb;
            end
        end
        // feature_reg[2] vs feature_reg[3]
        feature_t   winner_2_q1_value,winner_2_q1_value_comb;
        logic [9:0] winner_2_q1_id,winner_2_q1_id_comb;
        always_comb begin 
            if (feature_reg[2] > feature_reg[3]) begin
                winner_2_q1_value_comb = feature_reg[2];
                winner_2_q1_id_comb    = 10'b00000_00100;
            end else begin
                winner_2_q1_value_comb = feature_reg[3];
                winner_2_q1_id_comb    = 10'b00000_01000;
            end
        end
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                winner_2_q1_id    <= 'b0;
                winner_2_q1_value <= 'b0;
            end else if(strat_reg[1]) begin
                winner_2_q1_id    <= winner_2_q1_id_comb;
                winner_2_q1_value <= winner_2_q1_value_comb;
            end
        end
        // feature_reg[4] vs feature_reg[5]
        feature_t   winner_3_q1_value,winner_3_q1_value_comb;
        logic [9:0] winner_3_q1_id,winner_3_q1_id_comb;
        always_comb begin 
            if (feature_reg[4] > feature_reg[5]) begin
                winner_3_q1_value_comb = feature_reg[4];
                winner_3_q1_id_comb    = 10'b00000_10000;
            end else begin
                winner_3_q1_value_comb = feature_reg[5];
                winner_3_q1_id_comb    = 10'b00001_00000;
            end
        end
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                winner_3_q1_id    <= 'b0;
                winner_3_q1_value <= 'b0;
            end else if(strat_reg[1]) begin
                winner_3_q1_id    <= winner_3_q1_id_comb;
                winner_3_q1_value <= winner_3_q1_value_comb;
            end
        end
        // feature_reg[6] vs feature_reg[7]
        feature_t   winner_4_q1_value,winner_4_q1_value_comb;
        logic [9:0] winner_4_q1_id,winner_4_q1_id_comb;
        always_comb begin 
            if (feature_reg[6] > feature_reg[7]) begin
                winner_4_q1_value_comb = feature_reg[6];
                winner_4_q1_id_comb    = 10'b00010_00000;
            end else begin
                winner_4_q1_value_comb = feature_reg[7];
                winner_4_q1_id_comb    = 10'b00100_00000;
            end
        end
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                winner_4_q1_id    <= 'b0;
                winner_4_q1_value <= 'b0;
            end else if(strat_reg[1]) begin
                winner_4_q1_id    <= winner_4_q1_id_comb;
                winner_4_q1_value <= winner_4_q1_value_comb;
            end
        end
        // feature_reg[8] vs feature_reg[9]
        feature_t   winner_5_q1_value,winner_5_q1_value_comb;
        logic [9:0] winner_5_q1_id,winner_5_q1_id_comb;
        always_comb begin 
            if (feature_reg[8] > feature_reg[9]) begin
                winner_5_q1_value_comb = feature_reg[8];
                winner_5_q1_id_comb    = 10'b01000_00000;
            end else begin
                winner_5_q1_value_comb = feature_reg[9];
                winner_5_q1_id_comb    = 10'b10000_00000;
            end
        end
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                winner_5_q1_id    <= 'b0;
                winner_5_q1_value <= 'b0;
            end else if(strat_reg[1]) begin
                winner_5_q1_id    <= winner_5_q1_id_comb;
                winner_5_q1_value <= winner_5_q1_value_comb;
            end
        end
    // Second Layer
        // winner_1_q1 vs winner_2_q1
        feature_t   winner_1_q2_value,winner_1_q2_value_comb;
        logic [9:0] winner_1_q2_id,winner_1_q2_id_comb;
        always_comb begin 
            if (winner_1_q1_value > winner_2_q1_value) begin
                winner_1_q2_value_comb = winner_1_q1_value;
                winner_1_q2_id_comb    = winner_1_q1_id;
            end else begin
                winner_1_q2_value_comb = winner_2_q1_value;
                winner_1_q2_id_comb    = winner_2_q1_id;
            end
        end
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                winner_1_q2_id    <= 'b0;
                winner_1_q2_value <= 'b0;
            end else if(strat_reg[2]) begin
                winner_1_q2_id    <= winner_1_q2_id_comb;
                winner_1_q2_value <= winner_1_q2_value_comb;
            end
        end
        // winner_3_q1 vs winner_4_q1
        feature_t   winner_2_q2_value,winner_2_q2_value_comb;
        logic [9:0] winner_2_q2_id,winner_2_q2_id_comb;
        always_comb begin 
            if (winner_3_q1_value > winner_4_q1_value) begin
                winner_2_q2_value_comb = winner_3_q1_value;
                winner_2_q2_id_comb    = winner_3_q1_id;
            end else begin
                winner_2_q2_value_comb = winner_4_q1_value;
                winner_2_q2_id_comb    = winner_4_q1_id;
            end
        end
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                winner_2_q2_id    <= 'b0;
                winner_2_q2_value <= 'b0;
            end else if(strat_reg[2]) begin
                winner_2_q2_id    <= winner_2_q2_id_comb;
                winner_2_q2_value <= winner_2_q2_value_comb;
            end
        end
        // winner_5_q1 passage
        feature_t   winner_3_q2_value;
        logic [9:0] winner_3_q2_id;
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                winner_3_q2_id    <= 'b0;
                winner_3_q2_value <= 'b0;
            end else if(strat_reg[2]) begin
                winner_3_q2_id    <= winner_5_q1_id;
                winner_3_q2_value <= winner_5_q1_value;
            end
        end
    // Third Layer
        // winner_1_q2 vs winner_2_q2
        feature_t   winner_1_q3_value,winner_1_q3_value_comb;
        logic [9:0] winner_1_q3_id,winner_1_q3_id_comb;
        always_comb begin 
            if (winner_1_q2_value > winner_2_q2_value) begin
                winner_1_q3_value_comb = winner_1_q2_value;
                winner_1_q3_id_comb    = winner_1_q2_id;
            end else begin
                winner_1_q3_value_comb = winner_2_q2_value;
                winner_1_q3_id_comb    = winner_2_q2_id;
            end
        end
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                winner_1_q3_id    <= 'b0;
                winner_1_q3_value <= 'b0;
            end else if(strat_reg[3]) begin
                winner_1_q3_id    <= winner_1_q3_id_comb;
                winner_1_q3_value <= winner_1_q3_value_comb;
            end
        end
        // winner_5_q2 passage
        feature_t   winner_2_q3_value;
        logic [9:0] winner_2_q3_id;
        always_ff @( posedge clk or posedge rst ) begin 
            if (rst) begin
                winner_2_q3_id    <= 'b0;
                winner_2_q3_value <= 'b0;
            end else if(strat_reg[3]) begin
                winner_2_q3_id    <= winner_3_q2_id;
                winner_2_q3_value <= winner_3_q2_value;
            end
        end
// Output layer
    // prediction
    logic [9:0] prediction_comb;
    always_comb begin 
        if (winner_1_q3_value > winner_2_q3_value) begin
            prediction_comb = winner_1_q3_id;
        end else begin
            prediction_comb = winner_2_q3_id;
        end
    end
        
    always_ff @( posedge clk or posedge rst ) begin 
        if (rst) begin
            prediction <= 'b0;
        end else if(strat_reg[4]) begin
            prediction <= prediction_comb;
        end
    end
    // predict_valid
    always_ff @( posedge clk or posedge rst ) begin 
        if (rst) begin
            predict_valid <= 'b0;
        end else begin
            predict_valid <= strat_reg[4];
        end
    end
endmodule