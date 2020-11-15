`timescale 1 ns / 1 ps

`include "defines.v"

`include "clint.v"    
`include "ctrl.v"     
`include "div.v"  
`include "gpio.v"   
`include "id.v"
`include "jtag_dm.v"      
`include "jtag_top.v"
`include "pmp_cfg_block.sv"  
`include "ram.v"   
`include "rib.v"  
`include "timer.v"              
`include "tinyriscv_soc_top.v"  
`include "uart_tx.v"
`include "csr_reg.sv"  
`include "defines.v"  
`include "ex.v"   
`include "id_ex.v"  
`include "if_id.v"
`include "jtag_driver.v"
`include "pc_reg.v"       
`include "PMP.sv"            
`include "regs.v"  
`include "rom.v"  
`include "tinyriscv_soc_tb.sv"  
`include "tinyriscv.sv"


`define TEST_PROG  1
//`define TEST_JTAG  1


// testbench module
module tinyriscv_soc_tb;

    reg clk;
    reg rst;


    always #10 clk = ~clk;     // 50MHz

    wire[`RegBus] x3 = tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[3];
    wire[`RegBus] x26 = tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[26];
    wire[`RegBus] x27 = tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[27];

    integer r,k,j;

`ifdef TEST_JTAG
    reg TCK;
    reg TMS;
    reg TDI;
    wire TDO;

    integer i;
    reg[39:0] shift_reg;
    reg in;
    wire[39:0] req_data = tinyriscv_soc_top_0.u_jtag_top.u_jtag_driver.dtm_req_data;
    wire[4:0] ir_reg = tinyriscv_soc_top_0.u_jtag_top.u_jtag_driver.ir_reg;
    wire dtm_req_valid = tinyriscv_soc_top_0.u_jtag_top.u_jtag_driver.dtm_req_valid;
    wire[31:0] dmstatus = tinyriscv_soc_top_0.u_jtag_top.u_jtag_dm.dmstatus;
`endif

    initial begin
        clk = 0;
        rst = `RstEnable;
`ifdef TEST_JTAG
        TCK = 1;
        TMS = 1;
        TDI = 1;
`endif
        $display("test running...");
        #40
        rst = `RstDisable;
        #200

`ifdef TEST_PROG
        wait(x26 == 32'b1)   // wait sim end, when x26 == 1
        #100
        if (x27 == 32'b1) begin
            $display("~~~~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~");
            $display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~");
            $display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~");
            $display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            // for (r = 0; r < 1024; r++)
            //     $display("x%d = 0x%x", r, tinyriscv_soc_top_0.u_ram._ram[r]);
            $display("csr privilege             = %d", tinyriscv_soc_top_0.u_tinyriscv.u_csr_reg.privilege);
            $display("exception = 0x%x", tinyriscv_soc_top_0.u_tinyriscv.pmp_exception);
            for (j = 0; j < 16; j++)begin
                $display("pmpaddr x%d = %32b", j, tinyriscv_soc_top_0.u_tinyriscv.u_csr_reg.pmp_reg_q.pmpaddr[j]);
                $display("pmpcfg  x%d = %32b", j, tinyriscv_soc_top_0.u_tinyriscv.u_csr_reg.pmp_reg_q.pmpcfg[j]);
            end

        end else begin
            $display("~~~~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display("fail testnum = %2d", x3);
            // for (r = 0; r < 1024; r++)
            //     $display("x%d = 0x%x", r, tinyriscv_soc_top_0.u_ram._ram[r]);
            $display("csr privilege             = %d", tinyriscv_soc_top_0.u_tinyriscv.u_csr_reg.privilege);
            $display("exception = 0x%x", tinyriscv_soc_top_0.u_tinyriscv.pmp_exception);
            for (j = 0; j < 16; j++)begin
                $display("pmpaddr x%d = %32b", j, tinyriscv_soc_top_0.u_tinyriscv.u_csr_reg.pmp_reg_q.pmpaddr[j]);
                $display("pmpcfg  x%d = %32b", j, tinyriscv_soc_top_0.u_tinyriscv.u_csr_reg.pmp_reg_q.pmpcfg[j]);
            end
        end
`endif

`ifdef TEST_JTAG
        // reset
        for (i = 0; i < 8; i++) begin
            TMS = 1;
            TCK = 0;
            #100
            TCK = 1;
            #100
            TCK = 0;
        end

        // IR
        shift_reg = 40'b10001;

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SELECT-DR
        TMS = 1;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SELECT-IR
        TMS = 1;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // CAPTURE-IR
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SHIFT-IR
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SHIFT-IR & EXIT1-IR
        for (i = 5; i > 0; i--) begin
            if (shift_reg[0] == 1'b1)
                TDI = 1'b1;
            else
                TDI = 1'b0;

            if (i == 1)
                TMS = 1;

            TCK = 0;
            #100
            in = TDO;
            TCK = 1;
            #100
            TCK = 0;

            shift_reg = {{(35){1'b0}}, in, shift_reg[4:1]};
        end

        // PAUSE-IR
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // EXIT2-IR
        TMS = 1;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // UPDATE-IR
        TMS = 1;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // dmi write
        shift_reg = {6'h10, {(32){1'b0}}, 2'b10};

        // SELECT-DR
        TMS = 1;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // CAPTURE-DR
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SHIFT-DR
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SHIFT-DR & EXIT1-DR
        for (i = 40; i > 0; i--) begin
            if (shift_reg[0] == 1'b1)
                TDI = 1'b1;
            else
                TDI = 1'b0;

            if (i == 1)
                TMS = 1;

            TCK = 0;
            #100
            in = TDO;
            TCK = 1;
            #100
            TCK = 0;

            shift_reg = {in, shift_reg[39:1]};
        end

        // PAUSE-DR
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // EXIT2-DR
        TMS = 1;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // UPDATE-DR
        TMS = 1;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        $display("ir_reg = 0x%x", ir_reg);
        $display("dtm_req_valid = %d", dtm_req_valid);
        $display("req_data = 0x%x", req_data);

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        $display("dmstatus = 0x%x", dmstatus);

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SELECT-DR
        TMS = 1;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // dmi read
        shift_reg = {6'h11, {(32){1'b0}}, 2'b01};

        // CAPTURE-DR
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SHIFT-DR
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SHIFT-DR & EXIT1-DR
        for (i = 40; i > 0; i--) begin
            if (shift_reg[0] == 1'b1)
                TDI = 1'b1;
            else
                TDI = 1'b0;

            if (i == 1)
                TMS = 1;

            TCK = 0;
            #100
            in = TDO;
            TCK = 1;
            #100
            TCK = 0;

            shift_reg = {in, shift_reg[39:1]};
        end

        // PAUSE-DR
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // EXIT2-DR
        TMS = 1;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // UPDATE-DR
        TMS = 1;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // IDLE
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SELECT-DR
        TMS = 1;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // dmi read
        shift_reg = {6'h11, {(32){1'b0}}, 2'b00};

        // CAPTURE-DR
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SHIFT-DR
        TMS = 0;
        TCK = 0;
        #100
        TCK = 1;
        #100
        TCK = 0;

        // SHIFT-DR & EXIT1-DR
        for (i = 40; i > 0; i--) begin
            if (shift_reg[0] == 1'b1)
                TDI = 1'b1;
            else
                TDI = 1'b0;

            if (i == 1)
                TMS = 1;

            TCK = 0;
            #100
            in = TDO;
            TCK = 1;
            #100
            TCK = 0;

            shift_reg = {in, shift_reg[39:1]};
        end

        #100

        $display("shift_reg = 0x%x", shift_reg[33:2]);
`endif

        $finish;
    end

    // sim timeout
    initial begin
        #1000000
        $display("Time Out.");
        $display("~~~~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~");
        $display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~");
        $display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~");
        $display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~");
        $display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~");
        $display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~");
        $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        $display("fail testnum = %2d", x3);
        for (r = 0; r < 32; r++)
            $display("x%d = 0x%x", r, tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[r]);
        $display("csr privilege: x%d = 0x%x", r, tinyriscv_soc_top_0.u_tinyriscv.u_csr_reg.privilege);
        $display("exception: x%d = 0x%x", r, tinyriscv_soc_top_0.u_tinyriscv.pmp_exception);
        for (j = 0; j < 16; j++)begin
            $display("pmpaddr x%d = %32b", j, tinyriscv_soc_top_0.u_tinyriscv.u_csr_reg.pmp_reg_q.pmpaddr[j]);
            $display("pmpcfg x%d = %32b", j, tinyriscv_soc_top_0.u_tinyriscv.u_csr_reg.pmp_reg_q.pmpcfg[j]);
        end
        $finish;
    end

    // read mem data
    initial begin
        $readmemh ("./inst.data", tinyriscv_soc_top_0.u_rom._rom);
    end

    // generate wave file, used by gtkwave
    initial begin
        $dumpfile("tinyriscv_soc_tb.vcd");
        $dumpvars(0, tinyriscv_soc_tb);
        $monitor("addr = %32b , data = %d",tinyriscv_soc_top_0.u_ram.addr_i,tinyriscv_soc_top_0.u_ram.data_i);
    end

    tinyriscv_soc_top tinyriscv_soc_top_0(
        .clk(clk),
        .rst(rst)/*
        .jtag_TCK(TCK),
        .jtag_TMS(TMS),
        .jtag_TDI(TDI),
        .jtag_TDO(TDO)*/
    );

endmodule
