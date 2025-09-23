`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 11:22:12 AM
// Design Name: 
// Module Name: maindec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module maindec(
    input logic [10:0] Op,
    input logic reset,
    input logic ExtIRQ,
    output logic [3:0] EStatus,
    output logic Reg2Loc,
    output logic ALUSrc,
    output logic MemtoReg,
    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic Branch,
    output logic [1:0] ALUOp,
    output logic Exc 
);
    
    localparam [10:0] LDUR_OP = 11'b111_1100_0010;
    localparam [10:0] STUR_OP = 11'b111_1100_0000;
    localparam [10:0] CBZ_OP  = 11'b101_1010_0???;
    
    localparam [10:0] ADD_OP  = 11'b100_0101_1000;
    localparam [10:0] SUB_OP  = 11'b110_0101_1000;
    localparam [10:0] AND_OP  = 11'b100_0101_0000;
    localparam [10:0] ORR_OP  = 11'b101_0101_0000;
    
    logic NotAnInstr;
    
    always_comb begin 
        // Valores por defecto
        EStatus   = 4'b0000;
        Reg2Loc   = 1'b0;
        ALUSrc    = 1'b0;
        MemtoReg  = 1'b0;
        RegWrite  = 1'b0;
        MemRead   = 1'b0;
        MemWrite  = 1'b0;
        Branch    = 1'b0;
        ALUOp     = 2'b00;
        Exc       = 1'b0;
        NotAnInstr = 1'b0;

        if (!reset && !ExtIRQ) begin
            casez (Op)
                ADD_OP,
                SUB_OP,
                AND_OP,
                ORR_OP: begin
                    RegWrite = 1'b1;
                    ALUOp    = 2'b10;
                end

                LDUR_OP: begin 
                    ALUSrc   = 1'b1; 
                    MemtoReg = 1'b1; 
                    RegWrite = 1'b1; 
                    MemRead  = 1'b1; 
                end 
                
                STUR_OP: begin 
                    Reg2Loc  = 1'b1;
                    ALUSrc   = 1'b1; 
                    MemWrite = 1'b1;
                end  
                
                CBZ_OP: begin 
                    Reg2Loc = 1'b1;
                    Branch  = 1'b1; 
                    ALUOp   = 2'b01;
                end

                default: begin
                    NotAnInstr = 1'b1; 
                end
            endcase 
        end 
        
        // Manejo de estados de excepción
        if (NotAnInstr) begin 
            EStatus = 4'b0010;
        end
        else if (ExtIRQ) begin
            EStatus = 4'b0001;
        end
        
        // Señal de excepción
        Exc = NotAnInstr || ExtIRQ;
    end
    
endmodule
