module RAM #(
    parameter int MEM_SIZE = 512,
    parameter int DATA_WIDTH = 16,
    parameter FILE_NAME = "random_bytes.mem" // Removed "string" keyword here
) (
    // Input Write Port
    input  logic                        in_clk,
    input  logic [$clog2(MEM_SIZE)-1:0] write_addr,
    input  logic [DATA_WIDTH-1:0]       data_in,
    input  logic                        write_enable,
    input  logic 				    	in_done,
    // Output Read Port
    input  logic                        out_clk,
    input  logic [$clog2(MEM_SIZE)-1:0] read_addr,
    output logic [DATA_WIDTH-1:0]       data_out,
    output logic 				    	out_done
);
    
    (* ramstyle = "M10K" *) logic [DATA_WIDTH-1:0] M10k_mem [0:MEM_SIZE-1];

    initial begin
        // Quartus prefers the parameter to be passed without strict string typing
        // or defined as a literal.
        $readmemh(FILE_NAME, M10k_mem);
    end 

    always_ff @(posedge in_clk) begin
        if (write_enable) begin 
            M10k_mem[write_addr] <= data_in;
        end
    end
	 always_ff @(posedge out_clk) begin
			data_out <= M10k_mem[read_addr];
	 end 
	 
	 logic [1:0] reg_2ff_sync;
	 always @(posedge out_clk)begin
		reg_2ff_sync[0] <= in_done;
		reg_2ff_sync[1] <= reg_2ff_sync[0];
	 end 
	 assign out_done = reg_2ff_sync[1];  
endmodule