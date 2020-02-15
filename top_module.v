`timescale 1ns / 1ps

module top_module (

 clk,
 rst,
 BTN3, BTN2, BTN1,
 SW,
 LED,  						// LED[7] is the left most-LED
	a, b, c, d, e, f, g,
	an0, an1, an2, an3
 );
  input clk;
 input rst;
 input BTN3, BTN2, BTN1;
 input [3:0] SW;
	output [7:0] LED; 						// LED[7] is the left most-LED
	output a, b, c, d, e, f, g;
	output an0, an1, an2, an3;
	wire clk_out;
	wire BTN3_db, BTN2_db, BTN1_db;
	wire [6:0] digit4, digit3, digit2, digit1;
	
	clk_divider clock (.clk_in(clk), .rst(rst), .divided_clk(clk_out));
	
	debouncer db_3 (.clk(clk_out), .rst(rst), .noisy_in(BTN3), .clean_out(BTN3_db));
	debouncer db_2 (.clk(clk_out), .rst(rst), .noisy_in(BTN2), .clean_out(BTN2_db));
	debouncer db_1 (.clk(clk_out), .rst(rst), .noisy_in(BTN1), .clean_out(BTN1_db));
	
	atm aaa (
	.clk(clk_out), .rst(rst),
	.BTN3(BTN3_db), .BTN2(BTN2_db), .BTN1(BTN1_db),
	.SW(SW), 
	.LED(LED),
	.digit4(digit4), .digit3(digit3), .digit2(digit2), .digit1(digit1) 
	);
	
	ssd display (.clk(clk), .reset(rst),
	.a0(digit1[6]), 
	.b0(digit1[5]),
	.c0(digit1[4]),
	.d0(digit1[3]),
	.e0(digit1[2]),
	.f0(digit1[1]),
	.g0(digit1[0]),

	.a1(digit2[6]), 
	.b1(digit2[5]),  
	.c1(digit2[4]),
	.d1(digit2[3]),
	.e1(digit2[2]),
	.f1(digit2[1]),
	.g1(digit2[0]),
	
	.a2(digit3[6]), 
	.b2(digit3[5]),  
	.c2(digit3[4]),
	.d2(digit3[3]),
	.e2(digit3[2]),
	.f2(digit3[1]),
	.g2(digit3[0]),
	
	.a3(digit4[6]), 
	.b3(digit4[5]),  
	.c3(digit4[4]),
	.d3(digit4[3]),
	.e3(digit4[2]),
	.f3(digit4[1]),
	.g3(digit4[0]),
	
	.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g),
	.an0(an0), .an1(an1), .an2(an2), .an3(an3)
	);
	

endmodule
