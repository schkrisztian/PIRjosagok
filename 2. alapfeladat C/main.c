#include <reg51.h>

sbit bA = P1^0;
sbit bB = P1^1;
sbit bC = P1^2;
sbit bD = P1^3;

sbit sziv1 = P0^0;
sbit sziv2 = P0^1;
sbit lamp = P0^2;

void main(void){
  P1=00;
  P0=00;

  do{
    
    sziv1 = (bA&~bB&~bC&~bD)| (~bA&bB&~bC&~bD) | (~bA&~bB&bC&~bD) | (bA&bB&bC&~bD) | (~bA&~bB&~bC&bD) | (bA&bB&~bC&bD) | (bA&~bB&bC&bD) | (~bA&bB&bC&bD) | (bA&bB&bC&bD);
    
    sziv2 = (bB&bA) | (bC&bA) | (bC&bB) | (bD&bA) | (bD&bB) | (bD&bC);
    
    lamp = (bA&bB&bC&bD);
    
  }while(1);

}