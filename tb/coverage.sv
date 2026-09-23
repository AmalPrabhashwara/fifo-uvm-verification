class coverage extends uvm_agent;
    `uvm_component_utils(coverage);

    uvm_tlm_analysis_fifo #(fifo_req) req_afifo;
    uvm_tlm_analysis_fifo #(fifo_rsp) rsp_afifo;

    op_t op;
    stat_t stat;
    logic [7:0] data;

    covergroup fifo_cov;
        cp_op:coverpoint op{
            bins wr={write};
            bins rd={read};
            bins wr_rd={write_read};
            bins rst={reset};
        }
        cp_stat:coverpoint stat{
            bins full={full};
            bins mid={mid};
            bins empty={empty};
        }
        cp_data:coverpoint data{
            bins zeros={0};
            bins mid={['h00:'hfe]};
            bins ones={'hff};
        }
      	
        cp_write_rst:coverpoint op{
            bins rst=(write=>reset);
      	}

        cp_op_wr:coverpoint op{
            bins wr={write};
        }

        cp_wr_full:cross cp_op, cp_stat{
            bins wr_full=binsof(cp_op.wr) && binsof(cp_stat.full);
        }

        cp_op_rd:coverpoint op{
            bins rd={read};
        }
        cp_rd_empty:cross cp_op, cp_stat{
            bins rd_empty=binsof(cp_op.rd) && binsof(cp_stat.empty);
        }

    endgroup

    function new(string name="coverage", uvm_component parent=null);
        super.new(name,parent);
        fifo_cov=new();
    endfunction

    function void build_phase(uvm_phase phase);
        req_afifo=new("req_afifo",this);
        rsp_afifo=new("rsp_afifo",this);
    endfunction

    task run_phase(uvm_phase phase);
      	forever begin
            fifo_req req;
            fifo_rsp rsp;
            req_afifo.get(req);
            rsp_afifo.get(rsp);
            op=req.op;
            stat=rsp.status;
            data=req.data;
            fifo_cov.sample();
        end
    endtask

    function void report_phase(uvm_phase phase);
      
    //   `uvm_info("COVERAGE",$psprintf("fifo status check bins hitted full:%d empty:%d mid:%d",fullCnt,emptyCnt,midCnt),UVM_MEDIUM);

        `uvm_info(
            "COVERAGE",
            $sformatf("fifo coverage = %.2f%%",
            fifo_cov.get_coverage()),
            UVM_NONE
        );

    endfunction

endclass
