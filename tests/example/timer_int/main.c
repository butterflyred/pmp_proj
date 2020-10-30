

#include <stdint.h>
#include "../include/utils.h"
static volatile uint32_t count;

int main()
{

*(int*) 0x1 = 42;
#ifdef SIMULATION

    while (1) {
        if (count == 1) {
            count = 0;
            // TODO: do something
            set_test_fail();
            break;
        }
    }

#endif

  return 0;

}


void pmp0_irq_handler()
{
    count++;
}
