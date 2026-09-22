package fifo_pkg;
    import uvm_pkg::*;
    `include "agent.sv"
    `include "coverage.sv"
    `include "driver.sv"
    `include "env.sv"
    `include "monitor.sv"
    `include "scoreboard.sv"
    `include "sequence.sv"
    `include "test.sv"
    `include "transaction.sv"

    virtual interface fifo_inf global_inf;
    typedef enum {write,read,write_read,reset,nop} op_t;
    typedef enum {full,empty,mid} stat_t;

endpackage