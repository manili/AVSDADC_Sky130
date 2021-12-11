`default_nettype none
module timing_management_unit #(
    parameter HIGH_COUNT = 1,
    parameter LOW_COUNT = 12
) (
    input rst,
    input clk_in,
    output reg clk_out
);

    parameter COUNTER_LAST_BIT_INDEX = HIGH_COUNT + LOW_COUNT - 1;
    
    reg [COUNTER_LAST_BIT_INDEX : 0] reg_counter;

    wire [COUNTER_LAST_BIT_INDEX : 0] counter_in = reg_counter << 1;

    always @(posedge clk_in) begin
        if (rst || !counter_in)
            reg_counter <= 1;
        else 
            reg_counter <= counter_in;
    end

    always @(posedge clk_in) begin
        if (rst || !counter_in || counter_in < 1 << LOW_COUNT)
            clk_out <= 0;
        else
            clk_out <= 1;
    end
    
endmodule
`default_nettype wire
