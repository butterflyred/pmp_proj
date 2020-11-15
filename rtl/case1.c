//========================================================
// Author: 		Chih-Cheng Ting
// Filename:	main.c
// Description: C code for write data to illegal address
//========================================================
#include <stdint.h>
#include "../include/utils.h"

int main()
{
    write_csr(mstatus,0x3); // privilege M
    write_csr(pmpcfg0  ,0b10011111100111111001111110011111); // lock=1 & napot & no write 10011111
    write_csr(pmpcfg1  ,0b10011111100111111001111110011111);
    write_csr(pmpcfg2  ,0b10011111100111111001111110011111);
    write_csr(pmpcfg3  ,0b10011111100111111001111110011111);
    write_csr(pmpaddr0 ,0b00000000000000001111111111111111);
    write_csr(pmpaddr1 ,0b00000000000000000111111111111111);
    write_csr(pmpaddr2 ,0b00000000000000000011111111111111);
    write_csr(pmpaddr3 ,0b00000000000000000001111111111111);
    write_csr(pmpaddr4 ,0b00000000000000000000111111111111);
    write_csr(pmpaddr5 ,0b00000000000000000000011111111111);
    write_csr(pmpaddr6 ,0b00000000000000000000001111111111);
    write_csr(pmpaddr7 ,0b00000000000000000000000111111111);
    write_csr(pmpaddr8 ,0b00000000000000000000000011111111);
    write_csr(pmpaddr9 ,0b00000000000000000000000001111111);
    write_csr(pmpaddr10,0b00000000000000000000000000111111);
    write_csr(pmpaddr11,0b00000000000000000000000000011111);
    write_csr(pmpaddr12,0b00000000000000000000000000001111);
    write_csr(pmpaddr13,0b00000000000000000000000000000111);
    write_csr(pmpaddr14,0b00000000000000000000000000000011);
    write_csr(pmpaddr15,0b00000000000000000000000000000001); // no write

  
    *(int*) 0x1 = 9;

    if ((*(int*) 0x1) == 9)
        // success to write data at illegal address
        set_test_fail();
    else
        set_test_pass();

    return 0;
}