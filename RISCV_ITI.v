
module RISCV_ITI (
	input clk,areset
);

    reg [31:0]SrcB,Result;
    wire [31:0]SrcA,ALUResult;
	wire [2:0]ALUControl;
    wire zero,sign,PCSrc,load,RegWrite,WE,ALUSrc,ResultSrc;
	wire[31:0]ImmExt,PC,Instr,WD,RD;
	wire[1:0]ImmSrc;
    reg[6:0] OpCode;
    reg check;
    always @(*) begin
        OpCode=Instr[6:0];
        if (OpCode== 7'b000_0011 )  //loadword
            check=1;
        else check=~WE;
        end




 Instruction_Memory InstrMem1(PC,Instr);
 
 Sign_extend Sign1(ImmSrc,Instr[31:7],ImmExt);

 ALU alu1(SrcA,SrcB,ALUControl,ALUResult,zero,sign);

 Program_Counter pc1(clk,stall,areset,PCSrc,ImmExt,PC);
top_cash dm(clk, areset, ALUResult, WD, WE, check, stall, RD);
 Control_Unit CU1(zero,sign,Instr,load,PCSrc,ALUSrc,ResultSrc,WE,RegWrite,ALUControl,ImmSrc);

 Register_File RF1(Instr[19:15],Instr[24:20],Instr[11:7],Result,RegWrite,clk,SrcA,WD);

 always @(*) begin
    if(ALUSrc==0)
    SrcB=WD; 
    else
    SrcB=ImmExt;

 end
 always @(*) begin
    if(ResultSrc==1)
    Result=RD;
    else
    Result=ALUResult;
 end

endmodule