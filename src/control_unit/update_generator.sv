module update_generator(
    input logic clk, N_reset,
    input logic [31:0] t_up,
    output logic update
);

    logic [31:0] counter;

    // Generate update pulse
    // (uses >= in case t_up value is changed)
    assign update = (counter >= t_up);

    always_ff @(posedge clk or negedge N_reset) begin
        if(!N_reset)
            counter <= '0;
        else
            counter <= (update) ? '0 : counter + 1;
    end

endmodule
