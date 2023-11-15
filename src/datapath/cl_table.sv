module cl_table(
    input logic clk, N_reset, update, we,
    input logic [1:0] ra, wa,
    input logic [31:0] wd,
    output logic [31:0] rd
);

    logic [31:0] p_current [0:2];
    logic [31:0] p_target [0:2];
    logic [31:0] velocity [0:2];

    always_ff @(posedge clk or negedge N_reset) begin
        if(!N_reset) begin
            p_current <= '{'0, '0, '0};
            p_target <= '{'0, '0, '0};
        end
        else begin
            if(update) begin
                p_current <= p_target;

                for(int i = 0; i < 3; i++)
                    velocity[i] <= p_target[i] - p_current[i];
            end
            
            if(we)
                p_target[wa] <= wd;
        end
    end

    assign rd = velocity[ra];

endmodule
