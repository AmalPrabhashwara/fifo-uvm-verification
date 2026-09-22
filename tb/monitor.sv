
class monitor extends uvm_monitor;
    `uvm_component_utils(monitor);

    virtual interface fifo_inf inf;

    uvm_analysis_port #(fifo_req) req_aport;
    uvm_analysis_port #(fifo_rsp) rsp_aport;

    function new(string name="monitor", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        inf=fifo_pkg::global_inf;
        req_aport=new("req_aport",this);
        rsp_aport=new("rsp_aport",this);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_req req;
        fifo_rsp rsp;
        forever begin
            req=fifo_req::type_id::create("req");
            rsp=fifo_rsp::type_id::create("rsp");
            @(posedge inf.clk);
            #1;

            req.data=inf.din;         	
            
          	if(inf.rst)
                req.op=reset;
          	else if(inf.wen && inf.ren) 
                req.op=write_read;
            else if(inf.wen)
                req.op=write;
            else if(inf.ren)
                req.op=read;
          	else
              	req.op=nop;
            
            rsp.data=inf.dout;
            if(inf.full)
                rsp.status=full;
            else if(inf.empty)
                rsp.status=empty;
            else
                rsp.status=mid;

            if(req.op != nop)begin
                req_aport.write(req);
                rsp_aport.write(rsp);
            end
        end
    endtask

endclass
