#include <reg51.h>

/* --- DEKLARÁCIÓK --- */
sbit gep1 = P1^0;
sbit gep2 = P1^1;
sbit gep3 = P1^2;
sbit checkback = P1^7;

sbit lamp1 = P0^0;
sbit lamp2 = P0^1;
sbit lamp3 = P0^2;

unsigned int timerCounter = 0;
char timeoutCount = 0;
char countLamp3=0;


/* --- FÜGGVÉNYEK --- */
void initTimer0(void);
void initInterrupt(void);
void resetTimer0(void);

void main (void){
  P1=00;
  P0=00;
  
  initTimer0();
  initInterrupt();
  
  
  while(1){
  
    if( checkback ){
      lamp2=0;
      
      if( countLamp3 > 4 ){
        lamp3=0;
        countLamp3=0;
      }
      
      checkback = 0;
    }
    
  
    if( (gep1&gep3) | (gep1&gep2) | (gep2&gep3) ){
      
      TR0 = 1;
      
      
    } else {
      
      resetTImer0();
      lamp1=0;
      
    } //endif
  
  
  }
  

}

void isrTimer0(void) interrupt 1{
  
  if( timerCounter ){
  
    timerCounter--;
  
  }else{
    timeoutCount++;
    
    if( timeoutCount ){
      lamp1=1;
      timerCounter = 25000;
      if( timeoutCount > 1 ){
        lamp2=1;
        resetTimer0();
      }
      
      
      
      if( countLamp3 < 5 ){
        countLamp3++;
      }
      if( countLamp3 == 5){
        lamp3 = 1;
      }
      
      
    }
    
    
  }

}

void initTimer0(void){
  
  TMOD = 2;
  
  TH0 = 56;
  TL0 = 0;
  
  timerCounter = 25000;
  
}

void initInterrupt(void){
  EA = 1;
  ET0 = 1;
}

void resetTimer0(void){
  TR0=0;
  TL0=0;
  timerCounter = 25000;
  
}


