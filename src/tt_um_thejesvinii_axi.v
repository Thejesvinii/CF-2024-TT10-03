'timescale 1ns / 1ps

module tt_um_thejesvinii_axi(
    input clk,
    input reset,
    output reg [7:0] disp_hex_r,
    

    // Address read
    input ms_arvalid,
    input [3:0] SWM_arADDR, // Write address
    output reg sm_arready,
    input ms_rready,
    output reg sm_rvalid,

    // Write address
    input ms_awvalid,
    output reg sm_awready,

    // Write data (4-bit address for data)
    input ms_wvalid,
    input [3:0] SWM_wdata,
    output reg sm_wready
);

    reg [3:0] read_address; // readAddress and Address where data will be written
reg [7:0] memory_w [0:15]; // Memory array
reg [7:0] LED_out; // Output for LEDs

// Memory Initialization
integer i;
initial begin
    for (i = 0; i < 16; i = i + 1)
        memory_w[i] = i; // Initialize memory with some values
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sm_arready <= 1'b0;
        sm_rvalid <= 1'b0;
        sm_awready <= 1'b0;
        sm_wready <= 1'b0;
        disp_hex_r <= 8'd0;
        read_address <= 4'b0;
       
    end else begin
        // Read operation (Only if no write is happening)
        if (ms_arvalid) begin
            sm_arready <= 1'b1;
            read_address <= SWM_arADDR; // Set write address from input
        end

        if(ms_arvalid && sm_arready)begin
            sm_rvalid <= 1'b1;
        end

        if (sm_rvalid && ms_rready) begin
            disp_hex_r <= LED_out; // Output the value from memory based on read address
            sm_arready <= 1'b0; // Reset ready signal after read operation
        end

        if (!ms_rready) begin
            sm_rvalid <= 1'b0; // Reset read valid signal when not ready
        end

        // Write operation
        if (ms_awvalid) begin
            sm_awready <= (SWM_arADDR != 4'b0000); // Indicate ready for address writing
        end else begin
            sm_awready <= 1'b0; // Deassert when not valid
        end

        if (ms_wvalid && sm_awready) begin
            // Use SWM_wdata as an index to fetch data from memory and write it to the specified address
            memory_w[read_address] <= memory_w[SWM_wdata]; // Write data from specified address into the target address
            sm_wready <= 1'b1; // Indicate write complete
        end else begin
            sm_wready <= 1'b0; // Deassert when not valid
        end
    end
end

// LED Output Mapping based on memory contents at the current read address.
always @(*) begin
    case(memory_w[read_address])
        8'd0: LED_out = 8'b00000011; // "0"
        8'd1: LED_out = 8'b10011111; // "1"
        8'd2: LED_out = 8'b00100101; // "2"
        8'd3: LED_out = 8'b00001101; // "3"
        8'd4: LED_out = 8'b10011001; // "4"
        8'd5: LED_out = 8'b01001001; // "5"
        8'd6: LED_out = 8'b01000001; // "6"
        8'd7: LED_out = 8'b00011111; // "7"
        8'd8: LED_out = 8'b00000001; // "8"
        8'd9: LED_out = 8'b00001001; // "9"
        default: LED_out = memory_w[read_address]; // Default to current value in memory at the specified address.
    endcase
end

endmodule
