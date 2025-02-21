`timescale 1ns / 1ps

module axi_tb();

    // Testbench signals
    reg clk;
    reg reset;
    wire [7:0] disp_hex_r;

    // AXI read signals
    reg ms_arvalid;
    reg [3:0] SWM_arADDR;
    wire sm_arready;
    reg ms_rready;
    wire sm_rvalid;

    // AXI write signals
    reg ms_awvalid;
    wire sm_awready;
    reg ms_wvalid;
    reg [3:0] SWM_wdata;
    wire sm_wready;

    // Instantiate the DUT (Device Under Test)
    tt_um_thejesvinii_axi uut (
        .clk(clk),
        .reset(reset),
        .disp_hex_r(disp_hex_r),
        .ms_arvalid(ms_arvalid),
        .SWM_arADDR(SWM_arADDR),
        .sm_arready(sm_arready),
        .ms_rready(ms_rready),
        .sm_rvalid(sm_rvalid),
        .ms_awvalid(ms_awvalid),
        .sm_awready(sm_awready),
        .ms_wvalid(ms_wvalid),
        .SWM_wdata(SWM_wdata),
        .sm_wready(sm_wready)
    );

    // Clock generation
    always #5 clk = ~clk; // 10 ns clock period

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        ms_arvalid = 0;
        SWM_arADDR = 4'b0000;
        ms_rready = 0;
        ms_awvalid = 0;
        ms_wvalid = 0;
        SWM_wdata = 4'b0000;

        // Reset phase
        #20 reset = 0;

        // Write operation test
        #10 ms_awvalid = 1; SWM_arADDR = 4'b0010; // Target write address
        #10 ms_wvalid = 1; SWM_wdata = 4'b0100;  // Data source address
        #10 ms_awvalid = 0; ms_wvalid = 0; // Deassert signals

        // Read operation test
        #20 ms_arvalid = 1; SWM_arADDR = 4'b0010; // Read from written address
        #10 ms_rready = 1;
        #10 ms_arvalid = 0;
        #10 ms_rready = 0;

        // Observe `disp_hex_r` for expected value
        #50;

        // End simulation
        $finish;
    end

    // Dump waveform for GTKWave
    initial begin
        $dumpfile("axi_tb.vcd");
        $dumpvars(0, axi_tb);
    end

endmodule
