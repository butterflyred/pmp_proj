//========================================================
// Author: 		Chih-Cheng Ting
// Filename:	main.c
// Description: C code for write data to illegal address
//========================================================
#include <stdint.h>
#include "../include/utils.h"

int main()
{

    int array1[2] = {0, 1};
    int *a;

    // illegal address: &array1+0xF0000
    a = (&array1 + 122880);

    *a = 9;

    if (array1[245760] == 9)
        // success to write data at illegal address
        set_test_fail();
    else
        set_test_pass();

    return 0;
}
