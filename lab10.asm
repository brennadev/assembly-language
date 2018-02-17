; Programmer: Brenna Olson
; Description: Implement selection sort
; Copyright © 2016 Brenna Olson. All rights reserved.
; REUSE AND REDISTRIBUTION NOTICE: You may not modify or redistribute this code in any form including, but not limited to, source or binary. You may download it for informational purposes only.

INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
array dword 50 dup(?)			; numbers to be sorted
numberOfItems dword ?			; how many numbers to sort

.code
main PROC
	call randomize				; seed random number generator

	call generateNumberOfItems	; get number of items for array
	mov numberOfItems, eax		; store number of items to generate

	mov esi, offset array		; set up generateNumbers
	mov ecx, numberOfItems		; set up generateNumbers
	call generateNumbers		; generate random numbers to fill the array

	mov ebx, 4					; set up displayArray
	call displayArray			; display array before it's sorted


	mov ecx, numberOfItems		; set up selectionSort
	mov esi, offset array		; set up selectionSort
	call selectionSort			; sort the array

	call crlf					; put space between the times array is displayed
	call crlf					; ditto

	call displayArray			; display array after it's sorted

	invoke ExitProcess,0
main ENDP

;-------------------------------------------------------------------------------
; Description:    Generate the number of items to have in the array to be sorted
; Preconditions:  None
; Postconditions: eax is modified to contain the number of items in the array
;-------------------------------------------------------------------------------

generateNumberOfItems PROC
	pushfd				; push flags
	mov eax, 41			; set up randomRange
	call randomRange	; get number of items to have in array
	add eax, 10			; add 10 to number of items to get to specified range

	popfd				; pop flags
	ret
generateNumberOfItems ENDP


;-------------------------------------------------------------------------------
; Description:    Generate random numbers to fill a dword array
; Preconditions:  esi contains the offset of the array
;				  ecx contains the number of items in the array
; Postconditions: Array pointed to by esi contains randomly generated values
;					from 1-1000
;-------------------------------------------------------------------------------

generateNumbers PROC
	push ecx					; ecx is modified by loop
	push eax					; eax is modified by loop
	push esi					; esi is modified by loop

L1:
	mov eax, 1000				; range of values generated
	call randomRange			; get value for current location

	inc eax						; add 1 to get value in specified range

	mov dword ptr [esi], eax	; put value in current location

	add esi, 4					; move to next item
	loop L1						; do it again

	pop esi		; restore esi's value at beginning of procedure
	pop eax		; restore eax's value at beginning of procedure
	pop ecx		; restore ecx's value at beginning of procedure
	ret
generateNumbers ENDP


;-------------------------------------------------------------------------------
; Description:    Perform selection sort on a dword array
; Preconditions:  esi points to the array
;				  ecx contains the number of items in the array
; Postconditions: Array is sorted in ascending order
;-------------------------------------------------------------------------------

selectionSort PROC
	pushfd			; push flags
	push ecx		; ecx is modified by loops
	push esi		; esi is modified by loops
	push edi		; edi is modified by loops
	push ebx		; ebx is modified by loops
	push eax		; eax is modified by loops

	inc ecx			; prevents ecx from being at 0 at loop instruction

	L3:
		cmp ecx, 1			; compare loop counter to 1
		jbe exitProcedure	; if at 1, then last element has been reached, which
							; doesn't need to be compared with anything else

		mov edi, esi		; store location of minimum value in edi
		push ecx			; ecx is modified in inner loop
		dec ecx				; ecx needs to skip 1 value to check the proper
							; locations
		push esi			; esi moves to subsequent array positions in the
							; loop


		L4:
			mov eax, [edi]	; store minimum value to avoid memory-memory
			cmp [esi], eax	; compare current array location to min
			jae notMin		; if current array location isn't < min, skip next
							; part of loop

			mov edi, esi	; if current array location is the min, change edi
							; to that

			notMin:
			add esi, 4		; go to next element in array
			loop L4			; do it again

		pop esi				; restore esi's value at beginning of inner loop
		pop ecx				; restore ecx's value at beginning of inner loop

		mov ebx, [esi]				; store current location's value somewhere
		mov eax, [edi]				; store minimum value somewhere
		mov dword ptr [esi], eax	; put minimum value in current location
		mov dword ptr [edi], ebx	; put current location's value in minimum
									; value's location


		add esi, 4					; go to next element in array
		loop L3						; do it again

	exitProcedure:
	pop eax			; restore eax's value at beginning of procedure
	pop ebx			; restore ebx's value at beginning of procedure
	pop edi			; restore edi's value at beginning of procedure
	pop esi			; restore esi's value at beginning of procedure
	pop ecx			; restore ecx's value at beginning of procedure
	popfd			; restore flags
	ret
selectionSort ENDP


;-------------------------------------------------------------------------------
; Description:    Display contents of an array in decimal
; Preconditions:  esi contains the offset of the array
;				  ecx contains the number of items in the array
;				  ebx contains the size of the elements (1 - byte, 2 - word,
;					4 - dword)
; Postconditions: Contents of array displayed on screen
;-------------------------------------------------------------------------------

displayArray PROC
	pushfd				; push flags
	push ecx			; ecx is modified by loop
	push esi			; esi is modified by loop
	push eax			; eax is modified by loop
	push ebx			; ebx is modified by loop
	push edx			; edx is modified by loop

	mov edx, 1			; ebx will be in the range of 1-10

	L2:
		mov eax, [esi]	; set up writeDec
		call writeDec	; display value at current index

		mov al, 32		; set up writeChar
		call writeChar	; put a space between each number
		call writeChar	; put another space

		add esi, ebx	; go to next element

		cmp edx, 10		; compare to 10, the value when output should start
						; going to a new line, which means 10 items per line
		je setTo1		; when loop has reached max value for current line
		inc edx			; loop has not reached max value - just go to next value
		jmp endLoop		; comparison is done

		setTo1:
			mov edx, 1	; reset edx
			call crlf	; go to new line
		endLoop:

		loop L2			; do it again

	pop edx				; restore edx's value at beginning of procedure
	pop ebx				; restore ebx's value at beginning of procedure
	pop eax				; restore eax's value at beginning of procedure
	pop esi				; restore esi's value at beginning of procedure
	pop ecx				; restore ecx's value at beginning of procedure
	popfd				; restore flags
	ret
displayArray ENDP

end main
