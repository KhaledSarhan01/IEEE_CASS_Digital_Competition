import LeNet5_pkg::*;
module PE #(parameter WIDTH = 16, parameter FRAC_BITs = 1)(
    input clk,
    input rst, /////??????
    input Clr, 
    input Selp,
    input Seln, 
    input  signed [2*WIDTH:0] Prev,     
    input  signed [WIDTH-1:0] In, 
    input  signed [WIDTH-1:0] W, 
    output reg signed [WIDTH-1:0] W_out, 
    output reg signed [WIDTH-1:0] In_out, 
    output reg signed [2*WIDTH:0] result
); 

// We need to know the range of values of weights  =====

// 0_00000_0000_0000_00
// sign: 1 bit, integer: 5 bits, fraction: 10 bits 

// I need to check the boundaries 
    logic signed [2*WIDTH-1:0] mult_reg;
    logic signed [2*WIDTH-1:0] mult;
    logic signed [2*WIDTH:0]   add; 
    logic signed [2*WIDTH:0]   MUX_p, MUX_n, Q_out;

    assign mult   = In*W; 
    assign MUX_p  = (Selp)? Prev : 0; 
    assign MUX_n  = (Seln)? Q_out: 0; 
    assign result = MUX_n; 

    always @(posedge clk) begin
        if(rst) begin
            mult_reg <= 0; 
            W_out    <= 0;  
            In_out   <= 0;  
            add      <= 0;
        end else begin 
            W_out    <= W;  
            In_out   <= In; 
            mult_reg <= mult >>> FRAC_BITs; 
            add      <= mult_reg + MUX_p + Q_out;
        end         
    end

    always @(posedge clk) begin ///??????? does clr have higher priority over CE???
        if(Clr) begin
            Q_out <=  {WIDTH{1'b0}};  
        end else if(rst) begin
            Q_out <=  {WIDTH{1'b0}};  
        end else begin
            Q_out <= add;  
        end
    end

endmodule 

