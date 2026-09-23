class driver extends uvm_driver #(fifo_req,fifo_rsp);
    `uvm_component_utils(driver);

    virtual interface fifo_inf inf;
// 	int drvCnt;
      
    function new(string name="driver", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        inf=fifo_pkg::global_inf;
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            fifo_req req;
            @(negedge inf.clk);
            seq_item_port.get_next_item(req);
//           `uvm_info("Driver",$psprintf("%s",req.convert2string),UVM_MEDIUM);
          	inf.din=req.data;
          	inf.wen=0;
          	inf.ren=0;
            case(req.op)
                reset:begin
                    inf.rst=1;
//                   	inf.din=req.data;
                    @(negedge inf.clk);
                    inf.rst=0;
                end
                write:begin
                    inf.wen=1;
                    inf.ren=0;
                    // inf.din=req.data;
                end 
                read:begin
                    inf.wen=0;
                    inf.ren=1;
                end
                write_read:begin
                    inf.wen=1;
                    inf.ren=1;
                    // inf.din=req.data;
                    // inf.dout=rsp.data;
                end
                nop:begin
                    inf.wen=0;
                    inf.ren=0;
                end

            endcase
//             inf.din=req.data;
//           `uvm_info("Driver",$psprintf("req:%s, wen:%b, ren:%b at time:%t",req.convert2string,inf.wen,inf.ren,$time),UVM_MEDIUM);
            seq_item_port.item_done();
//             drvCnt++;
        end
    endtask
endclass
