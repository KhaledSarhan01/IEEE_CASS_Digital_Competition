module RAM #(
    parameter int MEM_SIZE   = 1024,
    parameter int DATA_WIDTH = 8 
) (
    input  logic                        clk,
    input  logic [$clog2(MEM_SIZE)-1:0] read_addr,
    input  logic [$clog2(MEM_SIZE)-1:0] write_addr,
    input  logic [DATA_WIDTH-1:0]       data_in,
    input  logic                        write_enable,
    output logic [DATA_WIDTH-1:0]       data_out
);
    
    (* ramstyle = "M10K" *) logic [DATA_WIDTH-1:0] ram_mem [0:MEM_SIZE-1];

    always_ff @(posedge clk) begin
        if (write_enable) begin 
            ram_mem[write_addr] <= data_in;
        end
        data_out <= ram_mem[read_addr];
    end    
endmodule