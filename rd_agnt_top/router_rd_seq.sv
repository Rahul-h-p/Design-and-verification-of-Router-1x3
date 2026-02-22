//================================================================
//		PHYSICAL SEQUENCE INSIDE ENVIRONMENT
//================================================================
class router_rd_seq extends uvm_sequence #(dest_xtn);
`uvm_object_utils(router_rd_seq)

extern function new(string name="router_rd_seq");
endclass


function router_rd_seq::new (string name="router_rd_seq");
super.new(name);
endfunction


class router_destseq1 extends router_rd_seq;
`uvm_object_utils(router_destseq1)
extern function new(string name="router_destseq1");
extern task body();
endclass
function router_destseq1::new(string name="router_destseq1");
super.new(name);
endfunction

task router_destseq1::body();
begin
dest_xtn req;
req=dest_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {no_of_cycles inside{[1:28]};});
finish_item(req);
end
endtask

class router_destseq2 extends router_rd_seq;
`uvm_object_utils(router_destseq2)
extern function new(string name="router_destseq2");
extern task body();
endclass
function router_destseq2::new(string name="router_destseq2");
super.new(name);
endfunction

task router_destseq2::body();
req=dest_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {no_of_cycles inside{[30:40]};});
`uvm_info("RAM_RD_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
finish_item(req);
endtask