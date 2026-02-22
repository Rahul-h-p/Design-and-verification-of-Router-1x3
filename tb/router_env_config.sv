//=============================
//		ENV CONFIG
//=============================
class router_env_config extends uvm_object;
`uvm_object_utils(router_env_config)
int no_of_wragent;
int no_of_rdagent;
bit has_wragnt;
bit has_rdagnt;
int has_scoreboard;
bit[1:0] addr;

router_wr_agent_config wragt_cfg[];
router_rd_agent_config rdagt_cfg[];

extern function new (string name="router_env_config");


endclass
function router_env_config::new (string name="router_env_config");
super.new(name);
endfunction