`timescale 1ns / 1ps

module tb();

  // Clock and Reset
  reg clk;
  reg rst_n;

  // AXI Signals
  reg [3:0] SWM_arADDR;
  reg [3:0] SWM_wdata;
  reg ms_arvalid;
  reg ms_rready;
  reg ms_awvalid;
  reg ms_wvalid;
  
  wire sm_arready;
  wire sm_rvalid;
  wire sm_awready;
  wire sm_wready;
  wire [7:0] disp_hex_r;
  wire [3:0] sm_unused;  // Define a signal for unused bits

  // Clock Generation
  always #5 clk = ~clk;  // 10ns clock period (100MHz)

  // Instantiate DUT (Device Under Test)
  tt_um_thejesvinii_axi uut (
    .clk(clk),
    .rst_n(rst_n),
    .ui_in({SWM_wdata, SWM_arADDR}),  // Assign write data to upper bits of ui_in
    .uo_out(disp_hex_r),              // Assign display output
    .uio_in({1'b0, 4'b0000, ms_wvalid, ms_awvalid, ms_rready, ms_arvalid}), // Ensure correct bit-width
    .uio_out({sm_wready, sm_awready, sm_rvalid, sm_arready, sm_unused}),  // Use sm_unused instead of 4'd0
    .uio_oe(),                        // Output enable not used
    .ena(1'b1)                         // Always enabled
  );

  // Unused bits assignment
  assign sm_unused = 4'b0000;  // Prevents unconnected warnings

  // Test Sequence
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    // Initialize Inputs
    clk = 0;
    rst_n = 1;
    ms_arvalid = 0;
    SWM_arADDR = 0;
    ms_rready = 0;
    ms_awvalid = 0;
    ms_wvalid = 0;
    SWM_wdata = 0;

    // Reset Pulse
    #10 rst_n = 0;
    #10 rst_n = 1;

    // Read from Address 3
    #20 ms_arvalid = 1;
    SWM_arADDR = 4'd3;
    #10 ms_arvalid = 0;
    ms_rready = 1;
    #10 ms_rready = 0;

    // Write value at Address 3
    #10 ms_awvalid = 1;
    SWM_arADDR = 4'd3;
    ms_wvalid = 1;
    SWM_wdata = 4'd4; // Store value from Address 4 into Address 3
    #10 ms_awvalid = 0;
    ms_wvalid = 0;

    // Read from Address 4
    #20 ms_arvalid = 1;
    SWM_arADDR = 4'd4;
    #10 ms_arvalid = 0;
    ms_rready = 1;
    #10 ms_rready = 0;

    // End Simulation
    #50 $finish;
  end

endmodule
