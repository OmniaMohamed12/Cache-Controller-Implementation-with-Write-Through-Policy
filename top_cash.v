module top_cash (clk, reset_neg, address, write_data, write_en, read_en, stall, read_data);

input clk, reset_neg, write_en, read_en;      //no read enable for RISCV so we may always put it as 1 in integration
input [31:0] address, write_data;
output stall;
output [31:0] read_data;

wire valid, ready, cash_refill, cash_update, main_write, main_read;
wire [2:0] cash_tag;
wire [31:0] main_data;
wire [127:0] main_data_block;
//intantiate modules
Cache_Controller control (clk, reset_neg, read_en, write_en, ready, valid ,cash_tag,address[9:7],  stall, main_read, main_write,cash_refill, cash_update);
cash_array ca (clk,reset_neg, address[1:0], address[6:2], address[9:7], cash_refill, cash_update, write_data, read_data, main_data_block, valid, cash_tag);
main_memory mm (clk, main_read, main_write, address[9:0], write_data, ready, main_data_block );

endmodule 
