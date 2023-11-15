module decoder(
    input logic en,
    input logic [7:0] instr,
    input logic [31:0] payload,
    output logic cl_we, gp_we,
    output logic [1:0] wa,
    output logic [31:0] wd
);

    always_comb begin
        cl_we = en & instr[6] & instr[4];
        gp_we = en & instr[6] & instr[5];
        wa = instr[3:0];
        wd = payload;
    end

endmodule
