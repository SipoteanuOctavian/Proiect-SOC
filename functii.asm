NAME ext_intrerupere
    #include <ioavr.h>
    extern c_intrerupere
    COMMON INTVEC(1)
    ORG TIMER1_CAPT_vect
    RJMP c_intrerupere
ENDMOD

NAME c_intrerupere
    #include <ioavr.h>
    PUBLIC c_intrerupere
    EXTERN iesire_automat,intrare_automat,stare_automat
    RSEG CODE
    c_intrerupere:
        st -Y,R16 ; Push regiºtri pe stivã
        in R16,SREG ; Citeºte status register
        st -Y,R16 ; Citeºte status register
        
        in r16,PIND
        cbr r16,191
		cpi r16, 0
        breq final
		subi r16, 63
	final:
        sts intrare_automat,r16
       
        ld R16,Y+ ; Pop status register
        out SREG,R16 ; Salveazã status register
        ld R16,Y+ ; Pop Register R16
        
        reti
ENDMOD
          
NAME beculet
	#include <ioavr.h>
	PUBLIC beculet
RSEG CODE
	beculet: //in r16, r17 e variabila data ca parametru
		cpi r17, 0
		brne stinge_bec
	aprinde_bec:
		com r16
		out OCR2, r16
		jmp final
	stinge_bec:
		ldi r16, 0
		out OCR2, r16
	final:
		ret
ENDMOD

NAME initializare 
	#include <ioavr.h>
	PUBLIC initializare
  
RSEG CODE
  
  initializare:
  ldi r16,(1<<WGM01)|(1<<WGM00)|(1<<CS02)|(1<<CS00)|(1<<COM01)//IL PUNE PE MODUL FAST PWM 
  ldi r17,1 //DUTY CYCLE
  
  out TCCR0,r16
  out OCR0, r17
  
  
  ldi r16,(1<<CS11)|(1<<CS10)|(1<<ICES1)//ASTEAPTA SA PRIMEASCA 1
  ldi r17,(1<<TICIE1) // PORNESTE INTRURUPEREA LA SCHIMBAREA DE SEMNAL
  ldi r18,(1<<ICF1) 
  
  out TCCR1B,r16
  out TIMSK,r17
  out TIFR,r18
  
  
  ldi r16, (1<<WGM21)|(1<<WGM20)|(1<<COM21)|(1<<CS22)
  ldi r17, 255
  out TCCR2, r16
  out OCR2, r17
 
  ret
END


