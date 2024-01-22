
module ALU(input [31:0]SrcA,input [31:0]SrcB,[2:0]ALU_control,
           output reg [31:0] ALU_result ,output reg zero,output reg sign);

always@(*) begin
case (ALU_control) 
	3'b000: ALU_result=SrcA+SrcB;
	3'b001:ALU_result=SrcA<<SrcB;
	3'b010:ALU_result=SrcA-SrcB;
	3'b100:ALU_result=SrcA^SrcB;
	3'b101:ALU_result=SrcA>>SrcB;
	3'b110:ALU_result=SrcA|SrcB;
	3'b111:ALU_result=SrcA&SrcB;
	default :ALU_result=0;
endcase 

if(ALU_result==0) begin
  zero=1;
 end
else begin
zero=0;
end
sign=ALU_result[31];

end
endmodule


