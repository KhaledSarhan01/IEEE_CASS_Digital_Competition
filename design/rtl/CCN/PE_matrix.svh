module PE_matrix #(parameter DATA_WIDTH = 16, A_SIZE = 9, B_SIZE = 5) (
    input clk,
    input rst, 
    input Clr, 
    input Selp,
    input Seln,        
    input signed [A_SIZE-1:0][DATA_WIDTH-1:0] A_matrix,
    input signed [B_SIZE-1:0][DATA_WIDTH-1:0] B_matrix,
    output reg signed [B_SIZE-1:0][2*DATA_WIDTH-1:0] C_matrix   
);

    // I am assuming that the matrix are of the same size for now and they are squares????????
    wire signed [B_SIZE-1:0][B_SIZE-1:0][2*DATA_WIDTH:0] PE_out; 
    wire signed [B_SIZE-1:0][B_SIZE-1:0][DATA_WIDTH-1:0] W_out;     
    wire signed [B_SIZE-1:0][B_SIZE-1:0][DATA_WIDTH-1:0] In_out; 

    // DFF_sys FF_a1(.D(A_matrix[1]), .clk(clk), .rst_n(rst_n), .Q(A_matrix_delayed_1));

    wire signed [A_SIZE-1:0][DATA_WIDTH-1:0] matrix_a_in;
    wire signed [B_SIZE-1:0][DATA_WIDTH-1:0] matrix_b_in;

    // wire signed [DATA_WIDTH-1:0] a_pipe [0:A_SIZE-1];
    // wire signed [DATA_WIDTH-1:0] b_pipe [0:B_SIZE-1];

    logic [DATA_WIDTH-1:0] matrix_a_pipe [A_SIZE-1:0][A_SIZE-1:0];
    logic [DATA_WIDTH-1:0] matrix_b_pipe [B_SIZE-1:0][B_SIZE-1:0];

    assign matrix_a_in[0] = A_matrix[0];
    assign matrix_b_in[0] = B_matrix[0];

    //-------------------------------------------

    genvar i, j, d, k;
        generate
        for (i = 1; i < A_SIZE; i++) begin
            for (d = 0; d < i; d++) begin
                // A pipeline
                DFF_CCN A_delay (
                    .clk(clk),
                    .rst(rst),
                    .D(d == 0 ? A_matrix[i] : matrix_a_pipe[i][d-1]),
                    .Q(matrix_a_pipe[i][d])
                );
                end
                
            assign matrix_a_in[i] = matrix_a_pipe[i][i-1];    
        end 
    endgenerate

    generate
        for (j = 1; j < B_SIZE; j++) begin
            for (k = 0; k < j; k++) begin
                // A pipeline
                DFF_CCN B_delay (
                    .clk(clk),
                    .rst(rst),
                    .D(k == 0 ? B_matrix[j] : matrix_b_pipe[j][k-1]),
                    .Q(matrix_b_pipe[j][k])
                );
            end
            assign matrix_b_in[j] = matrix_b_pipe[j][j-1];
        end
    endgenerate

    PE Unit0_0(.*, .rst(rst), .Selp(1'b1), .Seln(1'b1), .Prev(33'd0), .In(matrix_a_in[0]), .W(matrix_b_in[0]), .W_out(W_out[0][0]), .In_out(),          .result(PE_out[0][0]));     
    PE Unit0_1(.*,.rst(rst),  .Selp(1'b1), .Seln(1'b1), .Prev(33'd0), .In(matrix_a_in[1]), .W(W_out[0][0]), .W_out(W_out[0][1]), .In_out(In_out[0][1]), .result(PE_out[0][1])); 
    PE Unit0_2(.*,.rst(rst),  .Selp(1'b1), .Seln(1'b1), .Prev(33'd0), .In(matrix_a_in[2]), .W(W_out[0][1]), .W_out(W_out[0][2]), .In_out(In_out[0][2]), .result(PE_out[0][2])); 
    PE Unit0_3(.*,.rst(rst),  .Selp(1'b1), .Seln(1'b1), .Prev(33'd0), .In(matrix_a_in[3]), .W(W_out[0][2]), .W_out(W_out[0][3]), .In_out(In_out[0][3]), .result(PE_out[0][3]));
    PE Unit0_4(.*,.rst(rst),  .Selp(1'b1), .Seln(1'b1), .Prev(33'd0), .In(matrix_a_in[4]), .W(W_out[0][3]), .W_out(W_out[0][4]), .In_out(In_out[0][4]), .result(PE_out[0][4])); 
 
    PE Unit1_0(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[0][0]), .In(In_out[0][1]),   .W(matrix_b_in[1]), .W_out(W_out[1][0]), .In_out(),             .result(PE_out[1][0])); 
    PE Unit1_1(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[0][1]), .In(In_out[0][2]),   .W(W_out[1][0]),    .W_out(W_out[1][1]), .In_out(In_out[1][1]), .result(PE_out[1][1])); 
    PE Unit1_2(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[0][2]), .In(In_out[0][3]),   .W(W_out[1][1]),    .W_out(W_out[1][2]), .In_out(In_out[1][2]), .result(PE_out[1][2]));    
    PE Unit1_3(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[0][3]), .In(In_out[0][4]),   .W(W_out[1][2]),    .W_out(W_out[1][3]), .In_out(In_out[1][3]), .result(PE_out[1][3]));     
    PE Unit1_4(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[0][4]), .In(matrix_a_in[5]), .W(W_out[1][3]),    .W_out(W_out[1][4]), .In_out(In_out[1][4]), .result(PE_out[1][4])); 
 
    PE Unit2_0(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[1][0]), .In(In_out[1][1]),   .W(matrix_b_in[2]), .W_out(W_out[2][0]), .In_out(),             .result(PE_out[2][0])); 
    PE Unit2_1(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[1][1]), .In(In_out[1][2]),   .W(W_out[2][0]),    .W_out(W_out[2][1]), .In_out(In_out[2][1]), .result(PE_out[2][1])); 
    PE Unit2_2(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[1][2]), .In(In_out[1][3]),   .W(W_out[2][1]),    .W_out(W_out[2][2]), .In_out(In_out[2][2]), .result(PE_out[2][2])); 
    PE Unit2_3(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[1][3]), .In(In_out[1][4]),   .W(W_out[2][2]),    .W_out(W_out[2][3]), .In_out(In_out[2][3]), .result(PE_out[2][3])); 
    PE Unit2_4(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[1][4]), .In(matrix_a_in[6]), .W(W_out[2][3]),    .W_out(W_out[2][4]), .In_out(In_out[2][4]), .result(PE_out[2][4]));
 
    PE Unit3_0(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[2][0]), .In(In_out[2][1]),   .W(matrix_b_in[3]), .W_out(W_out[3][0]), .In_out(),             .result(PE_out[3][0])); 
    PE Unit3_1(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[2][1]), .In(In_out[2][2]),   .W(W_out[3][0]),    .W_out(W_out[3][1]), .In_out(In_out[3][1]), .result(PE_out[3][1])); 
    PE Unit3_2(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[2][2]), .In(In_out[2][3]),   .W(W_out[3][1]),    .W_out(W_out[3][2]), .In_out(In_out[3][2]), .result(PE_out[3][2])); 
    PE Unit3_3(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[2][3]), .In(In_out[2][4]),   .W(W_out[3][2]),    .W_out(W_out[3][3]), .In_out(In_out[3][3]), .result(PE_out[3][3])); 
    PE Unit3_4(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[2][4]), .In(matrix_a_in[7]), .W(W_out[3][3]),    .W_out(W_out[3][4]), .In_out(In_out[3][4]), .result(PE_out[3][4])); 
 
    PE Unit4_0(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[3][0]), .In(In_out[3][1]),   .W(matrix_b_in[4]), .W_out(W_out[4][0]), .In_out(),             .result(PE_out[4][0])); 
    PE Unit4_1(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[3][1]), .In(In_out[3][2]),   .W(W_out[4][0]),    .W_out(W_out[4][1]), .In_out(In_out[4][1]), .result(PE_out[4][1])); 
    PE Unit4_2(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[3][2]), .In(In_out[3][3]),   .W(W_out[4][1]),    .W_out(W_out[4][2]), .In_out(In_out[4][2]), .result(PE_out[4][2])); 
    PE Unit4_3(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[3][3]), .In(In_out[3][4]),   .W(W_out[4][2]),    .W_out(W_out[4][3]), .In_out(In_out[4][3]), .result(PE_out[4][3])); 
    PE Unit4_4(.*,.Clr(1'b0), .Selp(1'b1), .Seln(1'b1), .Prev(PE_out[3][4]), .In(matrix_a_in[8]), .W(W_out[4][3]),    .W_out(W_out[4][4]), .In_out(In_out[4][4]), .result(PE_out[4][4]));

    always @(*) begin 
        for(int i=0; i<B_SIZE; i++) 
            C_matrix[i] = PE_out[B_SIZE-1][i];

    end 


    // genvar r, c;
    // generate
    // for (r = 0; r < B_SIZE; r++) begin
    //     for (c = 0; c < B_SIZE; c++) begin
    //     PE U (
    //         .clk(clk),
    //         .rst(rst),
    //         .Clr(0),
    //         .Selp(1),
    //         .Seln(1),
    //         .Prev(r==0 ? 0 : PE_out[r-1][c]),
    //         .In(c==0 ? matrix_a_in[r] : In_out[r][c-1]),
    //         .W(c==0 ? matrix_b_in[r] : W_out[r][c-1]),
    //         .W_out(W_out[r][c]),
    //         .In_out(In_out[r][c]),
    //         .result(PE_out[r][c])
    //     );
    //     end
    // end
    // endgenerate

    endmodule