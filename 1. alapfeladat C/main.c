#include <reg51.h>
 
sbit be_A = P1^0;
sbit be_B = P1^1;
sbit be_C = P1^2;
sbit be_D = P1^3;
sbit be_E = P1^4;

sbit F = P0^0;

void main(void){
  P1=00;
  P0=00;
  
  do{
    F = ( (~be_A) & (~be_D) ) | ( (~be_E) & (be_A) ) | ( (be_E) & (~be_B) );
  }while(1);
  
}