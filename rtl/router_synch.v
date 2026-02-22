//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:30:59 06/30/2025 
// Design Name: 
// Module Name:    router_synch 
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
module router_synch(detect_add,data_in,write_enb_reg,clock, resetn,vld_out_0,vld_out_1,vld_out_2,read_enb_0,read_enb_1,read_enb_2,write_enb,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,full_0,full_1,full_2
    );
input detect_add,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,full_0,full_1,full_2,empty_0,empty_1,empty_2;
output reg soft_reset_0,soft_reset_1,soft_reset_2;
output vld_out_0,vld_out_1,vld_out_2;
output reg fifo_full;
input [1:0]data_in;
output reg [2:0]write_enb;
reg [1:0] temp;
reg [5:0] count0,count1,count2;
//generating valid out signal
assign vld_out_0=~empty_0;
assign vld_out_1=~empty_1;
assign vld_out_2=~empty_2;
//fetching the address
always@(posedge clock)
begin
	if(!resetn)
		temp<=0;
	else if(detect_add)
		temp<=data_in;
end
	//logic for fifo full
always@(*)
begin
	case(temp)
		2'b00:fifo_full=full_0;
		2'b01:fifo_full=full_1;
		2'b10:fifo_full=full_2;
		default: fifo_full=0;
	endcase
end

always@(*)
begin
	if(write_enb_reg)
	begin
	case(temp)
		2'b00:write_enb=3'b001;
		2'b01:write_enb=3'b010;
		2'b10:write_enb=3'b100;
		default: write_enb=3'b000;
	endcase
end
else
	write_enb = 3'b000;
end

always@(posedge clock)
begin
	if(!resetn)
	count0<=5'b0;
	else if(vld_out_0)
	begin
		if(!read_enb_0)
		begin
			if(count0==29)
			begin
				soft_reset_0<=1'b1;
				count0<=5'b0;
			end
				else
				begin
				count0<=count0+5'b00001;
				soft_reset_0<=1'b0;
				end
		end
				else count0<=5'b0;
	end
				else
				count0<=5'b0;
end

always@(posedge clock)
begin
	if(!resetn)
	count1<=5'b0;
	else if(vld_out_1)
	begin
		if(!read_enb_1)
		begin
			if(count1==29)
			begin
				soft_reset_1<=1'b1;
				count1<=5'b0;
			end
				else
				begin
				count1<=count1+5'b00001;
				soft_reset_1<=1'b0;
				end
		end
				else count1<=5'b0;
	end
				else
				count1<=5'b0;
end
always@(posedge clock)
begin
	if(!resetn)
	count2<=5'b0;
	else if(vld_out_2)
	begin
		if(!read_enb_2)
		begin
			if(count2==29)
			begin
				soft_reset_2<=1'b1;
				count2<=5'b0;
			end
				else
				begin
				count2<=count2+5'b00001;
				soft_reset_2<=1'b0;
				end
		end
				else count2<=5'b0;
	end
				else
				count2<=5'b0;
end

endmodule
