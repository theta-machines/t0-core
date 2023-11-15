/**
 * Parameter Addresses:
 * 00 - t_up
 * 01 - t_on[0]
 * 10 - t_on[1]
 * 11 - t_on[2]
 */

module gp_table(
    input logic clk, N_reset, we,
    input logic [1:0] wa,
    input logic [31:0] wd,
    output logic [31:0] rd [0:3]
);

    always_ff @(posedge clk or negedge N_reset) begin
        if(!N_reset) begin
            rd <= '{'0, '0, '0, '0};
        end else if(we) begin
            rd[wa] <= wd;
        end
    end

endmodule
