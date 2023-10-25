#include <xc.h>

extern unsigned int lcm(unsigned int a, unsigned int b);
void main(void) {
    volatile unsigned int res = lcm(40, 140);
    while(1);
    return;
}
