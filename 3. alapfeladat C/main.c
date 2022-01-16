#include <reg51.h>

sbit em1 = P1^0;
sbit em2 = P1^1;
sbit em3 = P1^2;
sbit em4 = P1^3;

bit kapcs = 0;

unsigned int timerCounter = 0;

void initInterrupt(void);
void initTimer0(void);
void lampOff(void);

void main(void){
  
  P0=0;
  P1=0;
  
  
  initInterrupt();
  initTimer0();
  
  while(1){
    if( em1 || em2 || em3 || em4 ){
      P1=0;
      
      if( !kapcs ){
        P0=0x0f;
        TR0 = 1;
        kapcs=1;
        
      }else{
        lampOff();
      }
      
    }  
  }

}


void initInterrupt(void){
  ET0 = 1;
  EA = 1;
}

void initTimer0(void){
  TMOD &= 0x0f;
  TMOD |= 0x02;
  
  TH0 = 6;
  TL0 = 0;
  
  timerCounter = 60000;
  
}

void lampOff(void){
  P0=00;
  TR0=0;
  timerCounter = 60000;
  TL0=0;
  kapcs=0;
}

void isrTimer0(void) interrupt 1{
  
   if( timerCounter != 0 ){
    timerCounter--;
   }else{
    lampOff();
   }

}