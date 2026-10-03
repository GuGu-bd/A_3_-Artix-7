`timescale 1ns / 1ns

module tb_complex_fsm();

reg sys_clk;
reg sys_rst_n;
reg pi_money_half;
reg pi_money_one;

wire po_cola;
wire po_money;

reg random_data;

initial begin
    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;
    #20
    sys_rst_n <= 1'b1;
end

always #10 sys_clk <= ~sys_clk;

always@(posedge sys_clk or negedge sys_rst_n)
    if (sys_rst_n == 1'b0)
        random_data <= 1'b0;
    else
        random_data <= {$random} % 2;

always@(posedge sys_clk or negedge sys_rst_n)
    if (sys_rst_n == 1'b0)
        pi_money_half <= 1'b0;
    else
        pi_money_half <= random_data;

always@(posedge sys_clk or negedge sys_rst_n)
    if (sys_rst_n == 1'b0)
        pi_money_one <= 1'b0;
    else
        pi_money_one <= ~random_data;

complex_fsm complex_fsm_inst
(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .pi_money_half(pi_money_half),
    .pi_money_one(pi_money_one),

    .po_cola(po_cola),
    .po_money(po_money)
);

endmodule