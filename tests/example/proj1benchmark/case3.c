//========================================================
// Author: 		Chih-Cheng Ting
// Filename:	main.c
// Description: C code for write data to illegal address
//========================================================
#include <stdint.h>
#include "../include/utils.h"

int main()
{
    write_csr(mstatus,0x1); // privilege U
    write_csr(pmpcfg0  ,0b10011100100111001001110010011100); // lock=1 & napot & no write 10011100
    write_csr(pmpcfg1  ,0b10011100100111001001110010011100);
    write_csr(pmpcfg2  ,0b10011100100111001001110010011100);
    write_csr(pmpcfg3  ,0b10011100100111001001110010011100);
    write_csr(pmpaddr0 ,0b00000000000000001111111111111111);
    write_csr(pmpaddr1 ,0b00000000000000000111111111111111);
    write_csr(pmpaddr2 ,0b00000000000000000011111111111111);
    write_csr(pmpaddr3 ,0b00000000000000000001111111111111);
    write_csr(pmpaddr4 ,0b00000000000000000000111111111111);
    write_csr(pmpaddr5 ,0b00000000000000000000011111111111);
    write_csr(pmpaddr6 ,0b00000000000000000000001111111111); //* 1000 0000 0000 ~ 000000000000
    write_csr(pmpaddr7 ,0b00000000000000000000000111111111); //* 100 0000 0000 ~ 00000000000
    write_csr(pmpaddr8 ,0b00000000000000000000000011111111); //* 10 0000 0000 ~ 0000000000
    write_csr(pmpaddr9 ,0b00000000000000000000000001111111); //* 1 0000 0000 ~ 000000000
    write_csr(pmpaddr10,0b00000000000000000000000000111111); //  10000000 ~ 00000000
    write_csr(pmpaddr11,0b00000000000000000000000000011111); //  1000000 ~ 0000000
    write_csr(pmpaddr12,0b00000000000000000000000000001111); //  100000 ~ 000000
    write_csr(pmpaddr13,0b00000000000000000000000000000111); //  10000 ~ 00000
    write_csr(pmpaddr14,0b00000000000000000000000000000011); //  1000 ~ 0000
    write_csr(pmpaddr15,0b00000000000000000000000000000001); //  100 ~ 000

  


    *(int*) 0x10000101 = 42; // io_addr = 000100000001

    if (*(int*) 0x10000101 == 42)
        set_test_fail();
    else
        set_test_pass();

    return 0;
}