//=======================
//		AGENT TOP
//=======================
class router_wr_agnt_top extends uvm_env;
`uvm_component_utils(router_wr_agnt_top)
router_wr_agent wr_agnth[];
router_env_config m_cfg;
extern function new(string name="router_wr_agnt_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass
function router_wr_agnt_top::new(string name="router_wr_agnt_top",uvm_component parent);
	super.new(name,parent);
endfunction
	
function void router_wr_agnt_top::build_phase(uvm_phase phase);
super.build_phase(phase);
//if(!uvm_config_db#(router_wr_agent_config)::get(this,"","router_wr_agent_config",wragt_cfg))
//	`uvm_fatal("WR_CONFIG","not able to get the config database")
if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
begin
	`uvm_fatal("ENV_CONFIG","not able to get the config")
end
wr_agnth=new[m_cfg.no_of_wragent];
foreach(wr_agnth[i])
begin
wr_agnth[i]=router_wr_agent::type_id::create($sformatf("wr_agnth[%0d]",i),this);
end
endfunction

task router_wr_agnt_top::run_phase(uvm_phase phase);
uvm_top.print_topology;
endtask