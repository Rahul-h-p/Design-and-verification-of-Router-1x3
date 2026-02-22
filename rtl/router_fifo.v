//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:34:29 06/30/2025 
// Design Name: 
// Module Name:    router_fifo 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module router_fifo(clock,resetn,data_in,read_enb,write_enb,data_out,full,empty,lfd_state,soft_reset
    );

parameter width=9,depth=16;
input lfd_state;
input [width-2:0]data_in;
input clock,resetn,read_enb,write_enb,soft_reset;
output full,empty;
output reg [width-2:0] data_out;

reg [6:0]count;
integer i;
reg [4:0]rd_pointer,wr_pointer;
reg [width-1:0] mem[depth-1:0];
reg temp;

//fifo full and empty logic
assign full=((wr_pointer[4]!=rd_pointer[4])&&(wr_pointer[3:0]==rd_pointer[3:0]));
assign empty=(wr_pointer==rd_pointer);
// lfd state
always@(posedge clock)
begin
	if(!resetn)
		temp<=0;
	else
		temp<=lfd_state; // delaying lfd_state by 1clock to latch the header byte
end

//write logic
always@(posedge clock)
begin
	if(!resetn)
	begin
		for(i=0;i<16;i=i+1)
		mem[i]<=0;
		wr_pointer<=0;
	end
	else if(soft_reset)
	begin
		for(i=0;i<16;i=i+1)
		mem[i]<=0;
		wr_pointer<=0;
	end
	else if(write_enb && !full)
	begin
		{mem[wr_pointer[3:0]][8],mem[wr_pointer[3:0]][7:0]}<={temp,data_in};
			wr_pointer<=wr_pointer+1'b1;
	end
	end
		
//read logic
always@(posedge clock)
begin
		if(!resetn)
		begin
			data_out<=0;
				rd_pointer<=0;
		end
		else if(soft_reset)
		begin
			data_out<=8'bz;
		end
      else if(count==0)
			begin
				data_out<=8'bz;
			end
		else if(read_enb && !empty)
			begin
				data_out<=mem[rd_pointer[3:0]][7:0];
				 rd_pointer<=rd_pointer+1'b1;
		   end
		else
				data_out<=8'bz;
end
//counter logic
always@(posedge clock)
begin
	if(!resetn)
		count<=0;
	else if(soft_reset)
		count<=0;
	else if(mem[rd_pointer[3:0]][8]==1)
	begin
	//count = payload + parity
		count<=mem[rd_pointer[3:0]][7:2]+1'b1;
	end
	else if(read_enb && !empty)
		count<=count-1'b1;
	else 
	count<=count;
	end
endmodule
