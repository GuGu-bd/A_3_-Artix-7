module divider_six
#(
    parameter CNT_MAX = 3'd5
)
(
    input wire sys_clk,
    input wire sys_rst_n,

    output reg clk_flag
);

reg [2:0] cnt;


always@(posedge sys_clk or negedge sys_rst_n)
    if (sys_rst_n == 1'b0)
        cnt <= 3'b0;
    else if (cnt == CNT_MAX)
        cnt <= 3'b0;
    else
        cnt <= cnt + 3'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if (sys_rst_n == 1'b0)
        clk_flag <= 1'b0;
    else if (cnt == CNT_MAX-1)
        clk_flag <= 1'b1;
    else if (cnt == CNT_MAX)
        clk_flag <= 1'b0;
    else
        clk_flag <= clk_flag;

endmodule