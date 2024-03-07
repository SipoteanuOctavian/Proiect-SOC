#include <inavr.h> 
#include <iom16.h>

unsigned char intrare_automat=0;
unsigned short iesire_automat=0;
unsigned char stare_automat=0;

extern void initializare(void);/* Prototipul functiei ASM */
extern void c_intrerupere();
extern void ext_intrerupere();
extern void beculet(unsigned char luminozitate);

void main(void)
{
  DDRD = 0x80;/* Initializeaza porturile de I/O*/
  DDRB = 0xFF;
  initializare();
  
  __enable_interrupt();
  while(1)/* Bucla infinit?*/ 
  {	
    switch(stare_automat)
    {
    case 0://starea 0, astept semnal de la senzor
      {
        if(intrare_automat==1)//am primit semnalul de la senzor
	{
	  TCNT1=0;
	  stare_automat=1;
	  TCCR1B = (1<<CS11)|(1<<CS10)|(0<<ICES1);
	}
	break;
      }
      
      
    case 1://starea 1, sunt in semnal si astept sfarsitul lui
      {
        if(intrare_automat==0)//s-a terminat semnalul de la senzor
        {
          iesire_automat= TCNT1;//salvez valoarea din timer
          stare_automat=0;
          TCCR1B = (1<<CS11)|(1<<CS10)|(1<<ICES1);
        }
        
	break;
	
      }
    }
    
    beculet(iesire_automat);
  }
}