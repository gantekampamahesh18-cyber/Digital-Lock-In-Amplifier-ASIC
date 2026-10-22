`timescale 1ns/1ps

module reference_gen (
    input  wire              clk,
    input  wire              rst,
    input  wire              enable,
    output reg signed [7:0]   sin_ref,
    output reg signed [7:0]   cos_ref
);

    reg [3:0] phase;

    always @(posedge clk) begin
        if (rst) begin
            phase   <= 4'd0;
            sin_ref <= 8'sd0;
            cos_ref <= 8'sd127;
        end
        else if (enable) begin
            phase <= phase + 4'd1;

            case (phase)
                4'd0:  begin sin_ref <= 8'sd0;    cos_ref <= 8'sd127;  end
                4'd1:  begin sin_ref <= 8'sd49;   cos_ref <= 8'sd117;  end
                4'd2:  begin sin_ref <= 8'sd90;   cos_ref <= 8'sd90;   end
                4'd3:  begin sin_ref <= 8'sd117;  cos_ref <= 8'sd49;   end
                4'd4:  begin sin_ref <= 8'sd127;  cos_ref <= 8'sd0;    end
                4'd5:  begin sin_ref <= 8'sd117;  cos_ref <= -8'sd49;   end
                4'd6:  begin sin_ref <= 8'sd90;   cos_ref <= -8'sd90;   end
                4'd7:  begin sin_ref <= 8'sd49;   cos_ref <= -8'sd117;  end
                4'd8:  begin sin_ref <= 8'sd0;    cos_ref <= -8'sd127;  end
                4'd9:  begin sin_ref <= -8'sd49;  cos_ref <= -8'sd117;  end
                4'd10: begin sin_ref <= -8'sd90;  cos_ref <= -8'sd90;   end
                4'd11: begin sin_ref <= -8'sd117; cos_ref <= -8'sd49;   end
                4'd12: begin sin_ref <= -8'sd127; cos_ref <= 8'sd0;     end
                4'd13: begin sin_ref <= -8'sd117; cos_ref <= 8'sd49;    end
                4'd14: begin sin_ref <= -8'sd90;  cos_ref <= 8'sd90;    end
                4'd15: begin sin_ref <= -8'sd49;  cos_ref <= 8'sd117;   end
            endcase
        end
    end

endmodule

