module Instruction_Memory(input [31:0]pc,output reg  [31:0] instruction );
reg [31:0]instr_mem[0:63];
initial begin 
 $readmemh("rom_riscv.txt",instr_mem,0,20);
 end
 always@(*) begin
 instruction=instr_mem[pc/4];
 end
 endmodule
