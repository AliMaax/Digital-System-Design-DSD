// File: clk_div_25.sv
// Clock divider: divide input clock by 25 (approx. 50% duty).
module clk_div_25 (
    input  logic clk_in,
    input  logic rst,
    output logic clk_out
);
    // We alternate counts of 13 and 12 to achieve divide-by-25 at ~50% duty.
    logic [5:0] count;
    logic       toggle;
    always_ff @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count  <= 6'd0;
            clk_out <= 1'b0;
            toggle <= 1'b0;
        end else begin
            if (count == (toggle ? 11 : 12)) begin
                clk_out <= ~clk_out;
                toggle  <= ~toggle;
                count   <= 6'd0;
            end else begin
                count <= count + 6'd1;
            end
        end
    end
endmodule
