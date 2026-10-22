
`timescale 1ns/1ps

module lockin_top (
    input  wire               clk,
    input  wire               rst,
    input  wire               enable,
    input  wire signed [15:0] sample_in,

    output wire signed [23:0] i_accum,
    output wire signed [23:0] q_accum,
    output wire               result_valid
);

    wire signed [7:0] sin_ref;
    wire signed [7:0] cos_ref;

    reference_gen u_ref (
        .clk      (clk),
        .rst      (rst),
        .enable   (enable),
        .sin_ref  (sin_ref),
        .cos_ref  (cos_ref)
    );

    lockin_core u_core (
        .clk          (clk),
        .rst          (rst),
        .enable       (enable),
        .sample_in    (sample_in),
        .sin_ref      (sin_ref),
        .cos_ref      (cos_ref),
        .i_accum      (i_accum),
        .q_accum      (q_accum),
        .result_valid (result_valid)
    );

endmodule

