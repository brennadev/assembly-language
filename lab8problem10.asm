; Programmer: Brenna Olson
; Description: Generate n numbers in the Fibonacci sequence
; Copyright © 2016 Brenna Olson. All rights reserved.
; REUSE AND REDISTRIBUTION NOTICE: You may not modify or redistribute this code in any form including, but not limited to, source or binary. You may download it for informational purposes only.

INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
	numbers DWORD 47 DUP(?)		; store the Fibonacci numbers generated

.code
main PROC
	mov esi, offset numbers		; set up generateFibonacci
	mov ecx, lengthof numbers	; set up generateFibonacci
	call generateFibonacci		; generate the first 47 numbers of the
								; Fibonacci sequence

	mov ebx, 4				    ; set up dumpmem
	call dumpmem				; display the array of the Fibonacci sequence

	invoke ExitProcess,0
main ENDP

;------------------------------------------------------------------------------
; Description:    Generate n values in the Fibonacci series
; Preconditions:  esi contains the address of a doubleword array to store the
;				  Fibonacci values
;				  ecx contains the number of Fibonacci values to generate
; Postconditions: Array pointed to by esi contains n Fibonacci values
;------------------------------------------------------------------------------

generateFibonacci PROC
	push esi		; esi is modified in the loop
	push ecx		; ecx is modified in the loop
	pushfd			; in case flags are modified

	sub ecx, 2		; first 2 values of Fibonacci sequence are generated outside
					; the loop, so make sure loop doesn't iterate for those
					; values

	; assign first 2 values
	mov dword ptr [esi], 1		  ; put 1 into first element
	add esi, 4					  ; go to next element
	mov dword ptr [esi], 1		  ; put 1 into second element
	add esi, 4					  ; go to next element

	; assign the rest of the values
	L1:
		mov eax, [esi - 4]	      ; get previous element's value
		add eax, [esi - 8]		  ; add 2 previous values
		mov dword ptr [esi], eax  ; put the sum of the 2 previous values in the
								  ; corresponding element
		add esi, 4				  ; go to next element
		loop L1			  		  ; do it again

	popfd			; restore flags to value at beginning of procedure
	pop ecx			; restore ecx to value at beginning of procedure
	pop esi			; restore esi to value at beginning of procedure
	ret
generateFibonacci ENDP

end main
