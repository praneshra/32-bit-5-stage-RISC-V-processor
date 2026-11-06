`timescale 1ns / 1ps

module tb_riscv_single_cycle;
    reg clk;
    reg rst;
    wire [31:0] pc_dbg;
    wire [31:0] instr_dbg;
    wire [31:0] gr [0:31];

    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : gen_gr
            wire [31:0] val;
            assign val = u_dut.gr_dbg[idx];
        end
    endgenerate

    riscv_single_cycle u_dut (
        .clk(clk),
        .rst(rst),
        .pc_dbg(pc_dbg),
        .instr_dbg(instr_dbg),
        .gr_dbg(u_dut.gr_dbg)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        rst = 1;
        #20;
        rst = 0;
        #1000;
        $finish;
    end
endmodule
