`default_nettype none
`timescale 1ns / 1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb (
    // testbench is controlled by test.py
    input clk,
    input rst_n,
    input ena,
    input [3:0] SWM_arADDR,
    input [7:4] SWM_wdata ,
    input ms_arvalid,
    input ms_rready,
    input ms_awvalid,
    input ms_wvalid,
    input [3:0] bidirectional_is_input,
    output sm_arready,
    output sm_rvalid,
    output sm_awready,
    output sm_wready,
    output [7:4] bidirectional_is_output,
    output [7:0] disp_hex_r
);

  // this part dumps the trace to a vcd file that can be viewed with GTKWave
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // instantiate the DUT
  tt_um_thejesvinii_axi (
`ifdef GL_TEST
      .VPWR(1'b1),
      .VGND(1'b0),
`endif
      .ui_in({SWM_wdata, SWM_arADDR}),
      .uo_out(disp_hex_r),
      .uio_in({4'b0,ms_wvalid, ms_awvalid,ms_rready,ms_arvalid}),
      .uio_out({sm_wready,sm_awready,sm_rvalid,sm_arready,4'b0}),
      .uio_oe({bidirectional_is_output,bidirectional_is_input}),
      .ena(ena),
      .clk(clk),
      .rst_n(rst_n)
  );

endmodule
