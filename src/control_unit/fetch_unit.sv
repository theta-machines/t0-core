module fetch_unit(
    input logic clk, N_reset, update, data_ready,
    input logic [7:0] data,
    output logic done, data_request,
    output logic [7:0] instr,
    output logic [0:3][7:0] payload // 4-bytes received MSB first
);

    logic wait_flag, data_ready_posedge, data_ready_prev;
    logic [1:0] num_bytes, byte_count;

    // data_request logic
    assign data_request = ~wait_flag;

    // `data_ready` rising edge detector
    assign data_ready_posedge = data_ready & ~data_ready_prev;
    always_ff @(posedge clk) begin
        data_ready_prev <= data_ready;
    end

    // Main logic
    always_ff @(posedge clk or negedge N_reset) begin
        if(!N_reset) begin
            // Reset logic
            wait_flag <= '0;
            num_bytes <= '0;
            byte_count <= '0;
        end else if(data_ready_posedge) begin
            // Main conditional logic
            done <= '0;
            if(num_bytes == 2'd0) begin
                if(data[6] == 1'b0) begin // If op_code = 0
                    wait_flag <= 1'b1;
                    done <= 1'b1;
                end else begin
                    num_bytes <= 2'd3;
                    instr <= data;
                end
            end else begin
                payload[byte_count] <= data;
                if(byte_count == num_bytes) begin
                    num_bytes <= 2'd0;
                    byte_count <= 2'd0;
                    done <= 1'b1;
                end else begin
                    byte_count <= byte_count + 1;
                end
            end
        end else if(update) begin
            // Update logic
            wait_flag <= '0;
            done <= '0;
        end
    end

endmodule
