module axis_counter(
    input logic clk, update, ready,
    output logic increment,
    output logic [1:0] axis
);

    always_ff @(posedge clk) begin
        if(update) begin
            axis <= '0;
            increment <= '1;
        end else if(ready && (axis != 2'b10)) begin
            axis <= axis + 1;
            increment <= '1;
        end else begin
            increment <= '0;
        end
    end

endmodule
