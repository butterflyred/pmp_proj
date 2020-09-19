typedef struct packed {
    logic       l;
    logic [1:0] res;
    logic [1:0] a;
    logic       x,
                w,
                r;
  } pmpcfg_t;

module PMP #(
    parameter VLEN = xx,
    parameter PLEN = xx,
    parameter PMP_CNT = 16
)
(
    input   pmpcfg_t    [PMP_CNT-1:0]          io_pmpcfg,
    input               [PMP_CNT-1:0][VLEN:0]  io_pmpaddr,
    input                            [1:0]     io_prv,
    input                                      io_req,
    input                            [PLEN:0]  io_addr,
    input                            [1:0]     io_size,
    input                                      io_r,
    input                                      io_w,
    input                                      io_x,
    output                                     io_exception
);

endmodule
