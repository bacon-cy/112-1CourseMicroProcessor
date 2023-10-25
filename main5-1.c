#include <xc.h>

extern unsigned char is_square(unsigned int a);

void main(void){
	volatile unsigned char ans = is_square(9);
	while(1);
	return;
}
