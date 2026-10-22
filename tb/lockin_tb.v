
`timescale 1ns/1ps

module lockin_tb;

    reg clk;
    reg rst;
    reg enable;
    reg signed [15:0] sample_in;

    wire signed [23:0] i_accum;
    wire signed [23:0] q_accum;
    wire result_valid;

    integer i;
    integer valid_count;
    integer file_handle;

    lockin_top dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .sample_in(sample_in),
        .i_accum(i_accum),
        .q_accum(q_accum),
        .result_valid(result_valid)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        enable = 0;
        sample_in = 0;
        valid_count = 0;

        file_handle = $fopen("lockin_output.csv", "w");
        $fwrite(file_handle, "time,sample,i_accum,q_accum,result_valid\n");

        $dumpfile("lockin.vcd");
        $dumpvars(0, lockin_tb);

        // Apply synchronous reset
        repeat (2) @(negedge clk);
        rst = 0;
        enable = 1;

        // Send 600 constant input samples
        for (i = 0; i < 600; i = i + 1) begin
            @(negedge clk);
            sample_in = 16'sd1000;
        end

        @(negedge clk);
        enable = 0;

        repeat (2) @(negedge clk);

        $fclose(file_handle);

        $display("Simulation finished.");
        $display("Final I accumulator = %0d", $signed(i_accum));
        $display("Final Q accumulator = %0d", $signed(q_accum));
        $display("Valid pulses counted = %0d", valid_count);

        if (valid_count == 2)
            $display("PASS: Two 256-sample windows completed.");
        else
            $display("CHECK: Expected 2 valid pulses.");

        $finish;
    end

    always @(posedge clk) begin
        if (result_valid)
            valid_count = valid_count + 1;

        if (file_handle != 0)
            $fwrite(file_handle, "%0t,%0d,%0d,%0d,%0b\n",
                    $time, $signed(sample_in),
                    $signed(i_accum), $signed(q_accum),
                    result_valid);
    end

endmodule


