`default_nettype none
module sar_logic #(
    parameter PRECISION = 10
) (
    input rst,
    input clk,
    input cmp,
    output reg [PRECISION - 1 : 0] sar_out
);

    parameter COUNTER_LAST_BIT_INDEX = $clog2(PRECISION + 2) - 1;

    reg [COUNTER_LAST_BIT_INDEX : 0] clk_counter;

    always @(posedge clk) begin
        if (rst || clk_counter == PRECISION + 1)
            clk_counter <= 0;
        else 
            clk_counter <= clk_counter + 1;
    end

    always @(posedge clk) begin
        if (!clk_counter) begin
            sar_out <= 0;
        end
        else begin
            if (clk_counter > 1 && !cmp) begin
                sar_out[PRECISION - clk_counter + 1] <= 0;
            end
            sar_out[PRECISION - clk_counter] <= 1;
        end
    end

endmodule
`default_nettype wire
