 /*                                                                      
 Copyright 2020 Blue Liang, liangkangnan@163.com
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
 Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */

`include "defines.v"

// CSR寄存器模块
module csr_reg(

    input wire clk,
    input wire rst,

    // form ex
    input wire we_i,
    input wire[`MemAddrBus] raddr_i,
    input wire[`MemAddrBus] waddr_i,
    input wire[`RegBus] data_i,

    // from clint
    input wire clint_we_i,
    input wire[`MemAddrBus] clint_raddr_i,
    input wire[`MemAddrBus] clint_waddr_i,
    input wire[`RegBus] clint_data_i,

    // to clint
    output reg[`RegBus] clint_data_o,

    // to ex
    output reg[`RegBus] data_o,

    output reg[1:0] privilege_o,
    output logic  [15:0] [31:0] pmp_addr_o,
    output logic  [15:0] [7:0]  pmp_cfg_o

    );

    typedef struct packed {
        logic  [15:0] [31:0] pmpaddr;
        logic  [15:0] [ 7:0] pmpcfg;
    } Pmp_t;

    reg[`DoubleRegBus] cycle;
    reg[`RegBus] mtvec;
    reg[`RegBus] mcause;
    reg[`RegBus] mepc;
    reg[1:0] privilege;
    Pmp_t pmp_reg_q;

    assign privilege_o    = privilege;
    assign pmp_addr_o     = pmp_reg_q.pmpaddr;
    assign pmp_cfg_o      = pmp_reg_q.pmpcfg;

    
    always_ff @(posedge clk, negedge rst)
    begin
        for(int j=0;j<16;j++)
        begin
            if (rst == `RstEnable)
            begin
                pmp_reg_q.pmpcfg[j]   <= '0;
                pmp_reg_q.pmpaddr[j]  <= '0;
            end
        end
    end


    // cycle counter
    // 复位撤销后就一直计数
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            cycle <= {`ZeroWord, `ZeroWord};
        end else begin
            cycle <= cycle + 1'b1;
        end
    end

    // write reg
    // 写寄存器操作
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            mtvec <= `ZeroWord;
            mcause <= `ZeroWord;
            mepc <= `ZeroWord;
            privilege <= `M_MODE;
        end else begin
            // 优先响应ex模块的写操作
            if (we_i == `WriteEnable) begin
                case (waddr_i[11:0])
                    `CSR_MTVEC: begin
                        mtvec <= data_i;
                    end
                    `CSR_MSTATUS: begin
                        privilege <= data_i[1:0];
                    end
                    `CSR_MCAUSE: begin
                        mcause <= data_i;
                    end
                    `CSR_MEPC: begin
                        mepc <= data_i;
                    end
                    `CSR_PMPCFG0: begin
                        pmp_reg_q.pmpcfg[0] <= data_i[7:0];
                        pmp_reg_q.pmpcfg[1] <= data_i[15:8];
                        pmp_reg_q.pmpcfg[2] <= data_i[23:16];
                        pmp_reg_q.pmpcfg[3] <= data_i[31:24];
                    end
                    `CSR_PMPCFG1: begin
                        pmp_reg_q.pmpcfg[4] <= data_i[7:0];
                        pmp_reg_q.pmpcfg[5] <= data_i[15:8];
                        pmp_reg_q.pmpcfg[6] <= data_i[23:16];
                        pmp_reg_q.pmpcfg[7] <= data_i[31:24];
                    end
                    `CSR_PMPCFG2: begin
                        pmp_reg_q.pmpcfg[8] <= data_i[7:0];
                        pmp_reg_q.pmpcfg[9] <= data_i[15:8];
                        pmp_reg_q.pmpcfg[10] <= data_i[23:16];
                        pmp_reg_q.pmpcfg[11] <= data_i[31:24];
                    end
                    `CSR_PMPCFG3: begin
                        pmp_reg_q.pmpcfg[12] <= data_i[7:0];
                        pmp_reg_q.pmpcfg[13] <= data_i[15:8];
                        pmp_reg_q.pmpcfg[14] <= data_i[23:16];
                        pmp_reg_q.pmpcfg[15] <= data_i[31:24];
                    end
                    `CSR_PMPADDR0: begin
                        pmp_reg_q.pmpaddr[0] <= data_i;
                    end
                    `CSR_PMPADDR1: begin
                        pmp_reg_q.pmpaddr[1] <= data_i;
                    end
                    `CSR_PMPADDR2: begin
                        pmp_reg_q.pmpaddr[2] <= data_i;
                    end
                    `CSR_PMPADDR3: begin
                        pmp_reg_q.pmpaddr[3] <= data_i;
                    end
                    `CSR_PMPADDR4: begin
                        pmp_reg_q.pmpaddr[4] <= data_i;
                    end
                    `CSR_PMPADDR5: begin
                        pmp_reg_q.pmpaddr[5] <= data_i;
                    end
                    `CSR_PMPADDR6: begin
                        pmp_reg_q.pmpaddr[6] <= data_i;
                    end
                    `CSR_PMPADDR7: begin
                        pmp_reg_q.pmpaddr[7] <= data_i;
                    end
                    `CSR_PMPADDR8: begin
                        pmp_reg_q.pmpaddr[8] <= data_i;
                    end
                    `CSR_PMPADDR9: begin
                        pmp_reg_q.pmpaddr[9] <= data_i;
                    end
                    `CSR_PMPADDR10: begin
                        pmp_reg_q.pmpaddr[10] <= data_i;
                    end
                    `CSR_PMPADDR11: begin
                        pmp_reg_q.pmpaddr[11] <= data_i;
                    end
                    `CSR_PMPADDR12: begin
                        pmp_reg_q.pmpaddr[12] <= data_i;
                    end
                    `CSR_PMPADDR13: begin
                        pmp_reg_q.pmpaddr[13] <= data_i;
                    end
                    `CSR_PMPADDR14: begin
                        pmp_reg_q.pmpaddr[14] <= data_i;
                    end
                    `CSR_PMPADDR15: begin
                        pmp_reg_q.pmpaddr[15] <= data_i;
                    end
                    default: begin

                    end
                endcase
            // clint模块写操作
            end else if (clint_we_i == `WriteEnable) begin
                case (clint_waddr_i[11:0])
                    `CSR_MTVEC: begin
                        mtvec <= clint_data_i;
                    end
                    `CSR_MSTATUS: begin
                        privilege <= clint_data_i[1:0];
                    end
                    `CSR_MCAUSE: begin
                        mcause <= clint_data_i;
                    end
                    `CSR_MEPC: begin
                        mepc <= clint_data_i;
                    end
                    `CSR_PMPCFG0: begin
                        pmp_reg_q.pmpcfg[0] <= clint_data_i[7:0];
                        pmp_reg_q.pmpcfg[1] <= clint_data_i[15:8];
                        pmp_reg_q.pmpcfg[2] <= clint_data_i[23:16];
                        pmp_reg_q.pmpcfg[3] <= clint_data_i[31:24];
                    end
                    `CSR_PMPCFG1: begin
                        pmp_reg_q.pmpcfg[4] <= clint_data_i[7:0];
                        pmp_reg_q.pmpcfg[5] <= clint_data_i[15:8];
                        pmp_reg_q.pmpcfg[6] <= clint_data_i[23:16];
                        pmp_reg_q.pmpcfg[7] <= clint_data_i[31:24];
                    end
                    `CSR_PMPCFG2: begin
                        pmp_reg_q.pmpcfg[8] <= clint_data_i[7:0];
                        pmp_reg_q.pmpcfg[9] <= clint_data_i[15:8];
                        pmp_reg_q.pmpcfg[10] <= clint_data_i[23:16];
                        pmp_reg_q.pmpcfg[11] <= clint_data_i[31:24];
                    end
                    `CSR_PMPCFG3: begin
                        pmp_reg_q.pmpcfg[12] <= clint_data_i[7:0];
                        pmp_reg_q.pmpcfg[13] <= clint_data_i[15:8];
                        pmp_reg_q.pmpcfg[14] <= clint_data_i[23:16];
                        pmp_reg_q.pmpcfg[15] <= clint_data_i[31:24];
                    end
                    `CSR_PMPADDR0: begin
                        pmp_reg_q.pmpaddr[0] <= clint_data_i;
                    end
                    `CSR_PMPADDR1: begin
                        pmp_reg_q.pmpaddr[1] <= clint_data_i;
                    end
                    `CSR_PMPADDR2: begin
                        pmp_reg_q.pmpaddr[2] <= clint_data_i;
                    end
                    `CSR_PMPADDR3: begin
                        pmp_reg_q.pmpaddr[3] <= clint_data_i;
                    end
                    `CSR_PMPADDR4: begin
                        pmp_reg_q.pmpaddr[4] <= clint_data_i;
                    end
                    `CSR_PMPADDR5: begin
                        pmp_reg_q.pmpaddr[5] <= clint_data_i;
                    end
                    `CSR_PMPADDR6: begin
                        pmp_reg_q.pmpaddr[6] <= clint_data_i;
                    end
                    `CSR_PMPADDR7: begin
                        pmp_reg_q.pmpaddr[7] <= clint_data_i;
                    end
                    `CSR_PMPADDR8: begin
                        pmp_reg_q.pmpaddr[8] <= clint_data_i;
                    end
                    `CSR_PMPADDR9: begin
                        pmp_reg_q.pmpaddr[9] <= clint_data_i;
                    end
                    `CSR_PMPADDR10: begin
                        pmp_reg_q.pmpaddr[10] <= clint_data_i;
                    end
                    `CSR_PMPADDR11: begin
                        pmp_reg_q.pmpaddr[11] <= clint_data_i;
                    end
                    `CSR_PMPADDR12: begin
                        pmp_reg_q.pmpaddr[12] <= clint_data_i;
                    end
                    `CSR_PMPADDR13: begin
                        pmp_reg_q.pmpaddr[13] <= clint_data_i;
                    end
                    `CSR_PMPADDR14: begin
                        pmp_reg_q.pmpaddr[14] <= clint_data_i;
                    end
                    `CSR_PMPADDR15: begin
                        pmp_reg_q.pmpaddr[15] <= clint_data_i;
                    end
                    default: begin

                    end
                endcase
            end
        end
    end

    // read reg
    // ex模块读CSR寄存器
    always @ (*) begin
        if (rst == `RstEnable) begin
            data_o <= `ZeroWord;
        end else begin
            case (raddr_i[11:0])
                `CSR_CYCLE: begin
                    data_o <= cycle[31:0];
                end
                `CSR_CYCLEH: begin
                    data_o <= cycle[63:32];
                end
                `CSR_MTVEC: begin
                    data_o <= mtvec;
                end
                `CSR_MSTATUS: begin
                    data_o <= {30'h0, privilege};
                end
                `CSR_MCAUSE: begin
                    data_o <= mcause;
                end
                `CSR_MEPC: begin
                    data_o <= mepc;
                end
                `CSR_PMPCFG0: begin
                     data_o <= pmp_reg_q.pmpcfg[0];
                     data_o <= pmp_reg_q.pmpcfg[1];
                     data_o <= pmp_reg_q.pmpcfg[2];
                     data_o <= pmp_reg_q.pmpcfg[3];
                end
                `CSR_PMPCFG1: begin
                     data_o <= pmp_reg_q.pmpcfg[4];
                     data_o <= pmp_reg_q.pmpcfg[5];
                     data_o <= pmp_reg_q.pmpcfg[6];
                     data_o <= pmp_reg_q.pmpcfg[7];
                end
                `CSR_PMPCFG2: begin
                     data_o <= pmp_reg_q.pmpcfg[8];
                     data_o <= pmp_reg_q.pmpcfg[9];
                     data_o <= pmp_reg_q.pmpcfg[10];
                     data_o <= pmp_reg_q.pmpcfg[11];
                end
                `CSR_PMPCFG3: begin
                     data_o <= pmp_reg_q.pmpcfg[12];
                     data_o <= pmp_reg_q.pmpcfg[13];
                     data_o <= pmp_reg_q.pmpcfg[14];
                     data_o <= pmp_reg_q.pmpcfg[15];
                end
                `CSR_PMPADDR0: begin
                    data_o <= pmp_reg_q.pmpaddr[0];
                end
                `CSR_PMPADDR1: begin
                    data_o <= pmp_reg_q.pmpaddr[1];
                end
                `CSR_PMPADDR2: begin
                    data_o <= pmp_reg_q.pmpaddr[2];
                end
                `CSR_PMPADDR3: begin
                    data_o <= pmp_reg_q.pmpaddr[3];
                end
                `CSR_PMPADDR4: begin
                    data_o <= pmp_reg_q.pmpaddr[4];
                end
                `CSR_PMPADDR5: begin
                    data_o <= pmp_reg_q.pmpaddr[5];
                end
                `CSR_PMPADDR6: begin
                    data_o <= pmp_reg_q.pmpaddr[6];
                end
                `CSR_PMPADDR7: begin
                    data_o <= pmp_reg_q.pmpaddr[7];
                end
                `CSR_PMPADDR8: begin
                    data_o <= pmp_reg_q.pmpaddr[8];
                end
                `CSR_PMPADDR9: begin
                    data_o <= pmp_reg_q.pmpaddr[9];
                end
                `CSR_PMPADDR10: begin
                    data_o <= pmp_reg_q.pmpaddr[10];
                end
                `CSR_PMPADDR11: begin
                    data_o <= pmp_reg_q.pmpaddr[11];
                end
                `CSR_PMPADDR12: begin
                    data_o <= pmp_reg_q.pmpaddr[12];
                end
                `CSR_PMPADDR13: begin
                    data_o <= pmp_reg_q.pmpaddr[13];
                end
                `CSR_PMPADDR14: begin
                    data_o <= pmp_reg_q.pmpaddr[14];
                end
                `CSR_PMPADDR15: begin
                    data_o <= pmp_reg_q.pmpaddr[15];
                end
                default: begin
                    data_o <= `ZeroWord;
                end
            endcase
        end
    end

    // read reg
    // clint模块读CSR寄存器
    always @ (*) begin
        if (rst == `RstEnable) begin
            clint_data_o <= `ZeroWord;
        end else begin
            case (clint_raddr_i[11:0])
                `CSR_CYCLE: begin
                    clint_data_o <= cycle[31:0];
                end
                `CSR_CYCLEH: begin
                    clint_data_o <= cycle[63:32];
                end
                `CSR_MTVEC: begin
                    clint_data_o <= mtvec;
                end
                `CSR_MSTATUS: begin
                    clint_data_o <= {30'h0, privilege};
                end
                `CSR_MCAUSE: begin
                    clint_data_o <= mcause;
                end
                `CSR_MEPC: begin
                    clint_data_o <= mepc;
                end
                `CSR_PMPCFG0: begin
                     clint_data_o <= pmp_reg_q.pmpcfg[0];
                     clint_data_o <= pmp_reg_q.pmpcfg[1];
                     clint_data_o <= pmp_reg_q.pmpcfg[2];
                     clint_data_o <= pmp_reg_q.pmpcfg[3];
                end
                `CSR_PMPCFG1: begin
                     clint_data_o <= pmp_reg_q.pmpcfg[4];
                     clint_data_o <= pmp_reg_q.pmpcfg[5];
                     clint_data_o <= pmp_reg_q.pmpcfg[6];
                     clint_data_o <= pmp_reg_q.pmpcfg[7];
                end
                `CSR_PMPCFG2: begin
                     clint_data_o <= pmp_reg_q.pmpcfg[8];
                     clint_data_o <= pmp_reg_q.pmpcfg[9];
                     clint_data_o <= pmp_reg_q.pmpcfg[10];
                     clint_data_o <= pmp_reg_q.pmpcfg[11];
                end
                `CSR_PMPCFG3: begin
                     clint_data_o <= pmp_reg_q.pmpcfg[12];
                     clint_data_o <= pmp_reg_q.pmpcfg[13];
                     clint_data_o <= pmp_reg_q.pmpcfg[14];
                     clint_data_o <= pmp_reg_q.pmpcfg[15];
                end
                `CSR_PMPADDR0: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[0];
                end
                `CSR_PMPADDR1: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[1];
                end
                `CSR_PMPADDR2: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[2];
                end
                `CSR_PMPADDR3: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[3];
                end
                `CSR_PMPADDR4: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[4];
                end
                `CSR_PMPADDR5: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[5];
                end
                `CSR_PMPADDR6: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[6];
                end
                `CSR_PMPADDR7: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[7];
                end
                `CSR_PMPADDR8: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[8];
                end
                `CSR_PMPADDR9: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[9];
                end
                `CSR_PMPADDR10: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[10];
                end
                `CSR_PMPADDR11: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[11];
                end
                `CSR_PMPADDR12: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[12];
                end
                `CSR_PMPADDR13: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[13];
                end
                `CSR_PMPADDR14: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[14];
                end
                `CSR_PMPADDR15: begin
                    clint_data_o <= pmp_reg_q.pmpaddr[15];
                end
                default: begin
                    clint_data_o <= `ZeroWord;
                end
            endcase
        end
    end

endmodule
