# AXI  Documentation

## 1. Overview
The `tt_um_thejesvinii_axi` module is an AXI-like master interface implemented for FPGA-based communication. It supports basic read and write operations to an internal memory array and outputs data to a 7-segment display. The design uses a 4-bit addressing scheme and an 8-bit data representation.

## 2. How it works:
This module performs the following key functions:

### 2.1 Memory Read Operation
- The `ms_arvalid` signal initiates a read request.
- The `SWM_arADDR` input provides the read address through swiches.
- The module asserts `sm_arready` to indicate readiness.
- When `ms_rready` is high, data from the memory is output to `disp_hex_r`, and `sm_rvalid` is asserted.

### 2.2 Memory Write Operation
- The `ms_awvalid` signal initiates a write request.
- The `SWM_arADDR` input provides the write address through swiches(initial read address will be the write address now, we perfrom overwriting due to limited pins).
- The `SWM_wdata` input specifies the address of data to be written to address provided by SWM_arADDR.
- The module asserts `sm_awready` when the write address is valid.
- If `ms_wvalid` is high, data from `memory_w[SWM_wdata]` is written to `memory_w[read_address]`.
- The `sm_wready` signal is asserted to indicate completion.

### 2.3 7-Segment Display Output
- The `disp_hex_r` output displays the data from the memory based on the last read address.
- The segment encoding for numbers 0-9 is pre-defined.

## 3. Signal Description

| Signal         | Direction | Width | Description |
|---------------|----------|-------|-------------|
| clk           | Input    | 1-bit | System clock |
| reset         | Input    | 1-bit | Active-high reset |
| disp_hex_r    | Output   | 8-bit | 7-segment display output |
| ms_arvalid   | Input    | 1-bit | Read request valid |
| SWM_arADDR   | Input    | 4-bit | Read address |
| sm_arready   | Output   | 1-bit | Read ready signal |
| ms_rready    | Input    | 1-bit | Read acknowledge |
| sm_rvalid    | Output   | 1-bit | Read valid response |
| ms_awvalid   | Input    | 1-bit | Write address valid |
| sm_awready   | Output   | 1-bit | Write address ready |
| ms_wvalid    | Input    | 1-bit | Write data valid |
| SWM_wdata    | Input    | 4-bit | Write data source address |
| sm_wready    | Output   | 1-bit | Write ready response |

## 4. How to Test the Module



### 4.1 Read Operation Test
1. Set `ms_arvalid` to 1 and provide an address via `SWM_arADDR`.
2. Assert `ms_rready` and check if `sm_rvalid` goes high.
3. Verify that `disp_hex_r` matches the expected value from `memory_w`.

### 4.2 Write Operation Test
1. Set `ms_awvalid` to 1 and provide an address via `SWM_arADDR`(the read addr would now become a write addr).
2. Set `ms_wvalid` and provide `SWM_wdata`.
3. Check if `memory_w[read_address]` is updated with `memory_w[SWM_wdata]`.
4. Ensure `sm_wready` is asserted after a successful write.

### 4.3 Display Test to ensure write operation
1. Perform a read operation again and verify `disp_hex_r` output on a 7-segment display to see the overwritten data.


## 5. Expected Outputs
- The 7-segment display should update based on read data.
- Memory should reflect expected values after write operations.
- Control signals (`sm_arready`, `sm_awready`, etc.) should follow expected behavior.

## 6. Conclusion
This module provides a simple AXI-like master interface for an FPGA. It supports basic read/write operations and outputs data to a 7-segment display. Proper verification ensures correct operation in an FPGA environment.

