module control (
    input  [6:0] opcode,
    output reg   branch,
    output reg   mem_read,
    output reg   mem_to_reg,
    output reg [1:0] alu_op,
    output reg   mem_write,
    output reg   alu_src,
    output reg   reg_write,
    output reg   jump
);
    always @(*) begin
        // Defaults
        branch     = 1'b0;
        mem_read   = 1'b0;
        mem_to_reg = 1'b0;
        alu_op     = 2'b00;
        mem_write  = 1'b0;
        alu_src    = 1'b0;
        reg_write  = 1'b0;
        jump       = 1'b0;

        case (opcode)
            7'b0110011: begin // R-type (add, sub, etc.)
                reg_write  = 1'b1;
                alu_op     = 2'b10;
            end
            7'b0010011: begin // I-type arithmetic (addi, etc.)
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                alu_op     = 2'b00;
            end
            7'b0000011: begin // Load (lw)
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 1'b1;
                alu_op     = 2'b00;
            end
            7'b0100011: begin // Store (sw)
                alu_src    = 1'b1;
                mem_write  = 1'b1;
                alu_op     = 2'b00;
            end
            7'b1100011: begin // Branch (beq, bne, etc.)
                branch     = 1'b1;
                alu_op     = 2'b01;
            end
            7'b1101111: begin // JAL
                reg_write  = 1'b1;
                jump       = 1'b1;
            end
            7'b1100111: begin // JALR
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                jump       = 1'b1;
            end
            7'b0110111: begin // LUI
                reg_write  = 1'b1;
                alu_src    = 1'b1;
            end
            default: ;
        endcase
    end
endmodule
