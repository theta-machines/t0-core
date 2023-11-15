module pgu(
    input logic clk, update, dir_in,
    input logic [31:0] t_on, t_off,
    output logic step, dir_out
);

    logic [31:0] clk_count, t_on_inner, t_off_inner;

    enum logic {
        HIGH = 1'b1,
        LOW = 1'b0
    } E_state, E_next_state;

    // Update, Current State, and Counter Logic
    always_ff @(posedge clk) begin
        if(update) begin
            E_state <= LOW;
            clk_count <= 32'd1;
            dir_out <= dir_in;
            t_on_inner <= t_on;
            t_off_inner <= t_off;
        end else begin
            E_state <= E_next_state;
            clk_count <= (E_next_state ^ E_state) ? 32'd1 : clk_count + 1;
        end
    end

    // Next State Logic
    always_comb begin
        case(E_state)
            HIGH: E_next_state = (clk_count == t_on_inner) ? LOW : HIGH;
            LOW: E_next_state = (clk_count == t_off_inner) ? HIGH : LOW;
        endcase
    end

    // Output Logic
    assign step = E_state;

endmodule
