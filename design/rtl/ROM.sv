module ROM #(
    parameter int MEM_SIZE   = 1024,
    parameter int DATA_WIDTH = 8,
    parameter FILE_NAME      = "random_bytes.mem"
) (
    input  logic                     clk,
    input  logic [$clog2(MEM_SIZE)-1:0] addr,
    output logic [DATA_WIDTH-1:0]    data_out
);
    
    (* ramstyle = "M10K" *) logic [DATA_WIDTH-1:0] rom_mem [0:MEM_SIZE-1];

    initial begin
        $readmemh(FILE_NAME, rom_mem);
    end 

    always_ff @(posedge clk) begin
        // A ROM only needs the read logic
        data_out <= rom_mem[addr];
    end
endmodule