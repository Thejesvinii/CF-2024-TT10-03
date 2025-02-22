

 ## How it works
The `tt_um_thejesvinii_axi` module is an AXI-like master interface implemented for FPGA-based communication. It supports basic read and write operations to an internal memory array and outputs data to a 7-segment display. The design uses a 4-bit addressing scheme and an 8-bit data representation.
This module performs the following key functions:

 Memory Read Operation
- The ms_arvalid `uio_in[0]` signal initiates a read request.
- The SWM_arADDR `ui_in[3:0]` input provides the read address through swiches.
- The module asserts sm_arready `uio_out[4]` to indicate readiness.
- When ms_rready `uio_in[1]` is high, data from the memory is output to disp_hex_r `uo_out[7:0]`, and sm_rvalid `uio_out[5]` is asserted.

 Memory Write Operation
- The ms_awvalid `uio_in[2]` signal initiates a write request.
- The SWM_arADDR `ui_in[3:0]` input provides the write address through swiches(initial read address will be the write address now, we 
  perfrom overwriting due to limited pins).
- The SWM_wdata `ui_in[7:4]` input specifies the address of data to be written to address provided by SWM_arADDR.
- The module asserts sm_awready'uio_out[6] when the write address is valid.
- If ms_wvalid `uio_in[3]` is high, data from `memory_w[SWM_wdata]` is written to `memory_w[read_address]`.
- The sm_wready `uio_out[7]` signal is asserted to indicate completion.

  7-Segment Display Output
- The `disp_hex_r` output displays the data from the memory based on the last read address.
- The segment encoding for numbers 0-9 is pre-defined.

 
##  How to Test 

Read Operation Test
- Set `ms_arvalid` to 1 and provide an address via `SWM_arADDR`.
- Assert `ms_rready` and check if `sm_rvalid` goes high.
- Verify that `disp_hex_r` matches the expected value from `memory_w`.

Write Operation Test
- Set `ms_awvalid` to 1 and provide an address via `SWM_arADDR`(the read addr would now become a write addr).
- Set `ms_wvalid` and provide `SWM_wdata`.
- Check if `memory_w[read_address]` is updated with `memory_w[SWM_wdata]`.
- Ensure `sm_wready` is asserted after a successful write.

Display Test to ensure write operation
- Perform a read operation again and verify `disp_hex_r` output on a 7-segment display to see the overwritten data.

Expected Outputs
- The 7-segment display should update based on read data.
- Memory should reflect expected values after write operations.
- Control signals (`sm_arready`, `sm_awready`, etc.) should follow expected behavior.



