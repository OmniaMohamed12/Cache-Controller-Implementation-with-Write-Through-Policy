module Program_Counter(input clk,input stall,input areset,input PCSrc,input [31:0]ImmExt,output reg[31:0]pc_out );
reg [31:0] nextpc;
 always@(posedge clk or negedge areset)begin 
    if(!areset) begin
         pc_out<=0;
	 end
    else if(stall==0) begin 
	    pc_out<=nextpc;
	end
    else  pc_out<= pc_out;
    
	
 end 
 always@(*)begin
  case(PCSrc) 
           1'b1:nextpc=pc_out+ImmExt;
	       1'b0:nextpc=pc_out+32'h00000004;
           default:	nextpc=pc_out+32'h00000004;
        endcase	
 end
endmodule


