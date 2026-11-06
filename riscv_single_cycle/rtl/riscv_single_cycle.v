module riscv_single_cycle (
    input         clk,
    input         rst,
    output [31:0] pc_dbg,
    output [31:0] instr_dbg,
    output [31:0] gr_dbg [0:31]
);
    wire [31:0] pc, pc_next, pc_plus4, pc_target;
    wire [31:0] instr;
    wire [31:0] rd1, rd2, wd, alu_a, alu_b, alu_result, imm, read_data;
    wire [3:0]  alu_ctrl;
    wire [1:0]  alu_op;
    wire        branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, jump, zero, branch_taken, pc_src;

    assign pc_dbg = pc;
    assign instr_dbg = instr;

    pc_reg u_pc (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc)
    );

    assign pc_plus4 = pc + 32'd4;
    assign pc_target = pc + imm;
    assign pc_src = (branch && branch_taken) || jump;
    assign pc_next = pc_src ? pc_target : pc_plus4;

    instr_mem u_imem (
        .addr(pc),
        .instr(instr)
    );

    control u_ctrl (
        .opcode(instr[6:0]),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .jump(jump)
    );

    imm_gen u_imm (
        .inst(instr),
        .imm(imm)
    );

    regfile u_regfile (
        .clk(clk),
        .we(reg_write),
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2),
        .gr_out(gr_dbg)
    );

    assign alu_a = rd1;
    assign alu_b = alu_src ? imm : rd2;

    alu_control u_aluctrl (
        .alu_op(alu_op),
        .funct7_5(instr[30]),
        .funct3(instr[14:12]),
        .alu_ctrl(alu_ctrl)
    );

    alu u_alu (
        .a(alu_a),
        .b(alu_b),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero)
    );

    branch_unit u_br (
        .a(rd1),
        .b(rd2),
        .funct3(instr[14:12]),
        .branch_taken(branch_taken)
    );

    data_mem u_dmem (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .addr(alu_result),
        .write_data(rd2),
        .read_data(read_data)
    );

    assign wd = mem_to_reg ? read_data : alu_result;

endmodule
