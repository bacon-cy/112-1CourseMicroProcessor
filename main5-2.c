#include "xc.h"

extern unsigned int multi_signed( unsigned char a, unsigned char b);

void main(void){
	volatile unsigned int res = multi_signed (-30, 4);
	while(1);
	return;
}