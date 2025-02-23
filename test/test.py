import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

@cocotb.test()
async def test_axi(dut):
    dut._log.info("Starting AXI Testbench")
    
    # Start Clock
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Enable
    dut.ena.value = 1

    # Reset
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # Check if `uio_oe` is set correctly
    assert int(dut.uio_oe.value) == 0xF0  # Upper 4 bits should be outputs

    dut._log.info("READ OPERATION")
    dut.ms_arvalid.value = 1
    dut.SWM_arADDR.value = 3
    await ClockCycles(dut.clk, 1)
    dut.ms_rready.value = 1
    await ClockCycles(dut.clk, 1)
    dut.ms_arvalid.value = 0
    dut.ms_rready.value = 0
    await ClockCycles(dut.clk, 2)

    # Wait for `sm_rvalid` before reading
    while dut.sm_rvalid.value == 0:
        await RisingEdge(dut.clk)
    
    assert int(dut.disp_hex_r.value) == 3

    dut._log.info("WRITE OPERATION")
    dut.ms_awvalid.value = 1
    dut.SWM_arADDR.value = 3
    await ClockCycles(dut.clk, 1)
    dut.SWM_wdata.value = 4
    dut.ms_wvalid.value = 1
    await ClockCycles(dut.clk, 1)
    dut.ms_awvalid.value = 0
    dut.ms_wvalid.value = 0
    await ClockCycles(dut.clk, 2)

    dut._log.info("READ AGAIN TO VERIFY OVERWRITTEN DATA")
    dut.ms_arvalid.value = 1
    dut.SWM_arADDR.value = 4
    await ClockCycles(dut.clk, 1)
    dut.ms_rready.value = 1
    await ClockCycles(dut.clk, 1)
    dut.ms_arvalid.value = 0
    dut.ms_rready.value = 0
    await ClockCycles(dut.clk, 2)

    # Wait for `sm_rvalid` before reading
    while dut.sm_rvalid.value == 0:
        await RisingEdge(dut.clk)

    assert int(dut.disp_hex_r.value) == 4

    dut._log.info("All tests passed successfully!")
