`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:37:33 11/19/2025
// Design Name:   CPU
// Module Name:   D:/monocyclic-processor/test_CPU.v
// Project Name:  monocyclic-processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_CPU;

	// Inputs
	reg Clk;
	reg Clrn;

	// Outputs
	wire [31:0] PC;
	wire [31:0] Inst;
	wire [31:0] R;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.Clk(Clk), 
		.Clrn(Clrn), 
		.PC(PC), 
		.Inst(Inst), 
		.R(R)
	);

	integer i;
	
	initial begin
		// Initialize Inputs
		Clk = 1;
		Clrn = 0;
		#5;
		Clk = 0;
		#5;
		Clrn = 1;
		#90;
		Clrn = 1;
		for(i = 0; i < 100000; i = i + 1) begin
			Clk = ~Clk;
			#10;
		end
	end
	
endmodule

