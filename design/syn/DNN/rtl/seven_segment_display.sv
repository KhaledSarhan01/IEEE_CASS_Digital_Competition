////////////////////////////////////////////////
///// Project   : seven_segment_display             
///// Created on: 2025-11-18                   
////////////////////////////////////////////////

module seven_segment_display (
// Signals    
    input  logic [3:0] BIN
	,output logic [6:0] HEX
);

// Combinational logic 
	logic [6:0] HEX_bar;
	always_comb begin 
		case (BIN)
			4'h0: HEX_bar = 7'b0111111; //0
			4'h1: HEX_bar = 7'b0000110; //1
			4'h2: HEX_bar = 7'b1011011; 
			4'h3: HEX_bar = 7'b1001111; 
			
			4'h4: HEX_bar = 7'b1100110; 
			4'h5: HEX_bar = 7'b1101101;
			4'h6: HEX_bar = 7'b1111101; 
			4'h7: HEX_bar = 7'b0000111;

			4'h8: HEX_bar = 7'b1111111; 
			4'h9: HEX_bar = 7'b1101111;
			4'hA: HEX_bar = 7'b1011111; 
			4'hB: HEX_bar = 7'b1111100;

			4'hC: HEX_bar = 7'b0111001; 
			4'hD: HEX_bar = 7'b1011110;
			4'hE: HEX_bar = 7'b1111011; 
			4'hF: HEX_bar = 7'b1110001;
			default: HEX_bar = 7'b0000000;
		endcase
	end
	assign HEX = ~HEX_bar;
endmodule
