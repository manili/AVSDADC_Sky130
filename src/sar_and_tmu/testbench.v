`timescale 1ns / 1ps

`ifdef USE_POWER_PINS
    `include "primitives.v"
    `include "sky130_fd_sc_hd.v"
`else
    `include "digital_part.v"
`endif

module testbench;
`ifdef USE_POWER_PINS
    supply0 vgnd;
    supply1 vpwr;
`endif

    reg rst;
    reg clk;

    parameter SIMULATION_DURATION = 10000;

    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
    end

    initial begin
        #SIMULATION_DURATION $finish;
    end

    initial begin
        rst = 1'b1;
        #300;
        rst = 1'b0;
    end

    initial begin
        clk = 1'b0;
        repeat (SIMULATION_DURATION / 50) begin
            #50 clk = ~clk;
        end
    end

//////////////////////////////// Timing Manager Test ////////////////////////////////
    parameter HIGH_COUNT = 1;
    parameter LOW_COUNT = 11;
    
    wire clk_out;

////////////////////////////////////// SAR Test /////////////////////////////////////
    parameter PRECISION = 10;
    
    wire [PRECISION - 1 : 0] sar;
    wire cmp = (sar == 'b10_0000_0000 || sar == 'b10_0100_0000 || sar == 'b10_0100_1000 || sar == 'b10_0100_1010 || sar == 'b10_0100_1011) ? 1 : 0;

//////////////////////////////// Module Instantiation ///////////////////////////////
    digital_part #(
        //TM Parameters
        .HIGH_COUNT(HIGH_COUNT),
        .LOW_COUNT(LOW_COUNT),
        //SAR Parameters
        .PRECISION(PRECISION)
    ) uut (
`ifdef USE_POWER_PINS
        // User area 1 1.8V supply
        .vccd1(vpwr),
        // User area 1 digital ground
        .vssd1(vgnd),
`endif
        //Common Input Signals
        .rst(rst),
        .clk(clk),
        //SAR Specific Input Signals
        .cmp(cmp),
        //TM Specific Output Signals
        .clk_out(clk_out),
        //SAR Specific Output Signals
        .sar_out(sar)
    );

endmodule
