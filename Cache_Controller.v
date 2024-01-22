module Cache_Controller(
input clk,rst,
input MemRead,
input MemWrite,
input ready,valid,
input [2:0]tag_cache,tag_address,
output reg stall,
output reg ReadEnable,WriteEnable,
output reg fill,update);

localparam idle=2'b00;
localparam reading=2'b01;
localparam writing=2'b10;

reg [1:0] state_reg;
reg [1:0] next_state;
reg hit,miss;

always @(negedge clk or negedge rst)begin
  if(~rst) 
    state_reg=idle;
   else 
    state_reg=next_state;
end

always@(*) begin 
    if(state_reg== writing || state_reg==reading)
        stall=1;
    else 
        stall=0;
    if(valid) begin
        if(tag_address==tag_cache)begin
            hit=1;
            miss=0;
        end
        else begin
            hit=0;
            miss=1;
        end
    end
    else begin
        hit=0;
        miss=1;
    end
end

always@(*)begin 
    case(state_reg)
        idle:begin
            if( MemWrite==0 && hit==1 && miss==0) begin
                next_state=idle;
                ReadEnable=0;
                WriteEnable=0;
                update=0;
                fill=0;
            end
           else if(MemWrite==0 && hit==0 && miss==1) begin
                next_state=reading;
                ReadEnable=1;
                WriteEnable=0;
                update=0;
                fill=1;
            end
            else if(MemWrite==1  && hit==1 && miss==0) begin
                next_state=writing;
                ReadEnable=0;
                WriteEnable=1;
                update=1;
                fill=0;
            end
            else if(MemWrite==1  && hit==0 && miss==1) begin
                next_state=writing;
                ReadEnable=0;
                WriteEnable=1;
                update=0;
                fill=0;
            end
        end
        reading:begin
            if(ready) begin
                next_state=idle;
                ReadEnable=0;
                WriteEnable=0;
                update=0;
                fill=0;
            end
            else begin
                next_state=reading;
                ReadEnable=1;
                WriteEnable=0;
                update=0;
                fill=1;
            end
        end
        writing:begin
           if(ready) begin
                next_state=idle;
                ReadEnable=0;
                WriteEnable=0;
                update=0;
                fill=0;
            end
            else begin
                next_state=writing;
                ReadEnable=0;
                if(hit ==1 && miss==0)begin
                WriteEnable=1;
                update=1;
                end 
                else begin 
                WriteEnable=1;
                update=0;
                end
                fill=0;
            end
        
        end
        default : begin
            next_state=idle;
        end
    endcase
end

endmodule 