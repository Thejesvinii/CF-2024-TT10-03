/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none


module tt_um_thejesvinii_axi (
    `ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    wire [3:0] SWM_arADDR=ui_in[3:0];    // read address
    wire [3:0]SWM_wdata=ui_in[7:4]; 


  // All output pins must be assigned. If not used, assign to 0.
    // Example: ou_out is the sum of ui_in and uio_in
    assign uio_out [3:0]=4'b0;
    assign uio_in [3:0]=4'b1;
    assign uio_in[7:4]=4'b0;

    assign uio_out [7:4]= 4'b1;
    
    assign uio_oe[3:0] = 4'b0;
    assign uio_oe[7:4] = 4'b1;
    

  // List all unused inputs to prevent warnings
    wire _unused = &{ena,uio_in[4],uio_in[5],uio_in[6],uio_in[7],1'b0};

    wire disp_hex_r[7:0]=uo_out[7:0],
    

    // Address read
    wire ms_arvalid=uio_in[0],
   
    wire sm_arready=uio_out[4],
    wire ms_rready=uio_in[1],
    wire sm_rvalid=uio_out[5],

    // Write address
    wire ms_awvalid=uio_in[2],
    wire sm_awready=uio_out[6],

    // Write data (4-bit address for data)
    wire ms_wvalid=uio_in[3],
    
    wire sm_wready=uio_out[7]

    axi axi_inst(.clk(clk),.reset(rst_n),.disp_hex_r(disp_hex_r),.ms_arvalid(ms_arvalid),.SWM_arADDR(SWM_arADDR),.SWM_wdata(SWM_wdata),.sm_arready(sm_arready),.ms_rready(ms_rready),.sm_rvalid(sm_rvalid),.ms_awvalid(ms_awvalid),.sm_awready(sm_awready),.ms_wvalid(ms_wvalid),.sm_wready(sm_wready))


endmodule
