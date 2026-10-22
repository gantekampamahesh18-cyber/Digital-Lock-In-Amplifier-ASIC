
`timescale 1ns/1ps

module lockin_core (
    input  wire                    clk,
    input  wire                    rst,
    input  wire                    enable,
    input  wire signed [15:0]      sample_in,
    input  wire signed [7:0]       sin_ref,
    input  wire signed [7:0]       cos_ref,

    output reg signed [23:0]       i_accum,
    output reg signed [23:0]       q_accum,
    output reg                     result_valid
);

    reg [7:0] sample_count;

    wire signed [23:0] i_product;
    wire signed [23:0] q_product;

    assign i_product = sample_in * cos_ref;
    assign q_product = sample_in * sin_ref;

    always @(posedge clk) begin
        if (rst) begin
            i_accum      <= 24'sd0;
            q_accum      <= 24'sd0;
            sample_count <= 8'd0;
            result_valid <= 1'b0;
        end
        else begin
            result_valid <= 1'b0;

            if (enable) begin
                i_accum <= i_accum + i_product;
                q_accum <= q_accum + q_product;

                if (sample_count == 8'd255) begin
                    sample_count <= 8'd0;
                    result_valid <= 1'b1;
                end
                else begin
                    sample_count <= sample_count + 8'd1;
                end
            end
        end
    end

endmodule

