timescale 1ns / 1ps

module axi(
    input clk,
    input reset,
    output reg [7:0] disp_hex_r,
    output reg [3:0] an,
   // output reg [7:0] disp_hex_w,
    // Address read
    input ms_arvalid, // switch
    input [3:0] SWM_arADDR,
    output reg ms_arready,
    // Read data
    input ms_rvalid, // switch
    output reg ms_rready, // LED
    // Write address
    input ms_awvalid, // switch
    //input [3:0] SWM_awADDR,
    output reg ms_awready, // LED
    // Write data
    input ms_wvalid, // switch
    input [7:0] SWM_wdata,
    output reg ms_wready, // LED
    // Write response
    output reg [1:0] ms_bresp,
    input sm_bwready
);
reg  sm_bwvalid;
    reg [3:0] ms_araddr, ms_awaddr;
    reg [7:0] read_data;
    reg [7:0] memory_w [0:15];
    reg [7:0] LED_out;
    // Memory for storage
    // Initialize memory with all zeros
        integer i;
        initial begin
            for (i = 0; i < 16; i = i + 1)
                memory_w[i] = i;
        end
   
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ms_araddr <= 4'd0;
            ms_awaddr <= 4'd0;
            ms_rready <= 1'b0;
            ms_awready <= 1'b0;
            ms_wready <= 1'b0;
            sm_bwvalid <= 1'b0;
            ms_bresp <= 2'b00;
            disp_hex_r <= 8'd0;
            an <= 4'b0001;
           // disp_hex_w <= 8'd0;
        end else begin
            // Read operation
            if (ms_arvalid) begin
                ms_arready<=1'b1;
                if(ms_arvalid && ms_arready)
                ms_araddr <= SWM_arADDR;
                ms_rready <= 1'b1;
            end
            if (ms_rvalid && ms_rready) begin
                disp_hex_r <= LED_out;
                ms_rready <= 1'b0;
            end
     
            // Write operation
            if (ms_awvalid) begin  
                ms_awready <= 1'b1;
            end
            if (ms_awready && ms_awvalid) begin
              ms_awaddr <= SWM_arADDR;
              ms_awready <= 1'b0;
            end
           
            if (ms_wvalid) begin
               if(ms_awaddr!=ms_araddr)
                ms_wready <= 1'b1;
            end
           
            if (ms_wready && ms_wvalid) begin
                memory_w[ms_awaddr] <= SWM_wdata;
                //disp_hex_w <= memory_w[ms_awaddr];
                sm_bwvalid <= 1'b1;
            end
            if (sm_bwready && sm_bwvalid) begin
                ms_bresp <= 2'b11;
            end
        end
    end


always @(*)
begin
 case(memory_w[ms_araddr])
 8'd0: LED_out = 7'b0000001; // "0"  
 8'd1: LED_out = 7'b1001111; // "1"
 8'd2: LED_out = 7'b0010010; // "2"
 8'd3: LED_out = 7'b0000110; // "3"
 8'd4: LED_out = 7'b1001100; // "4"
 8'd5: LED_out = 7'b0100100; // "5"
 8'd6: LED_out = 7'b0100000; // "6"
 8'd7: LED_out = 7'b0001111; // "7"
 8'd8: LED_out = 7'b0000000; // "8"  
 8'd9: LED_out = 7'b0000100; // "9"
 default: LED_out = 7'b0000001; // "0"
 endcase
end

endmodule
