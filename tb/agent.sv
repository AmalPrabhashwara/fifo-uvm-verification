class agent extends uvm_agent;
    `uvm_component_utils(agent);

    uvm_sequencer #(fifo_req,fifo_rsp) seqr;
    driver drv;
    monitor mon;

    uvm_analysis_port #(fifo_req) req_aport;
    uvm_analysis_port #(fifo_rsp) rsp_aport;
   
    function new(string name="agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        seqr=new("seqr",this);
        drv=driver::type_id::create("drv",this);
        mon=monitor::type_id::create("mon",this);
        req_aport=new("req_aport",this);
        rsp_aport=new("rsp_aport",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
        mon.req_aport.connect(req_aport);
        mon.rsp_aport.connect(rsp_aport);
    endfunction

endclass
