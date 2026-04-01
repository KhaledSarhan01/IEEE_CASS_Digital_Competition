import LeNet5_pkg::*;
localparam ADDR_WIDTH = $clog2(FEATURE_MAP_2_SIZE);
module Feature_Map_2 (
    // Input Side
    input logic                       in_clk,
    input logic [ADDR_WIDTH-1:0]      write_addr,
    input logic [DNN_BUS_WIDTH-1:0]   data_in,
    input logic                       write_enable,
    input logic                       in_done,
    // Output Side
    input  logic                      out_clk, 
    input  logic [ADDR_WIDTH-1:0]     read_addr, 
    output logic [DNN_BUS_WIDTH-1:0]  data_out,
    output logic                      out_done
);
// // ROM
//     ROM #(
//         .MEM_SIZE(FEATURE_MAP_2_SIZE), 
//         .DATA_WIDTH(DNN_BUS_WIDTH),
//         .FILE_NAME(FLATTEN_LAYER_PARAMETERS)
//     ) u_flatten_layer (
//         .clk(out_clk),
//         .addr(read_addr),
//         .data_out(data_out)
//     );

// Output RAM
    RAM #(
        .MEM_SIZE(FEATURE_MAP_2_SIZE),
        .DATA_WIDTH(DNN_BUS_WIDTH)
    )u_feature_map_2_RAM(
        // Input Write Port
        .in_clk      (in_clk),
        .write_addr  (write_addr),
        .data_in     (data_in),
        .write_enable(write_enable),
        // Output Read Port
        .out_clk    (out_clk),
        .read_addr  (read_addr),
        .data_out   (data_out)
    );
// 2 bit synchronizer
    logic [1:0] reg_2ff_sync;
    always @(posedge out_clk)begin
        reg_2ff_sync[0] <= in_done;
        reg_2ff_sync[1] <= reg_2ff_sync[0];
    end 
	assign out_done = reg_2ff_sync[1];
endmodule