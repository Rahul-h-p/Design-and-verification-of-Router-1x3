module FSM_RTL(clock,resetn,packet_valid,datain,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid, write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy
    );
input clock,resetn,packet_valid;
input [1:0] datain;
input fifo_full, fifo_empty_0, fifo_empty_1, fifo_empty_2, soft_reset_0, soft_reset_1, soft_reset_2, parity_done,low_packet_valid;
output write_enb_reg,detect_add, ld_state, laf_state, lfd_state, full_state, rst_int_reg, busy;

//8 states, so at least 3-bits are required for binary state encoding of 8-states
parameter decode_address= 3'b000,
				wait_till_empty= 3'b001,
				load_first_data= 3'b010,
				load_data= 3'b011,
				load_parity= 3'b100,
				fifo_full_state= 3'b101,
				load_after_full= 3'b110,
				check_parity_error= 3'b111;

reg [2:0] present_state, next_state;
reg [1:0] addr;

always@(posedge clock)
	begin
		if(~resetn)
			addr<=2'b00;
			else if(detect_add)
				addr<=datain;
			end
// present state logic 
always@(posedge clock)
	begin
		if(!resetn)
			present_state<=decode_address;
			else if(((soft_reset_0) && (datain[1:0]==2'b00)) || ((soft_reset_1) && (datain[1:0]==2'b01) || (soft_reset_2) && (datain[1:0]==2'b01)))
			//if there is soft_reset and also using same fifo so we cant load
			present_state<=decode_address;
			else
				present_state<=next_state;
			end
			
// state machine logic
			always@(*)
				begin 
				case(present_state)
					decode_address: 
					begin
						if((packet_valid && (datain[1:0]==2'b00) && fifo_empty_0 || (packet_valid && (datain[1:0]==2'b01) && fifo_empty_1) || (packet_valid && (datain[1:0]==2'b10) && fifo_empty_2)))
							next_state=load_first_data;
							else if ((packet_valid && (datain==2'b00)&& !fifo_empty_0) || (packet_valid && (datain==2'b01) && !fifo_empty_1)||(packet_valid && (datain==2'b10) && !fifo_empty_2))
									next_state=wait_till_empty;
									else
									 next_state=decode_address;
							end
					load_first_data: 
								begin
									next_state=load_data;
								end
					wait_till_empty:
								begin
									if((fifo_empty_0 && (addr==2'b00))||(fifo_empty_1 && (addr==2'b01)) || (fifo_empty_2 && (addr==2'b10)))
										next_state=load_first_data;
									else
										next_state=wait_till_empty;
									end
					load_data:
										begin
											if(fifo_full==1'b1)
												next_state=fifo_full_state;
											else if(!fifo_full && !packet_valid)
												next_state=load_parity;
											else
												next_state=load_data;
											end
									
									
					fifo_full_state:
									begin
										if(fifo_full==0)
											next_state=load_after_full;
										else 
											next_state=fifo_full_state;
									end
																		
					load_after_full:
									begin
										if(!parity_done && low_packet_valid)
											next_state=load_parity;
										else if(!parity_done && !low_packet_valid)
											next_state=load_data;
											else if (parity_done==1'b1)
												next_state=decode_address;
											else
											next_state=load_after_full;
											end
									
					load_parity: 
										begin
												next_state=check_parity_error;
											end
					check_parity_error:
											begin
												if(!fifo_full)
													next_state=decode_address;
												else
														next_state=fifo_full_state;
												end
												
					default: 
										next_state=decode_address;
										endcase
										end
										
										
										
//output logic
assign busy=((present_state==load_first_data)||(present_state==load_parity)||(present_state==fifo_full_state)||(present_state==load_after_full)||(present_state==wait_till_empty)||(present_state==check_parity_error))? 1'b1:1'b0;
assign detect_add=((present_state==decode_address))? 1'b1:1'b0;
assign lfd_state=((present_state==load_first_data))? 1'b1:1'b0;
assign ld_state=((present_state==load_data))? 1'b1:1'b0;
assign write_enb_reg=((present_state==load_data)||(present_state==load_after_full)||(present_state==load_parity))? 1'b1:1'b0;
assign full_state=((present_state==fifo_full_state))? 1'b1:1'b0;
assign laf_state=((present_state==load_after_full))? 1'b1:1'b0;
assign rst_int_reg=((present_state==check_parity_error))? 1'b1:1'b0;

										
endmodule
