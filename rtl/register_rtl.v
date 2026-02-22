module router_register(clock, resetn, pkt_valid,data_in,fifo_full, rst_int_reg, detect_add,ld_state,laf_state,
	full_state, lfd_state, parity_done, low_pkt_valid, err, d_out);
input clock, resetn, pkt_valid, fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state;
input [7:0] data_in;
output reg parity_done;
output low_pkt_valid;
output reg [7:0] d_out;
output reg err;
reg [7:0] header_byte, fifo_full_state, internal_parity, packet_parity;
wire parity_check;


always@(posedge clock)
begin
	if(!resetn)
	begin
		d_out<=8'b0;
	end
	else if(lfd_state)
		d_out<=header_byte;
	else if(pkt_valid && ld_state && !fifo_full)
		d_out<=data_in;
	else if(ld_state && fifo_full)
		begin
			fifo_full_state<=data_in;
				if(laf_state)
					d_out<=fifo_full_state;
				else
					d_out<=d_out;
		end
	else if(~pkt_valid)
		d_out<=data_in; // parity byte
	else
		d_out<=d_out;
	end
	
	//storing header_byte
	always@(posedge clock)
	begin
		if(!resetn)
			header_byte<=8'b0;
		else if(detect_add && pkt_valid && data_in[1:0] != 2'b11)
		header_byte<=data_in;
		else
		header_byte<=header_byte;
	end
	
	always@(posedge clock)
	begin
		//prev_parity<=parity_done;
		if((ld_state & ~fifo_full & ~pkt_valid) || (laf_state & ~pkt_valid))
			parity_done<=1'b1;
		else if(detect_add)
			parity_done<=1'b0;
		else
			parity_done<=parity_done;
	end
	
	//parity_calculation
	always@(posedge clock)
	begin
	if(!resetn)
		internal_parity<=8'b0;
	else if(lfd_state)
		internal_parity<=internal_parity^header_byte;
	else if (pkt_valid && !full_state && ld_state)
		internal_parity<=internal_parity^data_in;
		else
			internal_parity<=internal_parity;
		end
		// error and packet parity
	
	always@(posedge clock)
	begin
		if(!resetn)
			packet_parity<=8'b0;
		else if (!pkt_valid && ld_state)
		packet_parity<=data_in;
	end
	//error
	always@(posedge clock)
	begin
		if(!resetn)
			err<=1'b0;
		else if (!pkt_valid && rst_int_reg)
		begin
			if(parity_check)
			begin
				err<=1'b0;
				
			end
			else
			begin
				err<=1'b1;
			
			end
			
			end
		else	
			err<=err;
		end
		
	assign low_pkt_valid=(ld_state && ~pkt_valid);
		assign parity_check=(packet_parity==internal_parity)?1'b1:1'b0;
		endmodule
			