#include <reg51.h>

sbit G1 = P1^0;
sbit G2 = P1^1;

bit kapcsolt = 0;

void initInterrupt(void);
void initTimer0(void);
void autoOff(void);

unsigned int timerCounter = 0;

void main(void){
    
    P1=00;
    
    initInterrupt();
    initTimer0();
    
    
    while(1){
      
      if(  !(kapcsolt) && (G1 ^ G2) ){
        TR0=1;    
        kapcsolt = 1;
      }
      
      if( kapcsolt && G1 && G2 ){
        TR0=0;
        kapcsolt = 0;
      }
    
    }
    
}

void initInterrupt(void){
  EA = 1;
  ET0 = 1;
}
void initTimer0(void){
  TMOD = 0x02;
  
  TH0 = 56;
  TL0=0;
  
  //timerCounter = 2500;
  timerCounter = 10000;
}

void autoOff(void){
  TR0=0;
  P1=00;
  timerCounter = 10000;
  TL0=00;
  kapcsolt = 0;
}

void isrTimer0(void) interrupt 1{
  
  if( timerCounter ){
    timerCounter--;
  }else{
    autoOff();
  }

}
