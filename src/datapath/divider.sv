/*
 * This module accepts values `a` and `b` and returns the values `q` and `r`
 * such that `a / b = q remainder r`.
 *
 * All values are treated as 32-bit unsigned integers. The maximum allowed
 * value for `b` is 2^31.
 *
 * Upon "start", internal values will reset. `q` and `r` will be calculated
 * over the next 32 clock cycles. Immediately after, `done` is brought high.
 */

module divider (
    input logic clk, N_reset, start,
    input logic [31:0] a, b,
    output logic [31:0] q, r,
    output logic done
);

    logic [31:0] a_inner, b_inner, r_shifted, d;
    logic [5:0] counter;
    logic d_sign, counter_sign;

    always_comb begin
        r_shifted = {r, a_inner[counter]};
        d = r_shifted - b_inner;
        d_sign = d[31];

        counter_sign = counter[5];
        done = counter_sign;
    end

    always_ff @(posedge clk or negedge N_reset) begin
        if(!N_reset)
            counter <= '0;
        else if(start) begin
            counter <= 6'd31;
            a_inner <= a;
            b_inner <= b;
            r <= '0;
        end else if(~counter_sign) begin
            q[counter] <= ~d_sign;
            r <= (d_sign) ? r_shifted : d;
            counter <= counter - 1;
        end
    end

endmodule
