// Verilog test fixture created from schematic C:\.Xilinx\Projects\example\schmu.sch - Thu Oct 03 18:28:29 2019

`timescale 1ns / 1ps

module schmu_schmu_sch_tb();

// Inputs
   reg x;
   reg y;

// Output
   wire XLXN_9;

// Bidirs

// Instantiate the UUT
   schmu UUT (
		.x(x), 
		.y(y), 
		.XLXN_9(XLXN_9)
   );
// Initialize Inputs
       initial begin
		x = 0;
		y = 0;
		#10;
		y = 1;
		#10;
		x = 1;
		y = 0;
		#10;
		y = 1;
		#10;
		end
	
endmodule
