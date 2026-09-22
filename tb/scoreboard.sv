
class scoreboard extends uvm_agent;
    `uvm_component_utils(scoreboard);

    uvm_tlm_analysis_fifo #(fifo_req) req_afifo;
    uvm_tlm_analysis_fifo #(fifo_rsp) rsp_afifo;

    int unsigned memGolden[$];
    int wCnt;
    int rCnt;
  	int cnt;

    function new(string name="scoreboard", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        req_afifo=new("req_afifo",this);
      rsp_afifo=new("rsp_afifo",this);
    endfunction

  task run_phase(uvm_phase phase);
        fifo_req req;
        fifo_rsp act_rsp,exp_rsp;
        exp_rsp=fifo_rsp::type_id::create("exp_rsp");
        forever begin
          req_afifo.get(req);
          rsp_afifo.get(act_rsp);
          reference_model(req,exp_rsp);
          if(req.op==write || req.op==reset)begin
            assert(act_rsp.comp_rsp_status(exp_rsp))begin
              `uvm_info("Scoreboard",$psprintf("Pass: req:%s, Act rsp:%s, Exp rsp:%s",req.convert2string,act_rsp.convert2string,exp_rsp.convert2string),UVM_MEDIUM);
          	end else begin
              `uvm_info("Scoreboard",$psprintf("Fail:req:%s, Act rsp:%s, Exp rsp:%s",req.convert2string,act_rsp.convert2string,exp_rsp.convert2string),UVM_MEDIUM);
            end
          end else begin
            if(act_rsp.comp_rsp(exp_rsp))begin
                `uvm_info("Scoreboard",$psprintf("Pass: req:%s,Act rsp:%s, Exp rsp:%s",req.convert2string,act_rsp.convert2string,exp_rsp.convert2string),UVM_MEDIUM);
          	end else begin
                `uvm_info("Scoreboard",$psprintf("Fail: req:%s,Act rsp:%s, Exp rsp:%s",req.convert2string,act_rsp.convert2string,exp_rsp.convert2string),UVM_MEDIUM);
            end
          end
        end
    endtask

  function void reference_model(input fifo_req req, ref fifo_rsp rsp);
        // fifo_rsp rsp;
        // rsp=fifo_rsp::type_id::create("rsp");
      
      	cnt=wCnt-rCnt;
      
        if(req.op==reset)begin
            wCnt=0;
            rCnt=0;
            memGolden.delete();
        end else if(req.op==write && cnt<16)begin
            memGolden.push_back(req.data);
            wCnt++;
        end else if(req.op==read && cnt>0)begin
            rsp.data=memGolden.pop_front();
            rCnt++;
        end else if(req.op==write_read && cnt==0)begin
         	memGolden.push_back(req.data);
          	wCnt++;
        end else if(req.op==write_read && cnt==16)begin         	
          	rsp.data=memGolden.pop_front();          	
          	rCnt++;
        end else if(req.op==write_read && cnt>0 && cnt<16)begin
         	memGolden.push_back(req.data);
          	rsp.data=memGolden.pop_front();
          	wCnt++;
          	rCnt++;
        end
      
      if(wCnt==rCnt)
        rsp.status=empty;
      else if(wCnt-rCnt==16)
        rsp.status=full;
      else
        rsp.status=mid;
      
//       `uvm_info("Scoreboard",$psprintf("wCnt:%d, rCnt:%d , fifo_status:%s at time:%t",wCnt,rCnt,rsp.status,$time),UVM_MEDIUM);
//         return rsp;

    endfunction

endclass
