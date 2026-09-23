
class reset_fifo_seq extends uvm_sequence #(fifo_req,fifo_rsp);
    `uvm_object_utils(reset_fifo_seq);

    function new(string name="");
        super.new(name);
    endfunction

    task body;
        fifo_req req;
//       	fifo_rsp rsp;
        req=fifo_req::type_id::create("req");
        start_item(req);
        req.op=reset;
        finish_item(req);
//       	get_response(rsp);
    endtask
endclass

class write_fifo_seq extends uvm_sequence #(fifo_req,fifo_rsp);
    `uvm_object_utils(write_fifo_seq);

    function new(string name="");
        super.new(name);
    endfunction

    task body;
      fifo_req req;
//       fifo_rsp rsp;
      req=fifo_req::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.op==write;}); 
      finish_item(req);
//       get_response(rsp);
    endtask
endclass

class read_fifo_seq extends uvm_sequence #(fifo_req,fifo_rsp);
  `uvm_object_utils(read_fifo_seq);

    function new(string name="");
        super.new(name);
    endfunction

    task body;
      fifo_req req;
//       fifo_rsp rsp;
      req=fifo_req::type_id::create("req");
      start_item(req);
      req.op=read;
      finish_item(req);
//       get_response(rsp);
    endtask
endclass

class random_seq extends uvm_sequence #(fifo_req,fifo_rsp);
    `uvm_object_utils(random_seq);

    function new(string name="");
        super.new(name);
    endfunction

    task body;
      fifo_req req;
//       fifo_rsp rsp;
      req=fifo_req::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.op!=reset;});
      finish_item(req);
//       get_response(rsp);
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

class reset_behave_test_seq extends uvm_sequence #(fifo_req, fifo_rsp);
    `uvm_object_utils(reset_behave_test_seq);

    function new(string name="");
        super.new(name);
    endfunction

    task body;
        reset_fifo_seq  reset_seq;
        reset_seq=reset_fifo_seq::type_id::create("reset_seq");

        reset_seq.start(m_sequencer,this);//reset at begining
 		
      //fifo write
      repeat(10)begin
            write_fifo_seq write_seq;
            write_seq=write_fifo_seq::type_id::create("write_seq");
            write_seq.start(m_sequencer,this);
        end
      
        reset_seq.start(m_sequencer,this);//reset after fifo wrtite 
     
      //write
      repeat(20)begin
            write_fifo_seq write_seq;
            write_seq=write_fifo_seq::type_id::create("write_seq");
            write_seq.start(m_sequencer,this);
        end

       //read
      	repeat(10)begin
            read_fifo_seq read_seq;
        	read_seq=read_fifo_seq::type_id::create("read_seq");
            read_seq.start(m_sequencer,this);
        end
      
      reset_seq.start(m_sequencer,this);//reset after read
      
      //read
      repeat(5)begin
            read_fifo_seq read_seq;
        	read_seq=read_fifo_seq::type_id::create("read_seq");
            read_seq.start(m_sequencer,this);
        end
      
      //write
      	repeat(10)begin
            write_fifo_seq write_seq;
            write_seq=write_fifo_seq::type_id::create("write_seq");
            write_seq.start(m_sequencer,this);
        end
      
    endtask
endclass
