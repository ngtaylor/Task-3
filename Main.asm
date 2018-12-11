; Main.asm
; Name: Nicholas Taylor, Nicholas Hoffman
; UTEid: ngt333, nah2457
; Continuously reads from x4600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
               .ORIG x4000
; initialize the stack pointer
	LD R6, SB
	

; set up the keyboard interrupt vector table entry
	LD R1, IVT
	LD R2, ISR		
	STR R2, R1, #0
		

; enable keyboard interrupts
	LD R3, SB
	STI R3, KBSR	


; start of actual program
	AND R0, R0, #0
	STI R0, global
loop	LDI R0, global	;checks for A
	BRz loop
	TRAP x21
	AND R1, R1, #0
	STI R1, global
	LD R1, Achar
	ADD R0, R0, R1
	BRnp loop
loop1	LDI R0, global	;checks for U
	BRz loop1	
	TRAP x21
	AND R1, R1, #0
	STI R1, global
	LD R1, Uchar
	ADD R0, R0, R1
	BRz loop2
	ADD R0, R0, #10
	ADD R0, R0, #10
	BRz loop1
	BRnp loop
loop2	LDI R0, global	;checks for G
	BRz loop2
	TRAP x21
	AND R1, R1, #0
	STI R1, global
	LD R1, Gchar
	ADD R0, R0, R1
	BRz start
	ADD R0, R0, #6
	BRz loop1
	BRnp loop
start	LD R0, pipe	;Prints pipe (STARTING SEQUENCE)
	TRAP x21
loop3	LDI R0, global	;checks for U
	BRz loop3	
	TRAP x21
	AND R1, R1, #0
	STI R1, global
	LD R1, Uchar
	ADD R0, R0, R1
	BRnp loop3	
loop4	LDI R0, global	;checks for A
	BRz loop4
	TRAP x21
	AND R1, R1, #0
	STI R1, global
	LD R1, Achar
	ADD R0, R0, R1
	BRz Afound
	ADD R0, R0, #-6	;checks for G
	BRz Gfound
	BRnp loop3
Afound	LDI R0, global	;checks for A
	BRz Afound
	TRAP x21
	AND R1, R1, #0
	STI R1, global
	LD R1, Achar
	ADD R0, R0, R1
	BRz done
	ADD R0, R0, #-6	;checks for G
	BRz done
	ADD R0, R0, #-14
	BRz loop4
	BRnp loop3
Gfound	LDI R0, global	;checks for A
	BRz Gfound
	TRAP x21
	AND R1, R1, #0
	STI R1, global
	LD R1, Achar
	ADD R0, R0, R1
	BRz done
	ADD R0, R0, #-10
	ADD R0, R0, #-10
	BRz loop4
	BRnp loop3
done	TRAP x25


SB	.FILL x4000
IVT	.FILL x0180
ISR	.FILL x2600
KBSR 	.FILL xFE00
global	.FILL x4600
Achar	.FILL xFFBF
Uchar	.FILL xFFAB
Gchar	.FILL xFFB9
pipe	.FILL x007C
		.END
