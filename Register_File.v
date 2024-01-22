module Register_File (input [4:0]A1,input [4:0]A2,input [4:0]A3, input [31:0]WD3,input WE3,input clk,
                    output reg [31:0] RD1,output reg [31:0]RD2);
	reg [31:0]regfile[0:31];
integer i;
initial begin 
 for (i=0;i<32;i=i+1) begin
		   regfile[i]=0;
  end
 end
	always @(posedge clk  )  
	begin
     if (WE3) begin
		   regfile[A3] <= WD3;
		   end
	end
	always@(*)begin
	  RD1 <= regfile[A1];
	  RD2 <= regfile[A2];
     end
endmodule 
