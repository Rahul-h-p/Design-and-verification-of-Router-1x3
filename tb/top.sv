/************************************************************************
  
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
  
www.maven-silicon.com 
  
All Rights Reserved. 
This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd. 
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.
  
Filename		:   top.sv

Description 	: 	Top Module
  
Author Name		:   RAHUL HP

Support e-mail	: 	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

************************************************************************/

module top;
	`include "uvm_macros.svh"
	// import router_test_pkg
    	import router_test_pkg::*;
	
	//import uvm_pkg.sv
	import uvm_pkg::*;
	
	//include uvm_macros.svh"
	

    	//Generate clock signal
	bit clock;  
	always 
		#10 clock=!clock;     

   // Instantiate router_if with clock as input
   router_if in0(clock);
   router_if in1(clock);
   router_if in2(clock);
   router_if in3(clock);
       
   // Instantiate rtl router_chip and pass the interface instance as argument
  //==== router_chip ch(in0);
	router_top duv(.clock(clock), .resetn(in0.rst),.read_enb_0(in1.read_enb) ,.read_enb_1(in2.read_enb),.read_enb_2(in3.read_enb), .data_in(in0.data_in), .pkt_valid(in0.pkt_valid), .data_out_0(in1.data_out),.data_out_1(in2.data_out), .data_out_2(in3.data_out), .valid_out_0(in1.vld_out), .valid_out_1(in2.vld_out), .valid_out_2(in3.vld_out), .error(in0.error), .busy(in0.busy));
	
   
   property packet_valid;
   @(posedge clock) $rose(in0.pkt_valid)|=>in0.busy;
   endproperty
    property data_stable;
   @(posedge clock) in0.busy|=>$stable(in0.data_in);
   endproperty
      property read_enable0;
   @(posedge clock) $rose(in1.vld_out)|=>##[0:29] in1.read_enb;
    
   endproperty
   property read_enable1;
    @(posedge clock) $rose(in2.vld_out)|=>##[0:29] in2.read_enb;
   endproperty
   property read_enable2;
	 @(posedge clock) $rose(in3.vld_out)|=>##[0:29] in3.read_enb;
   endproperty
   property valid_output0;
   @(posedge clock) $rose(in1.pkt_valid)|->##3 in1.vld_out;
   endproperty
    property valid_output1;
   @(posedge clock) $rose(in2.pkt_valid)|->##3 in2.vld_out;
   endproperty
   property valid_output2;
   @(posedge clock) $rose(in3.pkt_valid)|->##3 in3.vld_out;
   endproperty
   property read_fall0;
   @(posedge clock) (in1.vld_out)##1(!in1.vld_out)|=> $fell(in1.read_enb);
   endproperty
   property read_fall1;
   @(posedge clock) (in2.vld_out)##1(!in2.vld_out)|=> $fell(in2.read_enb);
   endproperty
   property read_fall2;
   @(posedge clock) (in3.vld_out)##1(!in3.vld_out)|=> $fell(in3.read_enb);
   endproperty
   assert property (packet_valid);
   assert property (data_stable); 
   assert property (read_enable0);
   assert property (read_enable1);
   assert property (read_enable2);
   assert property (valid_output0);
   assert property (valid_output1);
   assert property (valid_output2);
   assert property (read_fall0);
   assert property (read_fall1);
   assert property (read_fall2);
   
   // In initial block
    initial 
	begin
		
		`ifdef VCS
        	 $fsdbDumpvars(0, top);
        	`endif	

		//set the virtual interface using the uvm_config_db
		uvm_config_db #(virtual router_if)::set(null,"*","vif_0",in0);
		uvm_config_db #(virtual router_if)::set(null,"*","vif_1",in1);
		uvm_config_db #(virtual router_if)::set(null,"*","vif_2",in2);
		uvm_config_db #(virtual router_if)::set(null,"*","vif_3",in3);

		// Call run_test
		run_test();
	end

endmodule

  
   
  
