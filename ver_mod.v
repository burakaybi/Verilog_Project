`timescale 1ns / 1ps

module atm 

(input clk,
 input rst,
 input BTN3, BTN2, BTN1,
 input [3:0] SW,
 output reg [7:0] LED,                                     // LED[7] is the left most-LED
 output reg [6:0] digit4, digit3, digit2, digit1  // digit4 is the left-most SSD
 );
  
	reg [3:0] password =4'b0000;
   reg [15:0] balance = 16'b0000000000000000;
	reg [7:0] current_state;
	reg [7:0] next_state;	
	
	parameter [7:0] IDLE    = 8'b0000;		// S
	parameter [7:0] PE_3    = 8'b0001;		// T
	parameter [7:0] PE_2    = 8'b0010;		// A
	parameter [7:0] PE_1    = 8'b0011;		// T
	parameter [7:0] LOCK    = 8'b0100;		// E
	parameter [7:0] ATM     = 8'b0101;		// S 
	parameter [7:0] MONEY   = 8'b0110;		
	parameter [7:0] WARNING = 8'b0111;		
	parameter [7:0] PC_3    = 8'b1000;		
	parameter [7:0] PC_2    = 8'b1001;		
	parameter [7:0] PC_1    = 8'b1010;		
	parameter [7:0] P_NEW   = 8'b1011;		
	
	
	parameter [7:0] LR     = 8'b00000000;
	parameter [7:0] L0     = 8'b00000001;

	parameter [7:0] L7     = 8'b10000000;
	parameter [7:0] L6_7   = 8'b11000000;
	parameter [7:0] L5_6_7 = 8'b11100000;
	
	parameter [7:0] LA     = 8'b11111111;
	
	parameter [7:0] L4     = 8'b00010000;
	parameter [7:0] L3     = 8'b00001000;
	
	parameter [7:0] L2     = 8'b00000100;
	parameter [7:0] L1_2   = 8'b00000110;
	parameter [7:0] L0_1_2 = 8'b00000111;
	parameter [7:0] L1     = 8'b00000010;
			
	integer counter1 = 0;
	integer counter2 = 0;
	
	
	// sequential part - state transitions
	always @ (posedge clk or posedge rst)
	begin
		if(rst) current_state <= IDLE;
		else    current_state <= next_state;
	end

	// combinational part - next state definitions
	always @ (*)
	begin
		case(current_state)
			IDLE:
			begin
				if  (BTN3) next_state = PE_3;
				else       next_state = IDLE;
			end
			
			PE_3:
			begin
				if      (BTN1)                       next_state = IDLE;
				else if ((SW == password) && (BTN3)) next_state = ATM;
				else if ((SW != password) && (BTN3)) next_state = PE_2;
				else                                 next_state = PE_3;
			end
			
			PE_2:
			begin
				if      ((SW==password) && (BTN3)) next_state=ATM;
				else if ((SW!=password) && (BTN3)) next_state=PE_1;
				else if (BTN1)                     next_state = IDLE;
				else                               next_state=PE_2;
			end
			
			PE_1:
			begin
				if      (SW==password && (BTN3)) next_state=ATM;
				else if (SW!=password && (BTN3))	next_state=LOCK;
				else if    (BTN1)                next_state = IDLE;     
				else                             next_state= PE_1;
			end
			
			ATM:
			begin
				if      (BTN1) next_state=IDLE;
				else if (BTN2) next_state=PC_3;
				else if (BTN3)	next_state=MONEY;
				else           next_state = ATM;
			end
			
			LOCK:
			begin
				if   (counter1 == 100) next_state = IDLE;
				else                   next_state = LOCK;
			end
			
			PC_3:
			begin
				if      (BTN1)                   next_state=ATM;
				else if (SW!=password && (BTN3)) next_state=PC_2;
				else if (SW==password && (BTN3)) next_state=P_NEW;
				else                             next_state=PC_3;
			end
			
			PC_2:
			begin 
				if      (BTN1)                   next_state=ATM;
				else if (SW!=password && (BTN3)) next_state=PC_1;	
				else if (SW==password && (BTN3)) next_state=P_NEW;
				else                             next_state=PC_2;	
			end
			
			PC_1:
			begin 
				if      (BTN1)                   next_state=ATM;
				else if (SW!=password && (BTN3)) next_state=LOCK;	
				else if (SW==password && (BTN3)) next_state=P_NEW;
				else									   next_state=PC_1;	
			end
			
			P_NEW:
			begin
				if   (BTN3) next_state = ATM;
				else        next_state = P_NEW;	
			end
			
			MONEY:
			begin
				if      (BTN1)         next_state = ATM;
				else if (BTN2)
				begin
					if   (SW > balance) next_state = WARNING;
					else                next_state = MONEY;
				end
				else                   next_state = MONEY;            
			end
			
			WARNING:
			begin
				if   (counter2 == 50) next_state = MONEY;
				else                 next_state = WARNING;
			end
			
			default:
				next_state = IDLE;
				
		endcase			
	end		
	
	// sequential part - control registers
	always @ (posedge clk or posedge rst)
	begin
	
	if(rst)
		begin
			balance <= 0;
			password <= 0;
		end
		else
		begin
	
		case(current_state)
	
		MONEY:
			begin
			   if      (BTN2)
				begin
					if   (SW <= balance) balance <= balance - SW;
					else                 balance <= balance;
				end
				else if (BTN3)          balance <= balance + SW;
				else                    balance <= balance;
				
			end
		
		P_NEW:
			begin
				if   (BTN3) password <= SW;
				else        password <= password;   
			end
	
		endcase
		end
	end 	

// sequential part - outputs
	always @ (posedge clk or posedge rst)
	begin
	if(rst) begin
		LED <= LR;
		digit4 <= 7'b1111111;
		digit3 <= 7'b1111111;
		digit2 <= 7'b1111111;
		digit1 <= 7'b1111111;
	end
	else
	begin
			if      (current_state == IDLE)    begin
				LED <= L0;
				digit4 <= 7'b0110001;
				digit3 <= 7'b0001000;
				digit2 <= 7'b0111001;
				digit1 <= 7'b1000010;
			end
			else if (current_state == PE_3)    begin
				LED <= L7;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110000;
				digit2 <= 7'b1111110;
				digit1 <= 7'b0000110;
			end
			else if (current_state == PE_2)   begin
				LED <= L6_7;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110000;
				digit2 <= 7'b1111110;
				digit1 <= 7'b0010010;
			end
			else if (current_state == PE_1)   begin
				LED <= L5_6_7;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110000;
				digit2 <= 7'b1111110;
				digit1 <= 7'b1001111;
			end
			else if (current_state == LOCK)  begin
				LED <= LA;
				digit4 <= 7'b0111000;
				digit3 <= 7'b0001000;
				digit2 <= 7'b1001111;
				digit1 <= 7'b1110001;
			end
			else if (current_state == ATM)    begin
				LED <= L4;
				digit4 <= 7'b0000001;
				digit3 <= 7'b0011000;
				digit2 <= 7'b0110000;
				digit1 <= 7'b0001001;
			end
			else if (current_state == PC_3)    begin
				LED <= L2;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110001;
				digit2 <= 7'b1111110;
				digit1 <= 7'b0000110;
			end
			else if (current_state == PC_2)    begin
				LED <= L1_2;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110001;
				digit2 <= 7'b1111110;
				digit1 <= 7'b0010010;
			end
			else if (current_state == PC_1)   begin
				LED <= L0_1_2;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110001;
				digit2 <= 7'b1111110;
				digit1 <= 7'b1001111;
			end
			else if (current_state == P_NEW)  begin
				LED <= L1;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0001000;
				digit2 <= 7'b0100100;
				digit1 <= 7'b0100100;
			end
			else if (current_state == MONEY)  begin
				LED <= L3;
				
				if(balance[3:0]==4'd0)
			digit1<=7'b0000001;
		else if(balance[3:0]==4'd1)
			digit1<=7'b1001111;
		else if(balance[3:0]==4'd2)
			digit1<=7'b0010010;	
		else if(balance[3:0]==4'd3)
			digit1<=7'b0000110;
		else if(balance[3:0]==4'd4)
			digit1<=7'b1001100;
		else if(balance[3:0]==4'd5)
			digit1<=7'b0100100;
		else if(balance[3:0]==4'd6)
			digit1<=7'b0100000;
		else if(balance[3:0]==4'd7)
			digit1<=7'b0001111;
		else if(balance[3:0]==4'd8)
			digit1<=7'b0000000;
		else if(balance[3:0]==4'd9)
			digit1<=7'b0000100;
		else if(balance[3:0]==4'd10)
			digit1<=7'b0001000;
		else if(balance[3:0]==4'd11)
			digit1<=7'b0000000;
		else if(balance[3:0]==4'd12)
			digit1<=7'b0110001;
		else if(balance[3:0]==4'd13)
			digit1<=7'b0000001;
		else if(balance[3:0]==4'd14)
			digit1<=7'b0110000;
		else if(balance[3:0]==4'd15)
			digit1<=7'b0111000;	
			
			//
		
		if(balance[7:4]==4'd0)
			digit2<=7'b0000001;
		else if(balance[7:4]==4'd1)
			digit2<=7'b1001111;
		else if(balance[7:4]==4'd2)
			digit2<=7'b0010010;	
		else if(balance[7:4]==4'd3)
			digit2<=7'b0000110;
		else if(balance[7:4]==4'd4)
			digit2<=7'b1001100;
		else if(balance[7:4]==4'd5)
			digit2<=7'b0100100;
		else if(balance[7:4]==4'd6)
			digit2<=7'b0100000;
		else if(balance[7:4]==4'd7)
			digit2<=7'b0001111;
		else if(balance[7:4]==4'd8)
			digit2<=7'b0000000;
		else if(balance[7:4]==4'd9)
			digit2<=7'b0000100;
		else if(balance[7:4]==4'd10)
			digit2<=7'b0001000;
		else if(balance[7:4]==4'd11)
			digit2<=7'b0000000;
		else if(balance[7:4]==4'd12)
			digit2<=7'b0110001;
		else if(balance[7:4]==4'd13)
			digit2<=7'b0000001;
		else if(balance[7:4]==4'd14)
			digit2<=7'b0110000;
		else if(balance[7:4]==4'd15)
			digit2<=7'b0111000;
			
		//
		
			if(balance[11:8]==4'd0)
			digit3<=7'b0000001;
		else if(balance[11:8]==4'd1)
			digit3<=7'b1001111;
		else if(balance[11:8]==4'd2)
			digit3<=7'b0010010;	
		else if(balance[11:8]==4'd3)
			digit3<=7'b0000110;
		else if(balance[11:8]==4'd4)
			digit3<=7'b1001100;
		else if(balance[11:8]==4'd5)
			digit3<=7'b0100100;
		else if(balance[11:8]==4'd6)
			digit3<=7'b0100000;
		else if(balance[11:8]==4'd7)
			digit3<=7'b0001111;
		else if(balance[11:8]==4'd8)
			digit3<=7'b0000000;
		else if(balance[11:8]==4'd9)
			digit3<=7'b0000100;
		else if(balance[11:8]==4'd10)
			digit3<=7'b0001000;
		else if(balance[11:8]==4'd11)
			digit3<=7'b0000000;
		else if(balance[11:8]==4'd12)
			digit3<=7'b0110001;
		else if(balance[11:8]==4'd13)
			digit3<=7'b0000001;
		else if(balance[11:8]==4'd14)
			digit3<=7'b0110000;
		else if(balance[11:8]==4'd15)
			digit3<=7'b0111000;
			
//		
			if(balance[15:12]==4'd0)
			digit4<=7'b0000001;
		else if(balance[15:12]==4'd1)
			digit4<=7'b1001111;
		else if(balance[15:12]==4'd2)
			digit4<=7'b0010010;	
		else if(balance[15:12]==4'd3)
			digit4<=7'b0000110;
		else if(balance[15:12]==4'd4)
			digit4<=7'b1001100;
		else if(balance[15:12]==4'd5)
			digit4<=7'b0100100;
		else if(balance[15:12]==4'd6)
			digit4<=7'b0100000;
		else if(balance[15:12]==4'd7)
			digit4<=7'b0001111;
		else if(balance[15:12]==4'd8)
			digit4<=7'b0000000;
		else if(balance[15:12]==4'd9)
			digit4<=7'b0000100;
		else if(balance[15:12]==4'd10)
			digit4<=7'b0001000;
		else if(balance[15:12]==4'd11)
			digit4<=7'b0000000;
		else if(balance[15:12]==4'd12)
			digit4<=7'b0110001;
		else if(balance[15:12]==4'd13)
			digit4<=7'b0000001;
		else if(balance[15:12]==4'd14)
			digit4<=7'b0110000;
		else if(balance[15:12]==4'd15)
			digit4<=7'b0111000;
			
		end
				
				else if (current_state == WARNING) begin
				LED <= LA;
				digit4 <= 7'b1111110;
				digit3 <= 7'b1101010;
				digit2 <= 7'b0001000;
				digit1 <= 7'b1111110;
			end
			else                begin             
				LED <= LR;
				digit4 <= 7'b1111111;
				digit3 <= 7'b1111111;
				digit2 <= 7'b1111111;
				digit1 <= 7'b1111111;
			end
		end
		
		
	end
	
	always @ (posedge clk or posedge rst)

		if(rst)
		begin
			counter1 <= 0;
			counter2 <= 0;
		end
		else
		case(current_state)

		LOCK:
			begin
				if   (counter1 != 100) counter1 <= counter1 + 1'd1;
				else                   counter1 <= 0;
			end
	
		WARNING:
			begin
				if   (counter2 != 50) counter2 <= counter2 + 1'd1;
				else                  counter2 <= 0;
			end
	
		endcase
		/*begin
			if (counter1 == 100) next_state <= ATM;
			else if (counter2 == 50) next_state <= MONEY;
			else                next_state <= current_state;
			//counter2 <= counter2 + 1;                //counter1 <= counter1 + 1;
		end*/

	
	/*always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			counter2 <= 0;
		end
		else
		//begin
			if (counter2 == 50) next_state <= MONEY;
			else                //counter2 <= counter2 + 1;
		//end
	end*/
endmodule