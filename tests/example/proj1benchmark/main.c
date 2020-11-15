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

    // illegal address: &array1+0xF00 111100000000 3840
    a = (&array1 + 480);

    *a = 90;

    if (array1[960] == 90) // 3840 / 4 = 960
        // success to write data at illegal address
        set_test_fail();
    else
        set_test_pass();

    return 0;
}
