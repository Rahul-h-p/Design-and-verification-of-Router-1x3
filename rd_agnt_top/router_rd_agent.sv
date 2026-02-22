//=======================
// 		AGENT
//=======================
class router_rd_agent extends uvm_agent;
`uvm_component_utils(router_rd_agent)
router_rd_monitor rd_monh;
router_rd_driver rd_drvh;
router_rd_sequencer rd_seqrh;

router_rd_agent_config m_cfg;
extern function new (string name="router_rd_agent", uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass
function router_rd_agent::new(string name="router_rd_agent",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void router_rd_agent::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(router_rd_agent_config)::get(this,"","router_rd_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get the conig into rdite agent")
rd_monh=router_rd_monitor::type_id::create("rd_monh",this);
if(m_cfg.is_active==UVM_ACTIVE)
begin
	rd_drvh=router_rd_driver::type_id::create("rd_drvh",this);
	rd_seqrh=router_rd_sequencer::type_id::create("rd_seqrh",this);
end
endfunction

function void router_rd_agent::connect_phase(uvm_phase phase);
		if(m_cfg.is_active==UVM_ACTIVE)
		begin
		rd_drvh.seq_item_port.connect(rd_seqrh.seq_item_export);
  		end
	endfunction