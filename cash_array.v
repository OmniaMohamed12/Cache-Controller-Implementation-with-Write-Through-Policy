module cash_array (clk, reset, offset, index, tag, refill, update, w_data, r_data, main_data, valid, cash_tagged);

input clk, reset, refill, update;
input [1:0] offset;
input [4:0] index;
input [2:0] tag;
input [31:0] w_data;
input [127:0] main_data;

output valid;
output [2:0] cash_tagged;
output reg [31:0] r_data;


reg [131:0] cash [0:31];    //32 block each of 128 bit data + 3 bit tag + 1 valid bit
integer i;


always @ (posedge clk or negedge reset) begin
	if (reset==0) begin           //reset all valid bits and tag fields to zero
		for (i=0; i<32; i=i+1)
		cash[i] [132:128] <=0;
	end

	else if (refill) begin                  //fill a whole block of cash with data from main (in case of read miss)
		cash [index] [127:0] = main_data;
		cash [index] [131]=1'b1;            //update valid to 1
		cash [index] [130:128]= tag;        //update tag 

	end
	else if (update) begin                  //write new data word in its place in cash (in case of write hit)
		case (offset)
		2'b00: cash [index] [31:0] = w_data;
		2'b01: cash [index] [63:32] = w_data;
		2'b10: cash [index] [95:64] = w_data;
		2'b11: cash [index] [127:96] = w_data;
	endcase
	end	

end






//read data
always @(*) begin 
	case (offset)
		2'b00: r_data = cash [index] [31:0];
		2'b01: r_data = cash [index] [63:32];
		2'b10: r_data = cash [index] [95:64];
		2'b11: r_data = cash [index] [127:96];
	endcase

end


assign valid = cash [index] [131] ;
assign cash_tagged = cash [index] [130:128];

endmodule