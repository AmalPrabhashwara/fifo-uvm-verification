
class test_env extends uvm_env;
    `uvm_component_utils(test_env);

    agent agent_h;
    scoreboard sb;
	coverage cov;
    // coverage2 cov2;

    function new(string name="test_env", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        agent_h=agent::type_id::create("agent_h",this);
        sb=scoreboard::type_id::create("sb",this);
        cov=coverage::type_id::create("cov",this);
        // cov2=coverage2::type_id::create("cov2",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agent_h.req_aport.connect(sb.req_afifo.analysis_export);
        agent_h.rsp_aport.connect(sb.rsp_afifo.analysis_export);
        // agent_h.req_aport.connect(cov.analysis_export);
        agent_h.req_aport.connect(cov.req_afifo.analysis_export);
        agent_h.rsp_aport.connect(cov.rsp_afifo.analysis_export);
    endfunction

endclass
