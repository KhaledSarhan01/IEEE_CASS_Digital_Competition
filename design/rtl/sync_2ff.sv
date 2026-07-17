`timescale 1ns / 1ps

module sync_2ff (
    input  wire clk,       // Destination clock (CLOCK_50)
    input  wire rst,       // Active high reset
    input  wire async_in,  // Asynchronous input from HPS Avalon Bridge
    output wire sync_out   // Synchronized output for your state machines
);

    // Quartus attributes to prevent shift-register optimization
    (* preserve *) reg ff1;
    (* preserve *) reg ff2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ff1 <= 1'b0;
            ff2 <= 1'b0;
        end else begin
            // Shift the asynchronous signal through the two registers
            ff1 <= async_in;
            ff2 <= ff1;
        end
    end

    assign sync_out = ff2;

endmodule