/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`timescale 1ns/1ps

module tt_um_thejesvinii_axi (
   
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, ignore
    input  wire       clk,      // Clock
    input  wire       rst_n     // Active-low reset
);
    assign uio_out[3:0] = 4'b0000; // Fix: Prevent undriven warning
   assign uio_in[7:4] = 4'b0000; // Fix: Prevent undriven warning

    // Read and Write Addressing
    wire [3:0] SWM_arADDR = ui_in[3:0];   // Read address from switches
    wire [3:0] SWM_wdata  = ui_in[7:4];   // Write data from switches

    // AXI Handshake Signals
    wire ms_arvalid = uio_in[0]; // Read request
    wire ms_rready  = uio_in[1]; // Read ready
    wire ms_awvalid = uio_in[2]; // Write address valid
    wire ms_wvalid  = uio_in[3]; // Write data valid

    wire sm_arready;
    wire sm_rvalid;
    wire sm_awready;
    wire sm_wready;

    // Output assignments
    assign uio_out[4] = sm_arready;
    assign uio_out[5] = sm_rvalid;
    assign uio_out[6] = sm_awready;
    assign uio_out[7] = sm_wready;

    // Assign Output Enables (Active High)
    assign uio_oe = 8'b11110000; // Only upper bits are outputs

    // Prevent Unused Signal Warnings
    wire _unused = &{ena, uio_in[7:4],uio_out[3:0], 1'b0};

    // Instantiate AXI Logic Module
    axi axi_inst (
        .clk(clk),
        .reset(rst_n),
        .disp_hex_r(uo_out), // 7-segment output
        .ms_arvalid(ms_arvalid),
        .SWM_arADDR(SWM_arADDR),
        .SWM_wdata(SWM_wdata),
        .sm_arready(sm_arready),
        .ms_rready(ms_rready),
        .sm_rvalid(sm_rvalid),
        .ms_awvalid(ms_awvalid),
        .sm_awready(sm_awready),
        .ms_wvalid(ms_wvalid),
        .sm_wready(sm_wready)
    );

endmodule
