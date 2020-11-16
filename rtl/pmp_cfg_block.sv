module pmp_cfg_block (address, pmp_pre_address, mode, pmp_address, match, size);
	input [33:0] address;
	input [31:0] pmp_address,pmp_pre_address ;
	input [1:0] size, mode;
	output match;

	reg [31:0] address_lb, address_ub;   //address lower bound & upper bound

	reg [31:0] pmp_address_NA4; 
	reg [31:0] pmp_address_NAPOT_ub, pmp_address_NAPOT_lb;
	reg [3:0] data_size; //select data_size
	reg match;

	parameter	A0_OFF = 2'b00,
				A1_TOR = 2'b01,
				A2_NA4 = 2'b10,
				A3_NAPOT = 2'b11;
				
	always@(*)
	begin

		pmp_address_NA4 = pmp_address+4;

		case(size)
			2'b00: data_size = 1;
			2'b01: data_size = 2;
			2'b10: data_size = 4;
			2'b11: data_size = 8;
		endcase
		casex(pmp_address)
				32'b11111111_11111111_11111111_11111111: pmp_address_NAPOT_ub = 32'b11111111_11111111_11111111_11111111;
				32'b01111111_11111111_11111111_11111111: pmp_address_NAPOT_ub = 32'b11111111_11111111_11111111_11111111;
				32'bx0111111_11111111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b10000000_00000000_00000000_00000000) + (1<<31);
				32'bxx011111_11111111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11000000_00000000_00000000_00000000) + (1<<30);
				32'bxxx01111_11111111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11100000_00000000_00000000_00000000) + (1<<29);
				32'bxxxx0111_11111111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11110000_00000000_00000000_00000000) + (1<<28);
				32'bxxxxx011_11111111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111000_00000000_00000000_00000000) + (1<<27);
				32'bxxxxxx01_11111111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111100_00000000_00000000_00000000) + (1<<26);
				32'bxxxxxxx0_11111111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111110_00000000_00000000_00000000) + (1<<25);
				32'bxxxxxxxx_01111111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_00000000_00000000_00000000) + (1<<24);
				32'bxxxxxxxx_x0111111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_10000000_00000000_00000000) + (1<<23);
				32'bxxxxxxxx_xx011111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11000000_00000000_00000000) + (1<<22);
				32'bxxxxxxxx_xxx01111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11100000_00000000_00000000) + (1<<21);
				32'bxxxxxxxx_xxxx0111_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11110000_00000000_00000000) + (1<<20);
				32'bxxxxxxxx_xxxxx011_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111000_00000000_00000000) + (1<<19);			
				32'bxxxxxxxx_xxxxxx01_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111100_00000000_00000000) + (1<<18);			
				32'bxxxxxxxx_xxxxxxx0_11111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111110_00000000_00000000) + (1<<17);			
				32'bxxxxxxxx_xxxxxxxx_01111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_00000000_00000000) + (1<<16);			
				32'bxxxxxxxx_xxxxxxxx_x0111111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_10000000_00000000) + (1<<15);			
				32'bxxxxxxxx_xxxxxxxx_xx011111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11000000_00000000) + (1<<14);			
				32'bxxxxxxxx_xxxxxxxx_xxx01111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11100000_00000000) + (1<<13);			
				32'bxxxxxxxx_xxxxxxxx_xxxx0111_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11110000_00000000) + (1<<12);			
				32'bxxxxxxxx_xxxxxxxx_xxxxx011_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11111000_00000000) + (1<<11);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxx01_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11111100_00000000) + (1<<10);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxx0_11111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11111110_00000000) + (1<<9);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_01111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11111111_00000000) + (1<<8);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_x0111111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11111111_10000000) + (1<<7);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xx011111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11111111_11000000) + (1<<6);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxx01111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11111111_11100000) + (1<<5);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx0111: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11111111_11110000) + (1<<4);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxx011: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11111111_11111000) + (1<<3);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxx01: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11111111_11111100) + (1<<2);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx0: pmp_address_NAPOT_ub = (pmp_address & 32'b11111111_11111111_11111111_11111110) + (1<<1);
				//default:pmp_address_NAPOT_ub = 0;
		endcase
					
		casex(pmp_address)
				32'b11111111_11111111_11111111_11111111: pmp_address_NAPOT_lb = 0;
				32'b01111111_11111111_11111111_11111111: pmp_address_NAPOT_lb = 0;
				32'bx0111111_11111111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b10000000_00000000_00000000_00000000);
				32'bxx011111_11111111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11000000_00000000_00000000_00000000);
				32'bxxx01111_11111111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11100000_00000000_00000000_00000000);
				32'bxxxx0111_11111111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11110000_00000000_00000000_00000000);
				32'bxxxxx011_11111111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111000_00000000_00000000_00000000);
				32'bxxxxxx01_11111111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111100_00000000_00000000_00000000);
				32'bxxxxxxx0_11111111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111110_00000000_00000000_00000000);
				32'bxxxxxxxx_01111111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_00000000_00000000_00000000);
				32'bxxxxxxxx_x0111111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_10000000_00000000_00000000);
				32'bxxxxxxxx_xx011111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11000000_00000000_00000000);
				32'bxxxxxxxx_xxx01111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11100000_00000000_00000000);
				32'bxxxxxxxx_xxxx0111_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11110000_00000000_00000000);
				32'bxxxxxxxx_xxxxx011_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111000_00000000_00000000);			
				32'bxxxxxxxx_xxxxxx01_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111100_00000000_00000000);			
				32'bxxxxxxxx_xxxxxxx0_11111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111110_00000000_00000000);			
				32'bxxxxxxxx_xxxxxxxx_01111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_00000000_00000000);			
				32'bxxxxxxxx_xxxxxxxx_x0111111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_10000000_00000000);			
				32'bxxxxxxxx_xxxxxxxx_xx011111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11000000_00000000);			
				32'bxxxxxxxx_xxxxxxxx_xxx01111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11100000_00000000);			
				32'bxxxxxxxx_xxxxxxxx_xxxx0111_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11110000_00000000);			
				32'bxxxxxxxx_xxxxxxxx_xxxxx011_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11111000_00000000);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxx01_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11111100_00000000);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxx0_11111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11111110_00000000);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_01111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11111111_00000000);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_x0111111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11111111_10000000);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xx011111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11111111_11000000);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxx01111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11111111_11100000);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx0111: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11111111_11110000);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxx011: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11111111_11111000);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxx01: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11111111_11111100);			
				32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx0: pmp_address_NAPOT_lb = (pmp_address & 32'b11111111_11111111_11111111_11111110);
				//default:pmp_address_NAPOT_lb = 0;
		endcase
		
		
		
		
		address_lb = address[33:2];
		address_ub = address[33:2] + data_size -1;
		
	end


	always@(*)
	begin
		case(mode)
			A0_OFF:match = 1'b0;
			
			A1_TOR:begin

				if(address_lb >= pmp_pre_address && address_ub < pmp_address)   //if pmp_cfg == 0, pmp_pre_address = 0;
					match = 1'b1;
				else
					match = 1'b0;
			end
			
			A2_NA4:begin
				if(address_lb >= pmp_address && address_ub < pmp_address_NA4)   
					match = 1'b1;
				else
					match = 1'b0;
			end
	
			A3_NAPOT:begin
				if(address_lb >= pmp_address_NAPOT_lb && address_ub < pmp_address_NAPOT_ub)
					match = 1'b1;
				else
					match = 1'b0;
			end
				
			//default:match = 1'b0;
		endcase
	end

	always_comb
	begin
		
		case(mode)
			A0_OFF: begin
							assert(match==1'b0);
			end
			
			A1_TOR: begin
				if(match==1'b1)
					assert(address[33:2] >= pmp_pre_address && (address[33:2]+data_size-1) < pmp_address);
				else
					assert(address[33:2] < pmp_pre_address || (address[33:2]+data_size-1) >= pmp_address);
			end
			
			A2_NA4: begin
				if(match==1'b1)
					assert(address[33:2] >= pmp_address && (address[33:2]+data_size-1) < pmp_address_NA4);
				else
					assert(address[33:2] < pmp_address || (address[33:2]+data_size-1) >= pmp_address_NA4);
			end
			
			A3_NAPOT: begin
				if(match==1'b1)
					assert(address[33:2] >= pmp_address_NAPOT_lb && (address[33:2]+data_size-1) < pmp_address_NAPOT_ub);
				else
					assert(address[33:2] < pmp_address_NAPOT_lb || (address[33:2]+data_size-1) >= pmp_address_NAPOT_ub);
			end
		endcase
	end
endmodule
