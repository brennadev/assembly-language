; Programmer: Brenna Olson
; Description: Find the greatest common divisor between 2 integers
; Copyright © 2016 Brenna Olson. All rights reserved.
; REUSE AND REDISTRIBUTION NOTICE: You may not modify or redistribute this code in any form including, but not limited to, source or binary. You may download it for informational purposes only.

INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.code
main PROC

	mov eax, 17		; set up gcd
	mov ebx, 30		; set up gcd
	call gcd		; gcd of 17 and 30
	call writeDec	; display gcd of 17 and 30
	call crlf		; space between results

	mov eax, 20		; set up gcd
	mov ebx, 15		; set up gcd
	call gcd		; gcd of 20 and 15
	call writeDec	; display gcd of 20 and 15
	call crlf		; space between results

	mov eax, 3		; set up gcd
	mov ebx, 60		; set up gcd
	call gcd		; gcd of 3 and 60
	call writeDec	; display gcd of 3 and 60
	call crlf		; space between results

	invoke ExitProcess,0
main ENDP

;-------------------------------------------------------------------------------
; Description:    Find the greatest common divisor between 2 integers
; Preconditions:  eax contains the first number
;				  ebx contains the second number
; Postconditions: eax contains gcd
;-------------------------------------------------------------------------------

gcd PROC
	push ebx	; ebx is modified by loop
	push ecx	; ecx is modified by loop
	push edx	; edx is modified by loop
	pushfd		; push flags

	call abs		; get absolute value of x (eax)
	push eax		; eax is needed for absolute value of ebx
	mov eax, ebx	; set up abs
	call abs		; get absolute value of ebx
	mov ebx, eax	; put absolute value in ebx
	pop eax			; restore eax

	L1:
	mov edx, 0	; clear upper half of dividend
	div ebx	; x / y
	mov ecx, edx	; store remainder in n

	mov eax, ebx	; x = y
	mov ebx, ecx	; y = n

	cmp ebx, 0
	ja L1

	popfd	; pop flags
	pop edx	; restore edx to value at beginning of procedure
	pop ecx	; restore ecx to value at beginning of procedure
	pop ebx	; restore ebx to value at beginning of procedure
	ret
gcd ENDP

;-------------------------------------------------------------------------------
; Description:    Get absolute value of a 32-bit integer
; Preconditions:  eax contains the number to get absolute value of
; Postconditions: eax contains the absolute value of the number passed in
;-------------------------------------------------------------------------------

abs PROC
	push ebx			; ebx is modified in procedure
	pushfd				; push flags

	cmp eax, 0			; see if number is < 0
	jge alreadyPositive	; do nothing if the number is positive or 0

	mov ebx, 0FFFFFFFFh	; number to subtract from for 2s complement
	sub ebx, eax		; FFFF - eax
	mov eax, ebx		; store complement in eax
	inc eax				; add 1

	alreadyPositive:
	popfd				; pop flags
	pop ebx				; restore ebx's value at beginning of procedure
	ret
abs ENDP

end main
