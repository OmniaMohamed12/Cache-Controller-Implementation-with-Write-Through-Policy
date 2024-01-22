module Control_Unit ( input zero,sign,[31:0]instr,output load,
    output reg PCSrc,ALUSrc,ResultSrc,MemWrite,RegWrite,[2:0]ALUControl,[1:0]ImmSrc );
    reg [6:0]OpCode;
	reg[2:0]funct3;
	reg[1:0]ALUOp;
    reg funct7,Branch;
	
    always @(*) begin
        OpCode=instr[6:0];
        funct3=instr[14:12];
        funct7=instr[30];
    end
// alu decoder
    always @(*) begin
        case (ALUOp)
        2'b00:begin
          ALUControl=3'b000;//add
        end 
        2'b01:begin
               case (funct3)
                     3'b000:  ALUControl = 3'b010; 
                     3'b001:  ALUControl = 3'b010;
                     3'b100:  ALUControl = 3'b010;
                    default: ALUControl = 3'b000;
                endcase
             end
        2'b10:begin
            case (funct3)
            3'b000:begin
                if({OpCode[5],funct7}==2'b11)
                    ALUControl=3'b010;//sub
                else
                    ALUControl=3'b000;//add
            end 
            3'b001:begin
                ALUControl=3'b001;//Shift Left
            end
            3'b100:begin
                ALUControl=3'b100;//xor
            end
            3'b101:begin
                ALUControl=3'b101;//Shift right
            end
            3'b110:begin
                ALUControl=3'b110;//or
            end
            3'b111:begin
                ALUControl=3'b111;//and
            end
                default: begin
                    ALUControl=3'b000;
                end
            endcase
        end
            default: begin
                ALUControl=3'b000;
            end
        endcase
    end
// main decoder
    always @(*) begin
        case (OpCode)
        7'b000_0011:begin //loadWord
            RegWrite=1'b1;
            ImmSrc=2'b00;
            ALUSrc=1'b1;
            MemWrite=1'b0;
            ResultSrc=1'b1;
            Branch=1'b0;
            ALUOp=2'b00;
        end 
        7'b010_0011:begin //storeWord
            RegWrite=1'b0;
            ImmSrc=2'b01;
            ALUSrc=1'b1;
            MemWrite=1'b1;
            Branch=1'b0;
            ALUOp=2'b00;
        end
        7'b011_0011:begin //R-Type
            RegWrite=1'b1;
            ALUSrc=1'b0;
            MemWrite=1'b0;
            ResultSrc=1'b0;
            Branch=1'b0;
            ALUOp=2'b10;
        end
        7'b001_0011:begin //I-Type
            RegWrite=1'b1;
            ImmSrc=2'b00;
            ALUSrc=1'b1;
            MemWrite=1'b0;
            ResultSrc=1'b0;
            Branch=1'b0;
            ALUOp=2'b10;
        end
        7'b110_0011:begin //Branch Instructions
            RegWrite=1'b0;
            ImmSrc=2'b10;
            ALUSrc=1'b0;
            MemWrite=1'b0;
            Branch=1'b1;
            ALUOp=2'b01;
        end
            default: begin
            RegWrite=1'b0;
            ImmSrc=2'b00;
            ALUSrc=1'b0;
            MemWrite=1'b0;
            ResultSrc=1'b0;
            Branch=1'b0;
            ALUOp=2'b00;
            end
        endcase
    end

    //PCSrc
    always @(*) begin

        if(Branch==1'b1)
        begin
            case (funct3)
            3'b000:begin //Beq
                PCSrc=Branch & zero;
            end 
            3'b001:begin //Bnq
                PCSrc=Branch & ~(zero);
            end
            3'b100:begin //Blt
                PCSrc= Branch & sign;
            end
                default: begin
                    PCSrc=1'b0;
                end
            endcase
        end
        else
        begin
            PCSrc=1'b0;
        end
    end
    
    assign load=1'b1;
    
endmodule
