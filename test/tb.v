`default_nettype none
`timescale 1ns / 1ps

module tb (
    input clk,
    input rst_n,
    input ena,
    input [3:0] SWM_arADDR,
    input [3:0] SWM_wdata, 
    input ms_arvalid,
    input ms_rready,
    input ms_awvalid,
    input ms_wvalid,
    output sm_arready,
    output sm_rvalid,
    output sm_awready,
    output sm_wready,
    output [7:0] disp_hex_r
);

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Instantiate DUT
  tt_um_thejesvinii_axi uut (
`ifdef GL_TEST
      .VPWR(1'b1),
      .VGND(1'b0),
`endif
      .ui_in({SWM_wdata, SWM_arADDR}),
      .uo_out(disp_hex_r),
      .uio_in({4'b0, ms_wvalid, ms_awvalid, ms_rready, ms_arvalid}),
      .uio_out({sm_wready, sm_awready, sm_rvalid, sm_arready, 4'b0}),
      .uio_oe(8'b11110000), // Correct `uio_oe`
      .ena(ena),
      .clk(clk),
      .rst_n(rst_n)
  );

endmodule
