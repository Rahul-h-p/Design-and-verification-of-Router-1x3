//=======================
// 		AGENT
//=======================
class router_wr_agent extends uvm_agent;
`uvm_component_utils(router_wr_agent)
router_wr_monitor wr_monh;
router_wr_driver wr_drvh;
router_wr_sequencer wr_seqrh;

router_wr_agent_config m_cfg;
extern function new (string name="router_wr_agent", uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass
function router_wr_agent::new(string name="router_wr_agent",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void router_wr_agent::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(router_wr_agent_config)::get(this,"","router_wr_agent_config",m_cfg))
begin
	`uvm_fatal("CONFIG","cannot get the conig into write agent")
end
wr_monh=router_wr_monitor::type_id::create("wr_monh",this);
if(m_cfg.is_active==UVM_ACTIVE)
begin
	wr_drvh=router_wr_driver::type_id::create("wr_drvh",this);
	wr_seqrh=router_wr_sequencer::type_id::create("wr_seqrh",this);
end
endfunction

function void router_wr_agent::connect_phase(uvm_phase phase);
		if(m_cfg.is_active==UVM_ACTIVE)
		begin
		wr_drvh.seq_item_port.connect(wr_seqrh.seq_item_export);
  		end
	endfunction