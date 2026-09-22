module fifo
#(
    parameter DEPTH=16,
    parameter WIDTH=8
)(
    input logic clk,rst,
    input logic [WIDTH-1:0]din,
    input logic wen,ren,
    output logic [WIDTH-1:0]dout,
    output logic empty,full
);
logic [WIDTH-1:0] mem [0:DEPTH-1];//unpacked array
logic [$clog2(DEPTH):0] wCnt;
logic [$clog2(DEPTH):0] rCnt;

always_ff @(posedge clk)begin
    if(rst)begin
        wCnt<=0;
        rCnt<=0;
        for(int i=0; i<DEPTH; i++)begin
            mem[i]<=0;
        end
    end
    else begin
      if(!full && wen)begin
            mem[wCnt[$clog2(DEPTH)-1:0]]<=din;
            wCnt<=wCnt+1;
        end
      if(!empty && ren)begin
            dout<=mem[rCnt[$clog2(DEPTH)-1:0]];
            rCnt<=rCnt+1;
        end
    end
end

assign full=(wCnt[$clog2(DEPTH)]!=rCnt[$clog2(DEPTH)])&&(wCnt[$clog2(DEPTH)-1:0]==rCnt[$clog2(DEPTH)-1:0]);
assign empty=(wCnt==rCnt);

property rst_cnt;
  @(posedge clk) rst|=> (wCnt==0 && rCnt==0);
endproperty

assert property(rst_cnt) else $error("failed assertion: wCnt is not zero when reset is asserted");

function bit memrst();
    for(int i=0;i<DEPTH;i++)begin
      if(mem[i]!=0)
            return 0;
    end
    return 1;
endfunction

property rst_fifo;
    @(posedge clk) rst |=> memrst();
endproperty

assert property(rst_fifo) else $error("failed assertion: FIFO content is not cleared when FIFO reset");

property wr_fifo;
    int index;
    int data;
    @(posedge clk) disable iff(rst)
  (wen && !full,index=wCnt,data=din) |=> mem[index]==data;
endproperty

assert property(wr_fifo) else $error("fifo write failed");

endmodule