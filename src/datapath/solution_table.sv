/*
 * rd0/wd0 corresponds to the 32-bit t_off values
 * rd1/wd1 corresponds to the 1-bit dir values
 *
 * both rd0 and rd1 are outputted as an unpacked array (e.g., rd0[0:2]),
 * meaning no read address is required.
 */
module solution_table(
    input logic clk, we, wd1,
    input logic [1:0] wa,
    input logic [31:0] wd0,
    output logic [31:0] rd0 [0:2],
    output logic rd1 [0:2]
);

    always_ff @(posedge clk) begin
        if(we) begin
            rd0[wa] <= wd0;
            rd1[wa] <= wd1;
        end
    end

endmodule
