class reset_fifo_seq extends uvm_sequence #(fifo_req,fifo_rsp);
    `uvm_object_utils(reset_fifo_seq);

    function new(string name="");
        super.new(name);
    endfunction

    task body;
        fifo_req req;
        req=fifo_req::type_id::create("req");
        start_item(req);
        req.op=reset;
        finish_item(req);
    endtask
endclass

class write_fifo_seq extends uvm_sequence #(fifo_req,fifo_rsp);
    `uvm_object_utils(write_fifo_seq);

    function new(string name="");
        super.new(name);
    endfunction

    task body;
      fifo_req req;
      fifo_rsp rsp;
      req=fifo_req::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.op==write;}); 
      finish_item(req);
      get_response(rsp);
    endtask
endclass

class read_fifo_seq extends uvm_sequence #(fifo_req,fifo_rsp);
  `uvm_object_utils(read_fifo_seq);

    function new(string name="");
        super.new(name);
    endfunction

    task body;
      fifo_req req;
      fifo_rsp rsp;
      req=fifo_req::type_id::create("req");
      start_item(req);
      req.op=read;
      finish_item(req);
      get_response(rsp);
    endtask
endclass

class random_seq extends uvm_sequence #(fifo_req,fifo_rsp);
    `uvm_object_utils(random_seq);

    function new(string name="");
        super.new(name);
    endfunction

    task body;
      fifo_req req;
      fifo_rsp rsp;
      req=fifo_req::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.op!=reset;});
      finish_item(req);
      get_response(rsp);
    endtask
endclass

class rst_write_read extends uvm_sequence #(fifo_req,fifo_rsp);
    `uvm_object_utils(rst_write_read);

    function new(string name="rst_write_read");
        super.new(name);
    endfunction

    task body;
      reset_fifo_seq rst_seq;
      rst_seq=reset_fifo_seq::type_id::create("rst_seq");
      rst_seq.start(m_sequencer,this);
      
      repeat(10)begin
        write_fifo_seq wr_seq;
        wr_seq=write_fifo_seq::type_id::create("wr_seq");
        wr_seq.start(m_sequencer,this);     
      end
      
      repeat(10)begin 
        read_fifo_seq re_seq;
        re_seq=read_fifo_seq::type_id::create("re_seq");
        re_seq.start(m_sequencer,this);
      end
    endtask
endclass
 
class write_read_random_seq extends uvm_sequence #(fifo_req,fifo_rsp);
  `uvm_object_utils(write_read_random_seq);

    function new(string name="");
        super.new(name);
    endfunction

    task body;
      reset_fifo_seq rst_seq;
      rst_seq=reset_fifo_seq::type_id::create("rst_seq");
      rst_seq.start(m_sequencer,this);
      
      repeat(10)begin
        write_fifo_seq wr_seq;
        wr_seq=write_fifo_seq::type_id::create("wr_seq");
        wr_seq.start(m_sequencer,this);     
      end
      
      repeat(10)begin 
        random_seq rand_seq;
        rand_seq=random_seq::type_id::create("rand_seq");
        rand_seq.start(m_sequencer,this);
      end
      
      repeat(10)begin
        write_fifo_seq wr_seq;
        wr_seq=write_fifo_seq::type_id::create("wr_seq");
        wr_seq.start(m_sequencer,this);     
      end
      
      repeat(10)begin 
        random_seq rand_seq;
        rand_seq=random_seq::type_id::create("rand_seq");
        rand_seq.start(m_sequencer,this);
      end
    endtask
endclass

