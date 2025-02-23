## How It Works
The `tt_um_thejesvinii_axi` module is an AXI-like master interface implemented for FPGA-based communication. It supports basic read and write operations to an internal memory array and outputs data to a 7-segment display. The design uses a **4-bit address space** and **8-bit data representation**.

### Key Functions:

### **Memory Read Operation**
- The **`ms_arvalid`** (`uio_in[0]`) signal initiates a read request.
- The **`SWM_arADDR`** (`ui_in[3:0]`) input provides the read address through switches.
- The module asserts **`sm_arready`** (`uio_out[4]`) to indicate readiness.
- When **`ms_rready`** (`uio_in[1]`) is high, data from the memory is output to **`disp_hex_r`** (`uo_out[7:0]`), and **`sm_rvalid`** (`uio_out[5]`) is asserted.

### **Memory Write Operation**
- The **`ms_awvalid`** (`uio_in[2]`) signal initiates a write request.
- The **`SWM_arADDR`** (`ui_in[3:0]`) input provides the write address through switches.
- The **`SWM_wdata`** (`ui_in[7:4]`) input specifies the **data** to be written at `SWM_arADDR`.
- The module asserts **`sm_awready`** (`uio_out[6]`) when the write address is valid.
- If **`ms_wvalid`** (`uio_in[3]`) is high, **data from `SWM_wdata` is written to the memory at `SWM_arADDR`**.
- The **`sm_wready`** (`uio_out[7]`) signal is asserted to indicate write completion.

### **7-Segment Display Output**
- The **`disp_hex_r`** output displays the data from memory based on the last read address.
- The segment encoding supports numbers **0-9**.

---

## **How to Test**

### **Read Operation Test**
1. Set **`ms_arvalid`** to `1` and provide an address via **`SWM_arADDR`**.
2. Assert **`ms_rready`** (`uio_in[1]`) and check if **`sm_rvalid`** (`uio_out[5]`) goes high.
3. Verify that **`disp_hex_r`** matches the expected value from memory.

### **Write Operation Test**
1. Set **`ms_awvalid`** to `1` and provide an address via **`SWM_arADDR`**.
2. Set **`ms_wvalid`** (`uio_in[3]`) and provide data via **`SWM_wdata`**.
3. Check if **`memory_w[SWM_arADDR]` is updated with `SWM_wdata`**.
4. Ensure **`sm_wready`** (`uio_out[7]`) is asserted after a successful write.

### **Verify Write by Performing Read**
1. Perform a **read operation** at the same address.
2. Confirm that **`disp_hex_r`** displays the newly written data.

---

## **Expected hardware**
✔ **7-segment display updates based on read data.**  
✔ **Memory values change correctly after write operations.**  
✔ **Control signals (`sm_arready`, `sm_awready`, etc.) behave as expected.**
