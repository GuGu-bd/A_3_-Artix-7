module mux2_1
(
    input wire in_1,
    input wire in_2,
    input wire sel,

    output reg out
);

always@(*)
    if(sel == 1'b1)
        out = in_1;
    else
        out = in_2;

endmodule