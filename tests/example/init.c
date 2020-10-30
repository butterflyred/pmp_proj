#include <stdint.h>

#include "include/utils.h"


extern void trap_entry();

extern void timer0_irq_handler() __attribute__((weak));
extern void pmp0_irq_handler() __attribute__((weak));


void trap_handler(uint32_t mcause)
{
    // we have only timer0 interrupt here
    pmp0_irq_handler();
    timer0_irq_handler();
}

void _init()
{
    write_csr(mtvec, &trap_entry);
    write_csr(mstatus,0x3); // privilege
    write_csr(pmpcfg0,0b00011101000111010001110100011101);  // napot & no write 00011101
    write_csr(pmpcfg1,0b00011101000111010001110100011101);
    write_csr(pmpcfg2,0b00011101000111010001110100011101);
    write_csr(pmpcfg3,0b00011101000111010001110100011101);
    write_csr(pmpaddr0,0b00000000000000000000000000000000);
    write_csr(pmpaddr1,0b00000000000000000111111111111111);
    write_csr(pmpaddr2,0b00000000000000000011111111111111);
    write_csr(pmpaddr3,0b00000000000000000001111111111111);
    write_csr(pmpaddr4,0b00000000000000000000111111111111);
    write_csr(pmpaddr5,0b00000000000000000000011111111111);
    write_csr(pmpaddr6,0b00000000000000000000001111111111);
    write_csr(pmpaddr7,0b00000000000000000000000111111111);
    write_csr(pmpaddr8,0b00000000000000000000000011111111);
    write_csr(pmpaddr9,0b00000000000000000000000001111111);
    write_csr(pmpaddr10,0b00000000000000000000000000111111);
    write_csr(pmpaddr11,0b00000000000000000000000000011111);
    write_csr(pmpaddr12,0b00000000000000000000000000001111);
    write_csr(pmpaddr13,0b00000000000000000000000000000111);
    write_csr(pmpaddr14,0b00000000000000000000000000000011);
    write_csr(pmpaddr15,0b00000000000000000000000000000001);
}
