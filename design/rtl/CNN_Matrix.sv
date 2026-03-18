import LeNet5_pkg::*;
module CNN (
    input logic clk,rst,
    input logic clear,
    input feature_t y1,y2,y3,y4,y5,y6,
    input weight_t  x1,x2,x3,x4,x5,
    output sum_t    c1,c2,c3,c4 
);
// Registering the features "y"
    feature_t y1_reg,y2_reg,y3_reg,y4_reg,y5_reg,y6_reg;
    always_ff @( posedge clk or posedge rst ) begin 
        if (rst) begin
            y1_reg <= 'b0;
            y2_reg <= 'b0;
            y3_reg <= 'b0;
            y4_reg <= 'b0;
            y5_reg <= 'b0;
            y6_reg <= 'b0;
        end else begin
            if (clear) begin
                y1_reg <= 'b0;
                y2_reg <= 'b0;
                y3_reg <= 'b0;
                y4_reg <= 'b0;
                y5_reg <= 'b0;
                y6_reg <= 'b0;
            end else begin
                y1_reg <= y1;
                y2_reg <= y2;
                y3_reg <= y3;
                y4_reg <= y4;
                y5_reg <= y5;
                y6_reg <= y6;
            end
        end
    end
// Registering the Weights "x"
    weight_t  x1_reg,x2_reg,x3_reg,x4_reg,x5_reg;
    always_ff @( posedge clk or posedge rst ) begin 
        if (rst) begin
            x1_reg <= 'b0;
            x2_reg <= 'b0;
            x3_reg <= 'b0;
            x4_reg <= 'b0;
            x5_reg <= 'b0;
        end else begin
            if (clear) begin
                x1_reg <= 'b0;
                x2_reg <= 'b0;
                x3_reg <= 'b0;
                x4_reg <= 'b0;
                x5_reg <= 'b0;
            end else begin
                x1_reg <= x1;
                x2_reg <= x2;
                x3_reg <= x3;
                x4_reg <= x4;
                x5_reg <= x5;
            end
        end
    end    
// C1 
    sum_t c1_1,c1_2,c1_3,c1_4,c1_5;
    PE u_c1_x1_y1(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(16'b0), // Previous Accumaltion
        .curr_x(x1), // Current Filter weight
        .curr_y(y1_reg), // Current Feature 
        .curr_c(c1_1)  // Current Accumaltion
    );
    PE u_c1_x2_y2(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c1_1), // Previous Accumaltion
        .curr_x(x2), // Current Filter weight
        .curr_y(y2_reg), // Current Feature 
        .curr_c(c1_2)  // Current Accumaltion
    );  
    PE u_c1_x3_y3(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c1_2), // Previous Accumaltion
        .curr_x(x3), // Current Filter weight
        .curr_y(y3_reg), // Current Feature 
        .curr_c(c1_3)  // Current Accumaltion
    );
    PE u_c1_x4_y4(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c1_3), // Previous Accumaltion
        .curr_x(x4), // Current Filter weight
        .curr_y(y4_reg), // Current Feature 
        .curr_c(c1_4)  // Current Accumaltion
    );
    PE u_c1_x5_y5(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c1_4), // Previous Accumaltion
        .curr_x(x5), // Current Filter weight
        .curr_y(y5_reg), // Current Feature 
        .curr_c(c1_5)  // Current Accumaltion
    );
    Accumalte u_c1_out(
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .i_value(c1_5), 
        .o_acc(c1)
    );
// C2
    sum_t c2_1,c2_2,c2_3,c2_4,c2_5;
    PE u_c2_x1_y2(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(16'b0), // Previous Accumaltion
        .curr_x(x1_reg), // Current Filter weight
        .curr_y(y2_reg), // Current Feature 
        .curr_c(c2_1)  // Current Accumaltion
    );
    PE u_c2_x2_y3(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c2_1), // Previous Accumaltion
        .curr_x(x2_reg), // Current Filter weight
        .curr_y(y3_reg), // Current Feature 
        .curr_c(c2_2)  // Current Accumaltion
    );  
    PE u_c2_x3_y4(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c2_2), // Previous Accumaltion
        .curr_x(x3_reg), // Current Filter weight
        .curr_y(y4_reg), // Current Feature 
        .curr_c(c2_3)  // Current Accumaltion
    );
    PE u_c2_x4_y5(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c2_3), // Previous Accumaltion
        .curr_x(x4_reg), // Current Filter weight
        .curr_y(y5_reg), // Current Feature 
        .curr_c(c2_4)  // Current Accumaltion
    );
    PE u_c2_x3_y6(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c2_4), // Previous Accumaltion
        .curr_x(x5_reg), // Current Filter weight
        .curr_y(y6_reg), // Current Feature 
        .curr_c(c2_5)  // Current Accumaltion
    );
    Accumalte u_c2_out(
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .i_value(c2_5), 
        .o_acc(c2)
    );
// C3 
    sum_t c3_1,c3_2,c3_3,c3_4,c3_5;
    PE u_c3_x1_y1(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(16'b0), // Previous Accumaltion
        .curr_x(x1), // Current Filter weight
        .curr_y(y1), // Current Feature 
        .curr_c(c3_1)  // Current Accumaltion
    );
    PE u_c3_x2_y2(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c3_1), // Previous Accumaltion
        .curr_x(x2), // Current Filter weight
        .curr_y(y2), // Current Feature 
        .curr_c(c3_2)  // Current Accumaltion
    );  
    PE u_c3_x3_y3(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c3_2), // Previous Accumaltion
        .curr_x(x3), // Current Filter weight
        .curr_y(y3), // Current Feature 
        .curr_c(c3_3)  // Current Accumaltion
    );
    PE u_c3_x4_y4(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c3_3), // Previous Accumaltion
        .curr_x(x4), // Current Filter weight
        .curr_y(y4), // Current Feature 
        .curr_c(c3_4)  // Current Accumaltion
    );
    PE u_c3_x5_y5(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c3_4), // Previous Accumaltion
        .curr_x(x5), // Current Filter weight
        .curr_y(y5), // Current Feature 
        .curr_c(c3_5)  // Current Accumaltion
    );
    Accumalte u_c3_out(
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .i_value(c3_5), 
        .o_acc(c3)
    );    
// C4
    sum_t c4_1,c4_2,c4_3,c4_4,c4_5;
    PE u_c4_x1_y2(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(16'b0), // Previous Accumaltion
        .curr_x(x1_reg), // Current Filter weight
        .curr_y(y2), // Current Feature 
        .curr_c(c4_1)  // Current Accumaltion
    );
    PE u_c4_x2_y3(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c4_1), // Previous Accumaltion
        .curr_x(x2_reg), // Current Filter weight
        .curr_y(y3), // Current Feature 
        .curr_c(c4_2)  // Current Accumaltion
    );  
    PE u_c4_x3_y4(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c4_2), // Previous Accumaltion
        .curr_x(x3_reg), // Current Filter weight
        .curr_y(y4), // Current Feature 
        .curr_c(c4_3)  // Current Accumaltion
    );
    PE u_c4_x4_y5(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c4_3), // Previous Accumaltion
        .curr_x(x4_reg), // Current Filter weight
        .curr_y(y5), // Current Feature 
        .curr_c(c4_4)  // Current Accumaltion
    );
    PE u_c4_x3_y6(
        .clk(clk),
        .rst(rst),
        .clear(clear),  // Clear signal 
        .prev_c(c4_4), // Previous Accumaltion
        .curr_x(x5_reg), // Current Filter weight
        .curr_y(y6), // Current Feature 
        .curr_c(c4_5)  // Current Accumaltion
    );
    Accumalte u_c4_out(
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .i_value(c4_5), 
        .o_acc(c4)
    );    
endmodule