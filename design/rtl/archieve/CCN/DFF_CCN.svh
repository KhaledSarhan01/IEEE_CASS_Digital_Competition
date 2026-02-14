module DFF_CCN #(
    parameter WIDTH = 16
)(
    input  wire [WIDTH-1:0] D,
    input  wire             clk,
    input  wire             rst,
    output reg  [WIDTH-1:0] Q
);

always @(posedge clk) begin
    if (rst)
        Q <= {WIDTH{1'b0}};
    else
        Q <= D;
end

endmodule
