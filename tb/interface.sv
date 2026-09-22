interface fifo_inf #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
);

bit clk,rst;
logic [WIDTH-1:0] din;
bit wen, ren;
logic [WIDTH-1:0] dout;//output type should be always logic
logic empty,full;

initial begin
    clk=0;
    forever #5 clk = ~clk; 
end

endinterface
