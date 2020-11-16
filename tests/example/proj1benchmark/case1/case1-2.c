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
    write_csr(pmpcfg0  ,0b10011001100110011001100110011001); // lock=1 & napot & no write 10011001
    write_csr(pmpcfg1  ,0b10011001100110011001100110011001);
    write_csr(pmpcfg2  ,0b10011001100110011001100110011001);
    write_csr(pmpcfg3  ,0b10011001100110011001100110011001);
    write_csr(pmpaddr0 ,0b00000000000000000000000000000000);
    write_csr(pmpaddr1 ,0b00000000000000000000000000000000);
    write_csr(pmpaddr2 ,0b00000000000000000000000000000000);
    write_csr(pmpaddr3 ,0b00000000000000000000000000000000);
    write_csr(pmpaddr4 ,0b00000000000000000000000000000000);
    write_csr(pmpaddr5 ,0b00000000000000000000000000000000);
    write_csr(pmpaddr6 ,0b00000000000000000000000000000000);
    write_csr(pmpaddr7 ,0b00000000000000000000000000000000);
    write_csr(pmpaddr8 ,0b00000000000000000000000000000000);
    write_csr(pmpaddr9 ,0b00000000000000000000000000000000);
    write_csr(pmpaddr10,0b00000000000000000000000000000000);
    write_csr(pmpaddr11,0b00000000000000000000000000000000);
    write_csr(pmpaddr12,0b00000000000000000000000000000000);
    write_csr(pmpaddr13,0b00000000000000000000000000000000);
    write_csr(pmpaddr14,0b00000000000000000000000000000000);
    write_csr(pmpaddr15,0b00000000000000000000000000000111); // 1000~0000

  


    *(int*) 0x00000001 = 42; // io_addr = 000100000001

    if (*(int*) 0x10000001 == 42)
        set_test_fail();
    else
        set_test_pass();

    return 0;
}