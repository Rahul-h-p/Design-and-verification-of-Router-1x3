//================================================================
//		PYSICAL SEQUENCE INSIDE ENVIRONMENT
//================================================================
class router_wrbase_seq extends uvm_sequence #(source_xtn);
`uvm_object_utils(router_wrbase_seq)
extern function new (string name="router_wrbase_seq");

endclass

function router_wrbase_seq::new (string name="router_wrbase_seq");
super.new(name);
endfunction

class router_xtns_small_pkt extends router_wrbase_seq;
`uvm_object_utils(router_xtns_small_pkt)
extern function new(string name="router_xtns_small_pkt");
extern task body();
endclass
function router_xtns_small_pkt::new(string name="router_xtns_small_pkt");
super.new(name);
endfunction

task router_xtns_small_pkt::body();
req=source_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {req.header[7:2] inside{[0:15]};});
`uvm_info("ROUTER_WR_SEQUENCE",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
finish_item(req);
endtask

class router_xtns_medium_pkt extends router_wrbase_seq;
`uvm_object_utils(router_xtns_medium_pkt)
extern function new(string name="router_xtns_medium_pkt");
extern task body();

endclass
function router_xtns_medium_pkt::new(string name="router_xtns_medium_pkt");
super.new(name);
endfunction

task router_xtns_medium_pkt::body();
req=source_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {req.header[7:2] inside{[16:30]};});
`uvm_info("ROUTER_WR_SEQUENCE",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
finish_item(req);
endtask

class router_xtns_large_pkt extends router_wrbase_seq;
`uvm_object_utils(router_xtns_large_pkt)
extern function new(string name="router_xtns_large_pkt");
extern task body();
endclass
function router_xtns_large_pkt::new(string name="router_xtns_large_pkt");
super.new(name);
endfunction

task router_xtns_large_pkt::body();
req=source_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {req.header[7:2] inside{[31:63]};});
`uvm_info("ROUTER_WR_SEQUENCE",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
finish_item(req);
endtask
