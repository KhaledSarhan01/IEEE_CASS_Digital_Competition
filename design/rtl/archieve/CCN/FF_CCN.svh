module FF_CCN #(parameter WIDTH = 16)(
    input clk,
    input rst,
    //input ce, 
    input [WIDTH-1:0] D,  
    input CLR, 
    output reg [WIDTH-1:0] Q
);  

    always @(posedge clk) begin ///??????? does clr have higher priority over CE???
        if(CLR) begin
            Q <=  {WIDTH{1'b0}};  
        end else if(rst) begin
            Q <=  {WIDTH{1'b0}};  
        end else begin
            Q <= D;  
        end
        
    end

endmodule