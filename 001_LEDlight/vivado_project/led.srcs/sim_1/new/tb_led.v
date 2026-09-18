`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/17 14:24:06
// Design Name: 
// Module Name: tb_led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_led;

wire led_out;
reg key_in;
initial key_in <= 1'b0;
always #10 key_in <= {$random} % 2;

led led_inst
(
    .key_in(key_in),
    .led_out(led_out)
);
endmodule
