import uvm_pkg::*;
import fifo_pkg::*;

module top;
    fifo_inf inf();

    fifo dut (
        .clk(inf.clk),
        .rst(inf.rst),
        .din(inf.din),
        .wen(inf.wen),
        .ren(inf.ren),
        .dout(inf.dout),
        .empty(inf.empty),
        .full(inf.full)
    );

    initial begin
      fifo_pkg::global_inf=inf;
      run_test("test1");
    end

endmodule