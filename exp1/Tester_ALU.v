`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:37:32 11/12/2025
// Design Name:   ALU
// Module Name:   D:/CPU/Tester_ALU.v
// Project Name:  CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Tester_ALU;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg [2:0] ALUctr;

	// Outputs
	wire [31:0] Result;
	wire Overflow;
	wire Z;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.A(A), 
		.B(B), 
		.ALUctr(ALUctr), 
		.Result(Result), 
		.Overflow(Overflow), 
		.Z(Z)
	);

	initial begin
		A = 0;
		B = 0;
		ALUctr = 0;
		#100;

		// addu
		ALUctr = 3'b000;
		A = 1;
		B = 1;
		#100;

		A = 114514;
		B = 1919810;
		#100;

		A = 32'h00000000;
		B = 32'h00000000;
		#100;
		
		A = 32'hffffffff;
		B = 32'hffffffff;
		#100;


		// Overflow test
		A = 32'h7fffffff;
		B = 32'h7fffffff;
		#100;

		// Zero test
		A = 1;
		B = {32{1}};
		#100;

		// add
		ALUctr = 3'b001;
		A = 1;
		B = 1;
		#100;

		A = 114514;
		B = 1919810;
		#100;

		// Overflow test
		A = 32'h7fffffff;
		B = 32'h7fffffff;
		#100;

		// Zero test
		A = 1;
		B = {32{1}};
		#100;

		// or
		ALUctr = 3'b010;
		A = 32'b10100110;
		B = 32'b10011100;
		#100;

		A = 32'h0;
		B = 32'hffffffff;
		#100;

		// subu
		ALUctr = 3'b100;
		A = 10;
		B = 5;
		#100;

		A = 0;
		B = 1;
		#100;

		A = 100;
		B = 100;
		#100;

		// sub
		ALUctr = 3'b101;
		A = 10;
		B = 5;
		#100;

		A = 10;
		B = 32'hffffffff;
		#100;

		A = 32'hffffffff;
		B = 1;
		#100;

		A = 32'h7fffffff;
		B = 32'hffffffff;
		#100;

		A = 32'h80000000;
		B = 32'h00000001;
		#100;

		// sltu
		ALUctr = 3'b110;
		A = 5;
		B = 10;
		#100;

		A = 10;
		B = 5;
		#100;

		A = 32'hffffffff;
		B = 32'h00000001;
		#100;

		A = 100;
		B = 100;
		#100;

		// slt
		ALUctr = 3'b111;
		A = 5;
		B = 10;
		#100;

		A = 10;
		B = 5;
		#100;

		A = 32'hffffffff;
		B = 0;
		#100;

		A = 0;
		B = 32'hffffffff;
		#100;

		A = 32'h80000000;
		B = 32'h7fffffff;
		#100;

		A = 100;
		B = 100;
		#100;

	end
      
endmodule