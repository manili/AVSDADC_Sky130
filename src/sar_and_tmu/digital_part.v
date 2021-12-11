`include "sar_logic.v"
`include "timing_management_unit.v"

`default_nettype none
module digital_part #(
    //TMU Parameters
    parameter HIGH_COUNT = 1,
    parameter LOW_COUNT = 12,
    //SAR Parameters
    parameter PRECISION = 10
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    //Common Input Signals
    input rst,
    input clk,
    //SAR Specific Input Signals
    input cmp,
    //TM Specific Output Signals
    output clk_out,
    //SAR Specific Output Signals
    output [PRECISION - 1 : 0] sar_out
);

    timing_management_unit #(
        .HIGH_COUNT(HIGH_COUNT),
        .LOW_COUNT(LOW_COUNT)
    ) tmu (
        .rst(rst),
        .clk_in(clk),
        .clk_out(clk_out)
    );

    sar_logic #(
        .PRECISION(PRECISION)
    ) sar (
        .rst(rst),
        .clk(clk),
        .cmp(cmp),
        .sar_out(sar_out)
    );

endmodule
`default_nettype wire
