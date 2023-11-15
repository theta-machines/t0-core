/**
 * Testing strategy:
 *   - Whenever `data_request` is high, read a new byte from `fifo.bin`,
 *     wait a random amount of time, then set `data_ready` HIGH.
 */

module t0_core_tb();
    timeunit 1ns / 1ns;

    // DUT Inputs
    logic clk, N_reset, data_ready;
    logic [7:0] data;

    // DUT Outputs
    logic data_request;
    logic step [0:2];
    logic dir [0:2];

    t0_core dut(
        .clk(clk), .N_reset(N_reset), .data_ready(data_ready), .data(data),

        .data_request(data_request), .step(step), .dir(dir)
    );

    // 25MHz Clock
    initial begin
        clk = '0;
        forever #20 clk = ~clk;
    end

    // Drive inputs
    initial begin
        N_reset = 0;
        data_ready = 0;

        #20 N_reset = 1;
    end

    // Drive Inputs
    int fd;
    byte fifoByte;
    initial fd = $fopen("fifo.bin", "r");
    always @(posedge clk) begin
        if($feof(fd)) begin
            data_ready = 0;
        end else if(data_request) begin
            data_ready = 0;

            // Wait 1.5 clock cycles
            #60;

            data = $fgetc(fd);
            data_ready = 1;

            $display("%h", data);
        end
    end

endmodule
