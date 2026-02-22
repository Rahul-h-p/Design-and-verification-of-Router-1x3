//===========================
// 		MONITOR
//===========================
class router_rd_monitor extends uvm_monitor;
	`uvm_component_utils(router_rd_monitor)
	extern function new(string name="router_rd_monitor", uvm_component parent);
	router_rd_agent_config m_cfg;
	virtual router_if.RMON_MP vif;
	uvm_analysis_port#(dest_xtn) mp;

extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
endclass
function router_rd_monitor::new(string name="router_rd_monitor",uvm_component parent);
	super.new(name,parent);
	mp=new("mp",this);
endfunction

function void router_rd_monitor::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(router_rd_agent_config)::get(this,"","router_rd_agent_config",m_cfg))
begin
`uvm_fatal("CONFIG","get failed in monitor")
end
endfunction

function void router_rd_monitor::connect_phase(uvm_phase phase);
vif=m_cfg.vif;
endfunction

task router_rd_monitor::run_phase(uvm_phase phase);
forever
begin
collect_data();
end
endtask


task router_rd_monitor::collect_data();
	dest_xtn mon_data;
	mon_data=dest_xtn::type_id::create("mon_data");
	@(vif.rmon_cb);
//`uvm_info("[MON_DEBUG]",$sformatf(" @%0t Waiting for read_enb ",$time), UVM_LOW)
		while(vif.rmon_cb.read_enb==0)
		@(vif.rmon_cb);
//`uvm_info("[MON_DEBUG]",$sformatf("@%0t read_enb detected! Capturing Header...", $time),UVM_LOW)
		@(vif.rmon_cb); //--------------debuging
	mon_data.header=vif.rmon_cb.data_out;
	mon_data.payload=new[mon_data.header[7:2]];
//`uvm_info("[MON_DEBUG]",$sformatf(" Header: %0h, Payload Size: %0d", mon_data.header, mon_data.payload.size()),UVM_LOW)
	@(vif.rmon_cb);
		foreach(mon_data.payload[i])
		begin
//`uvm_info("[MON_DEBUG]",$sformatf(" @%0t: Inside Loop Iteration %0d", $time, i),UVM_LOW)
		mon_data.payload[i]=vif.rmon_cb.data_out;
		@(vif.rmon_cb);
		end
//`uvm_info("[MON_DEBUG]",$sformatf(" @%0t: Loop Finished. Capturing Parity.", $time),UVM_LOW)
	mon_data.parity=vif.rmon_cb.data_out;
	mp.write(mon_data);
`uvm_info("ROUTER_RD_MONITOR",$sformatf("\nPrinting from read monitor \n %s",mon_data.sprint()),UVM_LOW)
endtask