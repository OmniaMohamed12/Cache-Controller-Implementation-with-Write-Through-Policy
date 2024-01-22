module main_memory (clk, read_main, write_main, address, wdata, ready, data_block);

input clk, read_main, write_main;
input [9:0] address;
input [31:0] wdata;
output reg ready;
output [127:0] data_block;

reg [2:0] count =0;

reg [31:0] main [0:2**10-1]; 


always @ (negedge clk) begin
	if (read_main || write_main) 
		if (count!=4) begin         
			count<=count+1;
		ready<=0;
		end
		else begin
			count<=0;
			ready<=1;

		end 
	/*else                     //not read main or write main
		ready<=0;  */
	end



always @ (negedge clk) begin	
if (write_main) begin
	main[address] <= wdata;
end
/*else 
	ready<=0; */
end


//assign ready= (count==3)?1:0;

assign data_block [31:0] = main [{address [ 9:2], 2'b00}];
assign data_block [63:32] = main [{address [ 9:2], 2'b01}];
assign data_block [95:64] = main [{address [ 9:2], 2'b10}];
assign data_block [127:96] = main [{address [ 9:2], 2'b11}];


endmodule 