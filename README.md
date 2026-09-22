# FIFO-UVM-Verification
uvm based system verilog testbench for verification of a synchronous fifo. 

# Introduction
FIFO stands for First In First Out. It is a memory based circuit that can stores data temperaly. It stores data in the order it received and output in the same oder. In a synchronous fifo Data write and read speeds are same and therefore it involves only one clock. There are counters that points where to write and read in fifo and status signals for showing the full and empty status of the fifo. 

# FIFO Design Specification

### Parameters

- width-8
- depth-16

### Inputs

- clk: clock signal
- rst: Reset the fifo. Active high reset.
- din: 8 bit width fifo Write data
- wen: 1 bit signal that anable write fifo
- ren: 1 bit signal that enable read fifo

### Outputs 

- dout: 8 bit width fifo read data
- full: 1 bit signal that indicate fifo is full
- empty: 1 bit signal that indicates fifo is empty

### Behaviour

- Reset: write counter and read counter goes to zero. Clear the fifo.
- Write: FIFO write When wen is high and fifo is not full.
- Read: FIFO read When ren is high and fifo is not empty.
- Full: The full flag is asserted when the difference between the write counter and read counter is equal to the FIFO depth. This condition can be implemented without performing an explicit subtraction by comparing the most significant bits (MSBs) of the write and read counters for inequality and checking for equality between their remaining bits. This approach avoids the additional logic required for subtraction.
- Empty: Empty flag is asserted when the write counter and read counter are equal.

# Testbench Architecture

<img src=".\Diagram\fifo_uvm_tb.png" alt="Alt Text" width="500">











