`timescale 1ns / 1ps
module cash_top_tb ();

reg clk, reset_neg, write_en, read_en;      
reg [31:0] address, write_data;

wire stall;
wire [31:0] read_data;

top_cash dut (clk, reset_neg, address, write_data, write_en, read_en, stall, read_data);
always begin      //clk period 20 ns
	#10;
	clk=~clk;
end


 initial begin
	//testing reset
	clk=0;
	reset_neg=0;
	address= 32'b0010000000;                          //address 128
	write_data= 1;
	write_en=1;
	read_en=0;

//wait 1 clk cycle and test write miss
#20;
reset_neg=1;
//wait 5 cycles: 1 for idle state 4 for memory access
#100;                            
//wait an extra cycle to memic the time the new unstructipn will come in
//check reading the same location --> read miss  

//to get new ins 
#10;

//write another location

address= 32'b0010000001;                         //address 129
write_data= 2;
//to change state
#10;

#100;


#10;         //to get a new instruction
// put new inst
address= 32'b0010000010;                              //address 130
write_data= 3;
#10;         //wait 10 to change state

#100;



#10;
address= 32'b0010000011;                               //address 131
write_data= 4;
#10;
#100;


//wait 10 to fetch a new instruction
#10;
//testing read miss (nothing in cash yet)
address= 32'b0010000000;
write_en=0;
read_en=1;
//wait for neg edeg for controller to change to change state (go to read)
#10;
#100;              //for main mem access


#10; //testing read hit ------------> the whole block was transmitted
address= 32'b0010000001;

//another read hit
#20;
address= 32'b0010000010;
#10;


//testing read hit
#10;
address= 32'b0010000011;

#20; //to fetch a new inst
//test write hit in
address=32'b0010000010;
write_en=1;
read_en=0;
write_data=15;
#10;
#100;


//read that last location again --> read hit and make sure it's the updated data 15
#10;
//testing read miss (nothing in cash yet)
write_en=0;
read_en=1;
//wait for neg edeg for controller to change to change state (go to read)
#20;


$stop;
	end 
	endmodule