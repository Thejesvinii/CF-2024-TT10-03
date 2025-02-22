import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_axi(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut._log.info("ena")
    dut.ena.value = 1

    dut._log.info("reset")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    
    assert int(dut.bidirectional_is_output.value) == 0
    assert int(dut.bidirectional_is_input.value) == 1


    dut._log.info("READ OPERATION")
    dut.ms_arvalid=1
    dut.SWM_arADDR.value = 3
    await ClockCycles(dut.clk, 1)
    dut.ms_rready = 1
    await ClockCycles(dut.clk, 1)
    dut.ms_arvalid = 0
    dut.ms_rready = 0
    await ClockCycles(dut.clk, 2)
    assert int(dut.disp_hex_r.value) == 3

    dut._log.info("WRITE OPERATION")
    dut.ms_awvalid=1
    dut.SWM_arADDR.value = 3
    await ClockCycles(dut.clk, 1)
    dut.SWM_wdata.value = 4
    dut.ms_wvalid = 1
    await ClockCycles(dut.clk, 1)
    dut.ms_awvalid = 0
    dut.ms_wvalid = 0
    await ClockCycles(dut.clk, 2)
   
   
    dut._log.info("READ AGAIN TO VERIFY OVERWRITTEN DATA")
    dut.ms_arvalid=1
    dut.SWM_arADDR.value = 4
    await ClockCycles(dut.clk, 1)
    dut.ms_rready = 1
    await ClockCycles(dut.clk, 1)
    dut.ms_arvalid = 0
    dut.ms_rready = 0
    await ClockCycles(dut.clk, 2)
    assert int(dut.disp_hex_r.value) == 4

   

    dut._log.info("all good!")
