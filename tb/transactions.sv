class fifo_req #(parameter WIDTH=8) extends uvm_sequence_item;

    `uvm_object_utils(fifo_req);

    rand op_t op;
    rand logic [WIDTH-1:0] data;

    function new(string name="fifo_req");
        super.new(name);
    endfunction

    function string convert2string;
        return $psprintf("op:%s, data:%d",op,data);
    endfunction

endclass

class fifo_rsp #(parameter WIDTH=8) extends uvm_sequence_item;

    `uvm_object_utils(fifo_rsp);

    stat_t status;
    logic [WIDTH-1:0] data;

    function new(string name="fifo_rsp");
        super.new(name);
    endfunction

    function string convert2string;
        return $psprintf("status:%s, data:%d",status,data);
    endfunction
	
  	function bit comp_rsp_status(uvm_object rhs);
        fifo_rsp RHS;
        $cast(RHS,rhs);
        return (RHS.status==status);
    endfunction
  
    function bit comp_rsp(uvm_object rhs);
        fifo_rsp RHS;
        $cast(RHS,rhs);
        return (RHS.data==data) && (RHS.status==status);
    endfunction

endclass