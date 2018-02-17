; Programmer: Brenna Olson
; Description: Encrypt a message by rotating each byte a varying number of
;			   positions
; Copyright © 2016 Brenna Olson. All rights reserved.
; REUSE AND REDISTRIBUTION NOTICE: You may not modify or redistribute this code in any form including, but not limited to, source or binary. You may download it for informational purposes only.

INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
message1 byte "hello world", " fun stuff", 0	; first test
message2 byte "abcdefghijkl", 0					; second test
key byte -2, 4, 1, 0, -3, 5, 2, -4, -4, 6		; encryption key

.code
main PROC
	; first message
	mov edx, offset message1	; set up writeString
	call writeString			; display string before encrypting

	mov esi, offset message1	; set up encryptMessage
	mov edi, offset key			; set up encryptMessage
	mov ecx, lengthof message1	; set up encryptMessage

	call encryptMessage			; encrypt first message

	call crlf					; space between non-encrypted and encrypted
	call writeString			; display string after encrypting

	call crlf
	call crlf

	; second message
	mov edx, offset message2	; set up writeString
	call writeString			; display string before encrypting

	mov esi, offset message2	; set up encryptMessage
	mov ecx, lengthof message2	; set up encryptMessage

	call encryptMessage			; encrypt second message
	call crlf					; space between non-encrypted and encrypted
	call writeString			; display string after encrypting

	call crlf					; end of line

	invoke ExitProcess,0
main ENDP

;-------------------------------------------------------------------------------
; Description:    Encrypt a message using rotation
; Preconditions:  esi points to beginning of message's array
;				  edi points to beginning of key's array
;				  ecx contains the length of the message including null
;					character
; Postconditions: Array with message is now encrypted
;-------------------------------------------------------------------------------

encryptMessage PROC
	pushad			; push registers
	pushfd			; push flags

	mov eax, 0		; incremented counter
	mov ebx, 10		; number of elements in key - divisor
	dec ecx			; don't include null character

	L1:
		push eax				; eax is modified by division below
		mov edx, 0				; upper half of dividend
		div ebx					; counter / 10

		push edi				; edi will be changed to the offset of the
								; current key
		add edi, edx			; add current key's offset to edi

		cmp dword ptr [edi], 0	; see if key's current value is < 0

		push ecx				; cl is needed for ror and rol
		jl negative				; jump if key's current value < 0

		; current element of key is positive
		mov cl, byte ptr [edi]	; set up ror
		ror byte ptr [esi], cl	; rotate right by number of times in this
								; element of the key

		jmp quit				; done with rotations

		; current element of key is negative
		negative:
		mov eax, [edi]			; set up twosComplement
		call twosComplement		; need twos complement of key when rotating left
		mov cl, al				; set up rol
		rol byte ptr [esi], cl	; rotate left by number of times in this element

		quit:
		pop ecx			; restore cl to value before calling ror or rol
		pop edi			; restore edi to value at beginning of loop (first
						; element of key)
		pop eax			; restore eax's value before division
		inc eax			; go to next element
		inc esi			; go to next element

		loop L1			; do it again

	popfd				; restore flags
	popad				; restore registers
	ret
encryptMessage ENDP

;-------------------------------------------------------------------------------
; Description:    Get 2s complement of a 32-bit integer
; Preconditions:  eax contains the integer
; Postconditions: eax contains 2s complement of integer passed in
;-------------------------------------------------------------------------------

twosComplement PROC
	push ebx			; ebx is modified in procedure
	pushfd				; push flags

	mov ebx, 0FFFFFFFFh	; number to subtract from for 2s complement
	sub ebx, eax		; FFFF - eax
	mov eax, ebx		; store complement in eax
	inc eax				; add 1

	popfd				; pop flags
	pop ebx				; restore ebx's value at beginning of procedure
	ret
twosComplement ENDP

end main
