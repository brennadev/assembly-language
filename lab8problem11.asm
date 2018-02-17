; Programmer: Brenna Olson
; Description: Find all multiples of a given number in an array's indices
; Copyright © 2016 Brenna Olson. All rights reserved.
; REUSE AND REDISTRIBUTION NOTICE: You may not modify or redistribute this code in any form including, but not limited to, source or binary. You may download it for informational purposes only.

INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
multiples2 byte 50 dup(0)								  ; for first call
multiple2 = 2											  ; k for first call
; how many values need to be iterated through in findMultiples
multiples2IterateLength = (lengthof multiples2 - 1) / multiple2 + 1

multiples3 byte 50 dup(0)								  ; for second call
multiple3 = 3											  ; k for second call
; how many values need to be iterated through in findMultiples
multiples3IterateLength = (lengthof multiples3 - 1) / multiple3 + 1

multiples2String byte "Multiples of 2:", 0			; display before displaying
													; multiples of 2
multiples3String byte "Multiples of 3:", 0			; display before displaying
													; multiples of 3

.code
main PROC

	; k = 2
	mov esi, offset multiples2		; set up setArrayToAllZeros
	mov ecx, lengthof multiples2	; set up setArrayToAllZeros
	call setArrayToAllZeros			; set the first array (k = 2) to all zeros

	mov ecx, multiples2IterateLength	; set up findMultiples
	mov eax, multiple2					; set up findMultiples
	call findMultiples					; find multiples of 2 in multiples2

	mov edx, offset multiples2String	; set up writeString
	call writeString					; display multiples of 2 heading

	mov ebx, 1						; set up dumpMem
	mov ecx, lengthof multiples2	; set up dumpMem
	call dumpMem					; display multiples2 after being modified

	call crlf						; put some space between the 2 data sets
	call crlf						; ditto

	; k = 3
	mov esi, offset multiples3		; set up setArrayToAllZeros
	mov ecx, lengthof multiples3	; set up setArrayToAllZeros
	call setArrayToAllZeros			; set the second array (k = 3) to all zeros

	mov ecx, multiples3IterateLength	; set up findMultiples
	mov eax, multiple3					; set up findMultiples
	call findMultiples					; find multiples of 3 in multiples3

	mov edx, offset multiples3String	; set up writeString
	call writeString					; display multiples of 3 heading

	mov ebx, 1						; set up dumpMem
	mov ecx, lengthof multiples3	; set up dumpMem
	call dumpMem					; display multiples3 after being modified

	invoke ExitProcess,0
main ENDP


;------------------------------------------------------------------------------
; Description:    Find all multiples of a given number in an array's indices
; Preconditions:  esi points to the array to be modified
;				  eax contains the value to find multiples of (k)
;				  ecx contains the following value:
;						((lengthof array pointed to by esi) - 1) / k + 1

; Postconditions: Array pointed to by esi will have elements whose indices are
;				  multiples of the value passed to eax modified to the value of 1
;------------------------------------------------------------------------------
findMultiples PROC
	push ecx		; loop needs ecx
	pushfd			; push flags
	push esi		; value pointed to by esi is modified in procedure

	L1:
		mov byte ptr [esi], 1	; put 1 in the element that's a multiple
		add esi, eax			; go to the element that adds k to the current element
		loop L1					; do it again


	pop esi			; restore esi's value at beginning of procedure
	popfd			; restore flags
	pop ecx			; restore ecx's value at beginning of procedure
	ret
findMultiples ENDP

;------------------------------------------------------------------------------
; Description:    Set all values of a byte array to 0
; Preconditions:  esi points to the array to be modified
;				  ecx contains the length of the array
; Postconditions: All values of the array are set to 0
;------------------------------------------------------------------------------
setArrayToAllZeros PROC
	push ecx		; loop needs ecx
	pushfd			; push flags
	push esi		; value pointed to by esi is modified in procedure

	L2:
		mov byte ptr [esi], 0		; put 0 in the current index
		inc esi						; move to next index
		loop L2						; do it again

	pop esi			; restore esi's value at beginning of procedure
	popfd			; restore flags
	pop ecx			; restore ecx's value at begnning of procedure
	ret
setArrayToAllZeros ENDP

end main
