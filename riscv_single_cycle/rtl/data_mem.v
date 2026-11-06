module data_mem #(
    parameter ADDR_BITS = 10
)(
    input         clk,
    input         mem_write,
    input         mem_read,
    input  [31:0] addr,
    input  [31:0] write_data,
    output [31:0] read_data
);
    reg [31:0] mem [0:(1<<ADDR_BITS)-1];

    always @(posedge clk) begin
        if (mem_write)
            mem[addr[ADDR_BITS+1:2]] <= write_data;
    end

    assign read_data = (mem_read) ? mem[addr[ADDR_BITS+1:2]] : 32'd0;
endmodule
