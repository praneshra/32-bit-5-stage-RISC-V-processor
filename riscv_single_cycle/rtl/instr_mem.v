module instr_mem #(
    parameter ADDR_BITS = 10,
    parameter FILE = "program.hex"
)(
    input  [31:0] addr,
    output [31:0] instr
);
    reg [31:0] mem [0:(1<<ADDR_BITS)-1];
    integer i;

    initial begin
        for (i = 0; i < (1<<ADDR_BITS); i = i + 1)
            mem[i] = 32'h0000_0013; // NOP (addi x0, x0, 0)
        $readmemh(FILE, mem);
    end

    assign instr = mem[addr[ADDR_BITS+1:2]];
endmodule
