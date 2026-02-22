//========================================
//				DRIVER
//========================================
class router_rd_driver extends uvm_driver #(dest_xtn);
`uvm_component_utils(router_rd_driver)
router_rd_agent_config m_cfg;
virtual router_if.RDR_MP vif;
extern function new(string name="router_rd_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(dest_xtn xtn);
endclass
function router_rd_driver::new(string name="router_rd_driver",uvm_component parent);
super.new(name,parent);
endfunction

function void router_rd_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(router_rd_agent_config)::get(this,"","router_rd_agent_config",m_cfg))
`uvm_fatal("CONFIG","get failed in driver")
endfunction
function void router_rd_driver::connect_phase(uvm_phase phase);
vif=m_cfg.vif;
endfunction

task router_rd_driver::run_phase(uvm_phase phase);
forever
begin
seq_item_port.get_next_item(req);
send_to_dut(req);
seq_item_port.item_done();
end
endtask

task router_rd_driver::send_to_dut(dest_xtn xtn);

while(vif.rdr_cb.vld_out==0)
@(vif.rdr_cb);
repeat(xtn.no_of_cycles)
@(vif.rdr_cb);
vif.rdr_cb.read_enb<=1'b1;
@(vif.rdr_cb);
while(vif.rdr_cb.vld_out==1)
@(vif.rdr_cb);
vif.rdr_cb.read_enb<=1'b0;
@(vif.rdr_cb);
//`uvm_info("ROUTER_RD_DRIVER",$sformatf("\nPrinting from read driver %s",xtn.sprint()),UVM_LOW)
endtask