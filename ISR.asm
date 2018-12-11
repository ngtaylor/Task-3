; ISR.asm
; Name: Nicholas Hoffman, Nicholas Taylor
; UTEid: nah2457, ngt333
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x4600
               .ORIG x2600
loop	LDI R0, KBSR	;polls KBSR
	BRp loop	;
	LDI R1, KBDR	;puts keystroke in KBDR
	ST R1, sr1	;stores r1 for later use
	LD R2, Achar	;loads r1 with negative of ascii A
	ADD R1, R1, R2	;compares
	BRz valid	;if A, then go to valid
	ADD R1, R1, #-2	;checks for C
	BRz valid	;if C, then go to valid
	ADD R1, R1, #-4	;checks for G
	BRz valid	;if G, then go to valid
	ADD R1, R1, #-14;checks for U
	BRz valid	;if l, then go to valid
	BRnzp invalid	;if invalid then follow protocol for invalid input
invalid
	AND R1, R1, #0	;sets R1 to 0
	STI R1, global	;stores 0 at global
	BRnzp done	;returns
valid
	LD R1, sr1	;puts original R1 back in R1
	STI R1, global	;stores keystroke at global
done	RTI		;returns
		
KBSR 	.FILL xFE00
KBDR 	.FILL xFE02
Achar	.FILL xFFBF
sr1	.BLKW 1
global	.FILL x4600
.END