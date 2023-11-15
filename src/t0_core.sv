module t0_core(
    input logic clk, N_reset, data_ready,
    input logic [7:0] data,
    output logic data_request,
    output logic step [0:2],
    output logic dir [0:2]
);

    // Internal Nets
    logic cl_we, update;
    logic [1:0] cl_wa;
    logic [31:0] cl_wd, t_up;
    logic [31:0] t_on_bus [0:2];

    control_unit control_unit(
        .clk(clk), .N_reset(N_reset), .data_ready(data_ready), .data(data),

        .data_request(data_request), .cl_we(cl_we), .update(update),
        .wa(cl_wa), .wd(cl_wd), .t_up(t_up), .t_on(t_on_bus)
    );

    datapath datapath(
        .clk(clk), .N_reset(N_reset), .update(update), .cl_we(cl_we),
        .cl_wa(cl_wa), .cl_wd(cl_wd), .t_up(t_up), .t_on_bus(t_on_bus),

        .step(step), .dir(dir)
    );

endmodule: t0_core



module control_unit(
    input logic clk, N_reset, data_ready,
    input logic [7:0] data,
    output logic data_request, cl_we, update,
    output logic [1:0] wa,
    output logic [31:0] wd, t_up,
    output logic [31:0] t_on [0:2]
);

    // Internal nets
    logic fetch_done, gp_we;
    logic [7:0] instr;
    logic [31:0] payload;
    logic [31:0] gp_rd [0:3];

    // Derive signals from gp_rd
    assign t_up = gp_rd[0];
    assign t_on = gp_rd[1:3];

    fetch_unit fetch_unit(
        .clk(clk), .N_reset(N_reset), .update(update),
        .data_ready(data_ready), .data(data),

        .done(fetch_done), .data_request(data_request), .instr(instr),
        .payload(payload)
    );

    decoder decoder(
        .en(fetch_done), .instr(instr), .payload(payload),

        .cl_we(cl_we), .gp_we(gp_we), .wa(wa), .wd(wd)
    );

    gp_table gp_table(
        .clk(clk), .N_reset(N_reset), .we(gp_we), .wa(wa), .wd(wd),

        .rd(gp_rd)
    );

    update_generator update_generator(
        .clk(clk), .N_reset(N_reset), .t_up(t_up),

        .update(update)
    );

endmodule: control_unit



module datapath(
    input logic clk, N_reset, update, cl_we,
    input logic [1:0] cl_wa,
    input logic [31:0] cl_wd, t_up,
    input [31:0] t_on_bus [0:2],
    output logic step [0:2],
    output logic dir [0:2]
);

    // Internal nets
    logic ac_inc, esu_dir, esu_done;
    logic [1:0] axis;
    logic [31:0] velocity, esu_t_off;
    logic [31:0] t_off_bus [0:2];
    logic dir_bus [0:2];

    axis_counter axis_counter(
        .clk(clk), .update(update), .ready(esu_done),

        .increment(ac_inc), .axis(axis)
    );

    cl_table cl_table(
        .clk(clk), .N_reset(N_reset), .update(update), .we(cl_we), .ra(axis),
        .wa(cl_wa), .wd(cl_wd),

        .rd(velocity)
    );

    esu esu(
        .clk(clk), .N_reset(N_reset), .start(ac_inc), .t_up(t_up),
        .t_on(t_on_bus[axis]), .velocity(velocity),

        .t_off(esu_t_off), .dir(esu_dir), .done(esu_done)
    );

    solution_table solution_table(
        .clk(clk), .we(esu_done), .wa(axis), .wd0(esu_t_off),
        .wd1(esu_dir),

        .rd0(t_off_bus), .rd1(dir_bus)
    );

    pgu pgu[0:2] (
        .clk(clk), .update(update), .dir_in(dir_bus), .t_on(t_on_bus),
        .t_off(t_off_bus),

        .step(step), .dir_out(dir)
    );

endmodule: datapath
