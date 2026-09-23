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

# Verification Plan

## Feature 1: Reset behaviour 

### Test- Test3
- Test reset behavior before fifo write start
- Test reset behavior while write

### What to test-
- Write counters and read counters goes to zero
- FIFO gets cleared

### How to verify-

#### Assertions: 
- rst_cnt - wrCnt and rdCnt are zero when rst is asserted
- rst_fifo - fifo contents are zero when rst is asserted

#### Functional coverage: 
- cp_write_rst - Check whether test performs reset operation after valid fifo write 

## Feature 2 - Write operation

### Test- Test3

### What to test-
- When wen is high and FIFO is not full, the data on din is written into the FIFO.
- Write counter is increment by one for each write
- No write when fifo is full

### How to test-
#### Assertion : 
- wr_fifo - The data on din is written into the FIFO When wen is high and FIFO is not full, 
- wr_cnt_incr - Increment wCnt by one for each valid write
- wr_full - No wCnt increments when fifo is full

#### Functional coverage
- cp_op_wr - check whether test performs write fifo
- cp_wr_full - check whether test performs write when fifo is full


## Feature 3 - Read operation

### Test- test1

### What to test-
- FIFO reads when ren is high and not empty
- Read counter increments by one for each read
- No read when fifo is empty

### How to test-
#### Scoreboard-
Check the correctness of the read data from FIFO. It checks whether dout is same as din in the same order data written.

#### Assertions-
- rd_cnt_incr : Incrementing read counter by one for each valid read
- rd_empty : No read counter is incrementing when fifo is empty

#### Functional Coverage-
- cp_op_rd : Cover read operation
- cp_rd_empty : Cover read operation when fifo is empty

## Feature 4- Simultanious write read

### Test- test4

### What to test
- FIFO write and read when both wen and ren are high

### How to verify-
- Scoreboard
- Functional coverage:
cp_wr_rd- Cover simultanious write read operations

## Feature 5- Random write read

### Test- test2

### What to test
- Perform random operation write read reset operations

### How to verify-
- Scoreboard
- Functional coverage: 
cp_op- Cover all operations



















