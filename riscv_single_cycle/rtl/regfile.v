module regfile (
    input         clk,
    input         we,
    input  [4:0]  a1,
    input  [4:0]  a2,
    input  [4:0]  a3,
    input  [31:0] wd,
    output [31:0] rd1,
    output [31:0] rd2,
    // Debug interface
    output reg [31:0] gr_out [0:31]
);
    reg [31:0] rf [31:0];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1)
            rf[i] = 32'd0;
    end

    always @(posedge clk) begin
        if (we && (a3 != 5'd0))
            rf[a3] <= wd;
    end

    assign rd1 = (a1 != 5'd0) ? rf[a1] : 32'd0;
    assign rd2 = (a2 != 5'd0) ? rf[a2] : 32'd0;

    // Debug output continuous assignment
    always @(*) begin
        for (i = 0; i < 32; i = i + 1)
            gr_out[i] = rf[i];
    end
endmodule
