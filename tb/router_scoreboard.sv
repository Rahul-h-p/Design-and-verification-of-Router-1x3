//==============================
//		SCOREBOARD
//  get data from monitors
//	compare
//	coverpoints
//==============================
class router_scoreboard extends uvm_scoreboard;
`uvm_component_utils(router_scoreboard)
uvm_tlm_analysis_fifo#(dest_xtn) fifo_rdh[];
uvm_tlm_analysis_fifo#(source_xtn) fifo_wrh[];
router_env_config m_cfg;
source_xtn wr_data;
source_xtn write_cov_data;
dest_xtn rd_data;
dest_xtn read_cov_data;
extern function new(string name="router_scoreboard",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void check_data(dest_xtn rd);

covergroup router_fcov1;
option.per_instance=1;// seperate covergroup for different instance like for multiple agents

CHANNEL: coverpoint write_cov_data.header[1:0]
									{	bins low = {2'b00};
										bins mid1={2'b01};
										bins mid2={2'b10};
									}
PAYLOAD_SIZE: coverpoint write_cov_data.header[7:2]
									{	bins small_pkt={[1:15]};
										bins medium_pkt={[16:30]};
										bins large_pkt={[31:63]};
									}

CHANNEL_X_PAYLOAD_SIZE: cross CHANNEL,PAYLOAD_SIZE;

endgroup

covergroup router_fcov2;
option.per_instance=1;

CHANNEL: coverpoint read_cov_data.header[1:0]
									{	bins low = {2'b00};
										bins mid1={2'b01};
										bins mid2={2'b10};
									}
PAYLOAD_SIZE: coverpoint read_cov_data.header[7:2]
									{	bins small_pkt={[1:15]};
										bins medium_pkt={[16:30]};
										bins large_pkt={[31:63]};
									}

CHANNEL_X_PAYLOAD_SIZE: cross CHANNEL,PAYLOAD_SIZE;
endgroup

endclass
function router_scoreboard::new(string name="router_scoreboard",uvm_component parent);
super.new(name,parent);
router_fcov1 = new();
    router_fcov2 = new();
endfunction

function void router_scoreboard::build_phase(uvm_phase phase);
if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
`uvm_fatal("CONFIG","not able to get the config in scoreboard")
fifo_wrh=new[m_cfg.no_of_wragent];
fifo_rdh=new[m_cfg.no_of_rdagent];

foreach(fifo_wrh[i])
begin
fifo_wrh[i]=new($sformatf("fifo_wrh[%0d]",i),this);
end
foreach(fifo_rdh[i])
begin
fifo_rdh[i]=new($sformatf("fifo_rdh[%0d]",i),this);
end
endfunction

task router_scoreboard::run_phase(uvm_phase phase);

fork
	forever
	begin
		fork
			begin
				fork
				   fifo_rdh[0].get(rd_data);
				   fifo_rdh[1].get(rd_data);
				   fifo_rdh[2].get(rd_data);
				join_any
				//disable fork;
				`uvm_info("SCOREBOARD",$sformatf("\nPrinting read data %0s",rd_data.sprint()),UVM_LOW)
				check_data(rd_data);
			end
			begin
				
				fifo_wrh[0].get(wr_data);
				`uvm_info("SCOREBOARD",$sformatf("\nPrinting read data %0s",wr_data.sprint()),UVM_LOW)
				write_cov_data=wr_data;
				router_fcov1.sample();
			end
		join
	end
	join
endtask

function void router_scoreboard::check_data(dest_xtn rd);
if(wr_data.header==rd.header)
`uvm_info("SB","HEADER MATCHED SUCCESSFULLY",UVM_LOW)
else
`uvm_error("SB","HEADER COMPARISON FAILED")
if(wr_data.payload==rd.payload)
`uvm_info("SB","PAYLOAD MATCHED SUCCESSFULLY",UVM_LOW)
else
`uvm_error("SB","PAYLOAD COMPARISON FAILED")
if(wr_data.parity==rd.parity)
`uvm_info("SB","PARITY MATCHED SUCCESSFULLY",UVM_LOW)
else
`uvm_error("SB","PARITY COMPARISON FAILED")
read_cov_data=rd;
router_fcov2.sample();
endfunction
