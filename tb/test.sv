
class test1 extends uvm_test;
    `uvm_component_utils(test1);

    test_env env;

    function new(string name="test1", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        env=test_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
        rst_write_read seq;
        seq=rst_write_read::type_id::create("seq");
        phase.raise_objection(this);
        seq.start(env.agent_h.seqr);
        phase.drop_objection(this);
    endtask
endclass

class test2 extends uvm_test;
  `uvm_component_utils(test2);
  
  test_env env;
  
  function new(string name=" ",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    env=test_env::type_id::create("env",this);
    // scoreboard::type_id::set_type_override(scoreboard2::get_type());
  endfunction
  
  task run_phase(uvm_phase phase);
    write_read_random_seq seq;
    seq=write_read_random_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.agent_h.seqr);
    phase.drop_objection(this);
  endtask
  
endclass

class test3 extends uvm_test;
    `uvm_component_utils(test3);

    test_env env;

    function new(string name="", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        env=test_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
        reset_behave_test_seq seq;
        seq=reset_behave_test_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.start(env.agent_h.seqr);
        phase.drop_objection(this);
    endtask

endclass

class test4 extends uvm_test;
    `uvm_component_utils(test4);

    test_env env;

    function new(string name="test4", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        env=test_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
        rst_write_read_simultanious seq;
        seq=rst_write_read_simultanious::type_id::create("seq");
        phase.raise_objection(this);
        seq.start(env.agent_h.seqr);
        phase.drop_objection(this);
    endtask
endclass