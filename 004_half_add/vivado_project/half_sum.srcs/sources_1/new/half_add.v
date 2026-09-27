module half_add(
    input wire in_1,
    input wire in_2,
    output wire sum,
    output wire count
);

assign {count,sum} = in_1 + in_2;

endmodule