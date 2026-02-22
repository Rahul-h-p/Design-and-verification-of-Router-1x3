/************************************************************************
  
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
  
www.maven-silicon.com 
  
All Rights Reserved. 
This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd. 
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.
  
Filename		:   router_test_pkg.sv

Description 	: 	Dual Port router TB package
  
Author Name		:   Putta Satish

Support e-mail	: 	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

************************************************************************/

`include "uvm_macros.svh"


package router_test_pkg;


	//import uvm_pkg.sv
	
	import uvm_pkg::*;
	
		
	//include uvm_macros.sv
	
	//`include "tb_defs.sv"

	`include "router_wr_agent_config.sv"
	`include "router_rd_agent_config.sv"
	`include "router_env_config.sv"
		`include "write_xtn.sv"
	`include "router_wr_driver.sv"
	`include "router_wr_monitor.sv"
	`include "router_wr_sequencer.sv"
	`include "router_wr_agent.sv"
	`include "router_wr_agnt_top.sv"
	`include "router_wr_seq.sv"

	`include "read_xtn.sv"
	
	`include "router_rd_monitor.sv"
	`include "router_rd_sequencer.sv"
	`include "router_rd_seq.sv"
	`include "router_rd_driver.sv"
	`include "router_rd_agent.sv"
	`include "router_rd_agnt_top.sv"

	//`include "router_virtual_sequencer.sv"
	//`include "router_virtual_seqs.sv"
	`include "router_scoreboard.sv"

	`include "router_tb.sv"


	`include "router_vtest.sv"
	
endpackage