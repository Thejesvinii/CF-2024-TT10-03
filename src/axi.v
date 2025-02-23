`default_nettype none

module axi (
    `ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
    `endif
    input clk,
    input reset,
    output reg [7:0] disp_hex_r,

    // Read Interface
    input ms_arvalid,
    input [3:0] SWM_arADDR,
    output reg sm_arready,
    input ms_rready,
    output reg sm_rvalid,

    // Write Interface
    input ms_awvalid,
    output reg sm_awready,
    input ms_wvalid,
    input [3:0] SWM_wdata,
    output reg sm_wready
);

    reg [3:0] read_address;
    reg [7:0] memory_w [0:15];
    reg [7:0] LED_out;

    // Memory Initialization
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1)
            memory_w[i] = i;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sm_arready <= 1'b0;
            sm_rvalid  <= 1'b0;
            sm_awready <= 1'b0;
            sm_wready  <= 1'b0;
            disp_hex_r <= 8'd0;
            read_address <= 4'b0;
        end else begin
            // Read Operation
            if (ms_arvalid) begin
                sm_arready <= 1'b1;
                read_address <= SWM_arADDR;
            end else begin
                sm_arready <= 1'b0;
            end

            if (ms_arvalid && sm_arready) begin
                sm_rvalid <= 1'b1;
            end

            if (sm_rvalid && ms_rready) begin
                disp_hex_r <= LED_out;
                sm_rvalid <= 1'b0;
            end

            // Write Operation
            if (ms_awvalid) begin
                sm_awready <= 1'b1;
            end else begin
                sm_awready <= 1'b0;
            end

            if (ms_wvalid && sm_awready) begin
                memory_w[read_address] <= memory_w[SWM_wdata];
                sm_wready <= 1'b1;
            end else begin
                sm_wready <= 1'b0;
            end
        end
    end

    always @(*) begin
        case (memory_w[read_address])
            8'd0: LED_out = 8'b00000011;
            8'd1: LED_out = 8'b10011111;
            8'd2: LED_out = 8'b00100101;
            8'd3: LED_out = 8'b00001101;
            8'd4: LED_out = 8'b10011001;
            8'd5: LED_out = 8'b01001001;
            8'd6: LED_out = 8'b01000001;
            8'd7: LED_out = 8'b00011111;
            8'd8: LED_out = 8'b00000001;
            8'd9: LED_out = 8'b00001001;
            default: LED_out = memory_w[read_address];
        endcase
    end

endmodule
