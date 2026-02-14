`timescale 1ns/1ps

module tb_PE_matrix;

    // Parameters
    parameter DATA_WIDTH = 16;
    parameter A_SIZE = 9; // A_matrix is 9x9
    parameter B_SIZE = 5; // B_matrix is 5x5

    // Testbench signals
    reg clk;
    reg rst;
    reg Clr;
    reg Selp;
    reg Seln;

    reg signed [A_SIZE-1:0][DATA_WIDTH-1:0] A_matrix;
    reg signed [B_SIZE-1:0][DATA_WIDTH-1:0] B_matrix;

    wire signed [B_SIZE-1:0][2*DATA_WIDTH-1:0] C_matrix;

    // Instantiate PE_matrix
    PE_matrix #(
        .DATA_WIDTH(DATA_WIDTH),
        .A_SIZE(A_SIZE),
        .B_SIZE(B_SIZE)
    ) uut (
        .clk(clk),
        .rst(rst),
        .Clr(Clr),
        .Selp(Selp),
        .Seln(Seln),
        .A_matrix(A_matrix),
        .B_matrix(B_matrix),
        .C_matrix(C_matrix)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        Clr = 1;
        Selp = 1;
        Seln = 1;
        A_matrix = '{default:0};
        B_matrix = '{default:0};

        // Apply reset
        #10;
        rst = 0;
        Clr = 0;

        // Apply test vectors
        A_matrix = '{16'd1, 16'd2, 16'd3, 16'd4, 16'd5, 16'd6, 16'd7, 16'd8, 16'd9};
        B_matrix = '{16'd1, 16'd1, 16'd1, 16'd1, 16'd1};

        #10; // wait for pipeline to propagate
        A_matrix = '{16'd1, 16'd2, 16'd3, 16'd4, 16'd5, 16'd6, 16'd7, 16'd8, 16'd9};
        B_matrix = '{16'd1, 16'd1, 16'd1, 16'd1, 16'd1};

        #10; // wait for pipeline to propagate
        A_matrix = '{16'd1, 16'd2, 16'd3, 16'd4, 16'd5, 16'd6, 16'd7, 16'd8, 16'd9};
        B_matrix = '{16'd1, 16'd1, 16'd1, 16'd1, 16'd1};

        #10; // wait for pipeline to propagate
        A_matrix = '{16'd1, 16'd2, 16'd3, 16'd4, 16'd5, 16'd6, 16'd7, 16'd8, 16'd9};
        B_matrix = '{16'd1, 16'd1, 16'd1, 16'd1, 16'd1};

        #10; // wait for pipeline to propagate
        A_matrix = '{16'd1, 16'd2, 16'd3, 16'd4, 16'd5, 16'd6, 16'd7, 16'd8, 16'd9};
        B_matrix = '{16'd1, 16'd1, 16'd1, 16'd1, 16'd1};
        #10; // wait for pipeline to propagate

        $display("C_matrix outputs:");
        for (int i = 0; i < B_SIZE; i++) begin
            $display("C_matrix[%0d] = %0d", i, C_matrix[i]);
        end

        // // Apply second test vectors
        // A_matrix = '{16'd9,16'd8,16'd7,16'd6,16'd5,16'd4,16'd3,16'd2,16'd1};
        // B_matrix = '{16'd5,16'd4,16'd3,16'd2,16'd1};

        #20;

        $display("C_matrix outputs after second input:");
        for (int i = 0; i < B_SIZE; i++) begin
            $display("C_matrix[%0d] = %0d", i, C_matrix[i]);
        end

        // Finish simulation
        $stop;
    end

endmodule
