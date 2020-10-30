	typedef struct packed {
    logic       l;
    logic [1:0] res;
    logic [1:0] a;
    logic       x,
                w,
                r;
  } pmpcfg_t;

module PMP #(
	parameter	A0_OFF = 2'b00,
	parameter	A1_TOR = 2'b01,
	parameter	A2_NA4 = 2'b10,
	parameter	A3_NAPOT = 2'b11,
    parameter VLEN = 31,
    parameter PLEN = 33,
    parameter PMP_CNT = 16,
 	parameter U_MODE = 2'b00,
	parameter S_MODE = 2'b01,
	parameter M_MODE = 2'b11
)
(
    input   pmpcfg_t    [PMP_CNT-1:0]          io_pmpcfg,    //8 bit pmpcfg 16 entry
    input               [PMP_CNT-1:0][VLEN:0]  io_pmpaddr,   //[15:0] [31:0] io_pmpaddr
    input                            [1:0]     io_prv,
    input                                      io_req,
    input                            [PLEN:0]  io_addr,
    input                            [1:0]     io_size,
    input                                      io_r,
    input                                      io_w,
    input                                      io_x,
    output                                     io_exception
);
	reg [15:0] check;
	wire [15:0] match;

	pmp_cfg_block pmp0 (.address(io_addr), .pmp_pre_address(0), .mode(io_pmpcfg[0].a), .pmp_address(io_pmpaddr[0]), .match(match[0]), .size(io_size));
	pmp_cfg_block pmp1 (.address(io_addr), .pmp_pre_address(io_pmpaddr[0]), .mode(io_pmpcfg[1].a), .pmp_address(io_pmpaddr[1]), .match(match[1]), .size(io_size));
	pmp_cfg_block pmp2 (.address(io_addr), .pmp_pre_address(io_pmpaddr[1]), .mode(io_pmpcfg[2].a), .pmp_address(io_pmpaddr[2]), .match(match[2]), .size(io_size));
	pmp_cfg_block pmp3 (.address(io_addr), .pmp_pre_address(io_pmpaddr[2]), .mode(io_pmpcfg[3].a), .pmp_address(io_pmpaddr[3]), .match(match[3]), .size(io_size));
	pmp_cfg_block pmp4 (.address(io_addr), .pmp_pre_address(io_pmpaddr[3]), .mode(io_pmpcfg[4].a), .pmp_address(io_pmpaddr[4]), .match(match[4]), .size(io_size));
	pmp_cfg_block pmp5 (.address(io_addr), .pmp_pre_address(io_pmpaddr[4]), .mode(io_pmpcfg[5].a), .pmp_address(io_pmpaddr[5]), .match(match[5]), .size(io_size));
	pmp_cfg_block pmp6 (.address(io_addr), .pmp_pre_address(io_pmpaddr[5]), .mode(io_pmpcfg[6].a), .pmp_address(io_pmpaddr[6]), .match(match[6]), .size(io_size));
	pmp_cfg_block pmp7 (.address(io_addr), .pmp_pre_address(io_pmpaddr[6]), .mode(io_pmpcfg[7].a), .pmp_address(io_pmpaddr[7]), .match(match[7]), .size(io_size));
	pmp_cfg_block pmp8 (.address(io_addr), .pmp_pre_address(io_pmpaddr[7]), .mode(io_pmpcfg[8].a), .pmp_address(io_pmpaddr[8]), .match(match[8]), .size(io_size));
	pmp_cfg_block pmp9 (.address(io_addr), .pmp_pre_address(io_pmpaddr[8]), .mode(io_pmpcfg[9].a), .pmp_address(io_pmpaddr[9]), .match(match[9]), .size(io_size));
	pmp_cfg_block pmp10 (.address(io_addr), .pmp_pre_address(io_pmpaddr[9]), .mode(io_pmpcfg[10].a), .pmp_address(io_pmpaddr[10]), .match(match[10]), .size(io_size));
	pmp_cfg_block pmp11 (.address(io_addr), .pmp_pre_address(io_pmpaddr[10]), .mode(io_pmpcfg[11].a), .pmp_address(io_pmpaddr[11]), .match(match[11]), .size(io_size));
	pmp_cfg_block pmp12 (.address(io_addr), .pmp_pre_address(io_pmpaddr[11]), .mode(io_pmpcfg[12].a), .pmp_address(io_pmpaddr[12]), .match(match[12]), .size(io_size));
	pmp_cfg_block pmp13 (.address(io_addr), .pmp_pre_address(io_pmpaddr[12]), .mode(io_pmpcfg[13].a), .pmp_address(io_pmpaddr[13]), .match(match[13]), .size(io_size));
	pmp_cfg_block pmp14 (.address(io_addr), .pmp_pre_address(io_pmpaddr[13]), .mode(io_pmpcfg[14].a), .pmp_address(io_pmpaddr[14]), .match(match[14]), .size(io_size));
	pmp_cfg_block pmp15 (.address(io_addr), .pmp_pre_address(io_pmpaddr[14]), .mode(io_pmpcfg[15].a), .pmp_address(io_pmpaddr[15]), .match(match[15]), .size(io_size));


	int i;
	
	always@(*)
	begin

		

			for(i=0; i<16; i++)
			begin
				if(io_req && (io_prv == M_MODE) && (io_pmpcfg[i].l == 1'b1) )
					if( (io_pmpcfg[i].w & io_w) || (io_pmpcfg[i].r & io_r) || (io_pmpcfg[i].x & io_x) )
						if(match[i] == 0)
							check[i] = 1'b0;
						else 
							check[i] = 1'b1;
					else
						check[i] = 1'b0;
				else if(io_req && (io_prv == M_MODE) && (io_pmpcfg[i].l == 1'b0))
					check[i] = 1'b1;

				
			
				else if((io_req && (io_prv == S_MODE)) || (io_req && (io_prv == U_MODE)) && (io_pmpcfg[i].l == 1'b1 || io_pmpcfg[i].l == 1'b0) ) //may delete
					if( (io_pmpcfg[i].w & io_w) || (io_pmpcfg[i].r & io_r) || (io_pmpcfg[i].x & io_x) )
						if(match[i] == 0)
							check[i] = 1'b0;
						else 
							check[i] = 1'b1;
					else
						check[i] = 1'b0;
				else  //req != 1
					check[i] = 1'b0;
			end
	
	
  end
	assign io_exception = (check [15:0] == 16'b1111_1111_1111_1111)?1'b0:1'b1;
	
	/*
	if(io_req ==1)
	begin
		generate
				for(genvar i=0; i<PMP_CNT; i++)
				begin
					if(io_pmpcfg[i].l == 1'b1)
						if(io_pmpcfg[i].a != A0_OFF)
							check_ex = 0;
					else
						if(io_pmpcfg[i].l)
				end
				
				
				
		endgenerate
	end
	*/
	
//	always_comb
//	begin
//	if(io_prv == M_MODE)
//	begin
//		logic check_ex = 1'b1;
//		generate
//			for(genvar i=0; i<PMP_CNT; i++)
//			begin
//				if(io_pmpcfg[i].l == 1'b1)
//					if(io_pmpcfg[i].a != A0_OFF)
//						check_ex &= 1'b0;
//				else
//					check_ex = 1'b1;
//			end
//			if(check_ex == 1'b1)
//				assert(io_exception == 1'b0);
//		endgenerate

//	end
//	end

	// always_comb
	// begin
	// if(io_prv == M_MODE)
	// begin
	// 	static logic check_ex = 1'b1;
	// 	//generate
	// 		for(int i=0; i<PMP_CNT; i++)
	// 		begin
	// 			if(io_pmpcfg[i].l == 1'b1)
	// 				if(io_pmpcfg[i].a != A0_OFF)
	// 					check_ex &= 1'b0;
	// 			else
	// 				check_ex = 1'b1;
	// 		end
	// 		if(check_ex == 1'b1)
	// 			assert(io_exception == 1'b1);
	// 	//endgenerate

	// end
	// end
	
	
endmodule

