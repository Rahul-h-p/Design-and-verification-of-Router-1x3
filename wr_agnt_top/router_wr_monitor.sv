//===========================
// 		MONITOR
//===========================
class router_wr_monitor extends uvm_monitor;
	`uvm_component_utils(router_wr_monitor)
	router_wr_agent_config wr_cfg;
	uvm_analysis_port #(source_xtn) monitor_port;
virtual router_if.WMON_MP vif;
extern function new(string name="router_wr_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
extern function void report_phase(uvm_phase phase);
endclass
function router_wr_monitor::new(string name="router_wr_monitor",uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction

function void router_wr_monitor::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(router_wr_agent_config)::get(this,"","router_wr_agent_config",wr_cfg))
begin
`uvm_fatal("CONFIG","not able to get the config")
end
endfunction

function void router_wr_monitor::connect_phase(uvm_phase phase);
vif=wr_cfg.vif;
endfunction

 function void router_wr_monitor::report_phase(uvm_phase phase);
 `uvm_info(get_type_name(), $sformatf("\nmonitor sent %0d transaction",wr_cfg.mon_data_count),UVM_LOW)
 endfunction
 
task router_wr_monitor::run_phase(uvm_phase phase);
forever
collect_data();
 endtask
 
 task router_wr_monitor::collect_data();
 source_xtn mon_data;
 mon_data=source_xtn::type_id::create("mon_data");
 @(vif.wmon_cb);
 while(!vif.wmon_cb.pkt_valid)
 @(vif.wmon_cb);
 while(vif.wmon_cb.busy)
 @(vif.wmon_cb);
 mon_data.header=vif.wmon_cb.data_in;
 mon_data.payload=new[mon_data.header[7:2]];
 @(vif.wmon_cb)
 foreach(mon_data.payload[i])
 begin
  while(vif.wmon_cb.busy)
 @(vif.wmon_cb);
 mon_data.payload[i]=vif.wmon_cb.data_in;
 @(vif.wmon_cb);
 end
 while(vif.wmon_cb.busy)
 @(vif.wmon_cb);
 
 // need to check for packet valid
 mon_data.parity=vif.wmon_cb.data_in;
 repeat(2)
 @(vif.wmon_cb);
 mon_data.err=vif.wmon_cb.error; //did not drive this 
 wr_cfg.mon_data_count++;
 `uvm_info("ROUTER_WR_MONITOR",$sformatf("\nprinting from write monitor \n %s",mon_data.sprint()),UVM_LOW)
 monitor_port.write(mon_data);
 
 endtask 

 
 
