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
	AND R0, R0, #0	;sets R0 to 0
	STI R0, global	;stores 0 at global
loop	LDI R0, global	;checks for A
	BRz loop	;if global has 0, then loop to check again
	TRAP x21	;if loop falls through, print keystroke
	AND R1, R1, #0	;set R1 to 0
	STI R1, global	;store R1 at global
	LD R1, Achar	;load -A into R1
	ADD R0, R0, R1	;add R1 and r0
	BRnp loop	;checks if same, if not same loop back
loop1	LDI R0, global	;checks for U
	BRz loop1	;if no new character, then loop back to loop1
	TRAP x21	;if loop falls through, print
	AND R1, R1, #0	;sets r1 to 0
	STI R1, global	;stores 0 at global
	LD R1, Uchar	;loads -U into R1
	ADD R0, R0, R1	;compares R0 and R1
	BRz loop2	;if equal, then go to loop2
	ADD R0, R0, #10	;adds 10 back to R0
	ADD R0, R0, #10	;adds 10 back to R0
	BRz loop1	;if match, then go back to loop 1
	BRnp loop	;if no match, then start over
loop2	LDI R0, global	;checks for G
	BRz loop2	;if no new character, loop
	TRAP x21	;if loop falls through, then print
	AND R1, R1, #0	;sets r1 to 0
	STI R1, global	;stores 0 at global
	LD R1, Gchar	;loads -G into r1
	ADD R0, R0, R1	;checks for G
	BRz start	;if match, then start codon has been detected
	ADD R0, R0, #6	;add 6 back to R0
	BRz loop1	;if new match then branch back to loop1
	BRnp loop	;if no match, then start over
start	LD R0, pipe	;Prints pipe (STARTING SEQUENCE)
	TRAP x21
loop3	LDI R0, global	;checks for U
	BRz loop3	;if no new chracter, loop
	TRAP x21	;if loop falls through, then print
	AND R1, R1, #0	;clears R1
	STI R1, global	;stores 0 at global
	LD R1, Uchar	;Loads -U into R1
	ADD R0, R0, R1	;Checks for U
	BRnp loop3	;if no match then go back to loop3
loop4	LDI R0, global	;checks for A
	BRz loop4	;if no new character, loop
	TRAP x21	;If loops falls through, then print	
	AND R1, R1, #0	;clears R1
	STI R1, global	;stores 0 at global
	LD R1, Achar	;Loads -A into R1
	ADD R0, R0, R1	;Checks for A
	BRz Afound	;If A, go to Afound
	ADD R0, R0, #-6	;checks for G
	BRz Gfound	;If G, go to Gfound
	BRnp loop3	;If neither, go back to loop3
Afound	LDI R0, global	;checks for A
	BRz Afound
	TRAP x21
	AND R1, R1, #0
	STI R1, global
	LD R1, Achar
	ADD R0, R0, R1
	BRz done	;If this next character is A, we are done
	ADD R0, R0, #-6	;checks for G
	BRz done	;If G, we are done
	ADD R0, R0, #-14
	BRz loop4	;if U, go to loop4
	BRnp loop3	;if C, go back to loop3
Gfound	LDI R0, global	;checks for A
	BRz Gfound
	TRAP x21
	AND R1, R1, #0
	STI R1, global
	LD R1, Achar
	ADD R0, R0, R1
	BRz done	;If the new character is A, we are done
	ADD R0, R0, #-10
	ADD R0, R0, #-10
	BRz loop4	;if U, go to loop4
	BRnp loop3	;if not U, go to loop3
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

