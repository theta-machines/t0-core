module esu(
    input logic clk, N_reset, start,
    input logic [31:0] t_up, t_on, velocity,
    output logic [31:0] t_off,
    output logic dir, done
);

    logic div_done, div_done_prev;
    logic [31:0] speed, q;

    always_comb begin
        dir = velocity[31];
        speed = (dir) ? -velocity : velocity;
        t_off = q - t_on;
    end

    divider divider(
        // Inputs
        .clk(clk), .N_reset(N_reset), .start(start), .a(t_up), .b(speed),

        // Outputs
        .q(q), .r(), .done(div_done) // output `r` isn't used
    );

    // `done` rising edge detector
    assign done = div_done & ~div_done_prev;
    always_ff @(posedge clk) begin
        div_done_prev <= div_done;
    end

endmodule
