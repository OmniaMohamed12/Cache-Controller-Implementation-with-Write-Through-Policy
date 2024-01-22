`timescale 1 ns/10 ps
module tb_RISCV();

reg clk,areset;
integer i;

RISCV_ITI riscv(.clk(clk),.areset(areset));

always
begin
#10; clk=~clk;
end


initial
begin
clk=0;
areset=0;
#10;
areset=1;
#7000;

$stop;
end
endmodule
