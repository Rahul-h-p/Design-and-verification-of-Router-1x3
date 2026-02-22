module router_top(clock, resetn,read_enb_0 ,read_enb_1, read_enb_2, data_in, pkt_valid, data_out_0, data_out_1, data_out_2, valid_out_0, valid_out_1, valid_out_2, error, busy);
//router_if.DUV_MP inf;
input clock,resetn, read_enb_0, read_enb_1,read_enb_2;
input pkt_valid;
input [7:0] data_in;
output [7:0] data_out_0, data_out_1, data_out_2;
output valid_out_0, valid_out_1, valid_out_2, error,busy;

wire [2:0] write_enb;
wire [7:0] d_out;

FSM_RTL fsm(clock,resetn,pkt_valid,data_in[1:0],fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,
parity_done,low_pkt_valid, write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy );

router_synch syn(detect_add,data_in[1:0],write_enb_reg,clock, resetn,valid_out_0,valid_out_1,valid_out_2,read_enb_0,
read_enb_1,read_enb_2,write_enb,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,full_0,full_1,full_2 );

router_register regis(clock, resetn, pkt_valid,data_in,fifo_full, rst_int_reg, detect_add,ld_state,laf_state,
	full_state, lfd_state, parity_done, low_pkt_valid, error, d_out);

router_fifo fifo1(clock,resetn,d_out,read_enb_0,write_enb[0],data_out_0,full_0,empty_0,lfd_state,soft_reset_0
    );
router_fifo fifo2(clock,resetn,d_out,read_enb_1,write_enb[1],data_out_1,full_1,empty_1,lfd_state,soft_reset_1
    );
router_fifo fifo3(clock,resetn,d_out,read_enb_2,write_enb[2],data_out_2,full_2,empty_2,lfd_state,soft_reset_2
    );	
	
endmodule