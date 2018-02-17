; Programmer: Brenna Olson
; Description: Find the first occurrence of a string in another string
; Copyright © 2016 Brenna Olson. All rights reserved.
; REUSE AND REDISTRIBUTION NOTICE: You may not modify or redistribute this code in any form including, but not limited to, source or binary. You may download it for informational purposes only.

INCLUDE Irvine32.inc

str_find proto, source: ptr byte, target: ptr byte
ExitProcess proto, dwExitCode:dword

.data
targetString byte "1A23ABC34ABC2432", 0		; string to search
sourceString byte "ABC", 0					; string to search for
position dword ?							; position of matched string
offsetTarget byte "Offset of target ", 0	; for output
foundString byte "String found at ", 0		; for output
notFoundString byte "String not found", 0	; for output

.code
main proc

	mov edx, offset offsetTarget	; set up writeString
	call writeString				; display heading "Offset of target"

	mov eax, offset targetString	; set up writeHex
	call writeHex					; display offset of target

	call crlf						; space between what's displayed

    invoke str_find, addr sourceString, addr targetString ; see if target
														  ; contains source
    jnz notFound					; if source wasn't found in target
    mov position, eax				; store position

	mov edx, offset foundString		; set up writeString
	call writeString				; display "string found at"

	call writeHex					; display offset of found string
	call crlf						; extra space
	jmp done						; done displaying output

	notFound:						; source not found
	mov edx, offset notFoundString	; set up writeString
	call writeString				; display "string not found"
	call crlf						; extra space

	done:
	invoke ExitProcess, 0
main endp

;-------------------------------------------------------------------------------
; Description:    Find the first occurrence of a string in another string
; Preconditions:  source contains a pointer to the string to find
;				  target contains a pointer to the string to look for source in
; Postconditions: Zero flag is set if source string is found; otherwise, it's
;					clear
;				  Carry flag may be modified
;				  If source string is found, eax points to the location in
;					target where it's contained
;-------------------------------------------------------------------------------
str_find proc,
source: ptr byte,				; pointer to string to find
target: ptr byte				; pointer to string to look for source in
local sourceLength: dword		; length of source string
local isFound: byte				; stores whether source has been found in target

	push edx					; edx is modified
    push ecx					; ecx is modified by loop
	push ebx					; ebx is modified
	push esi					; esi is modified
	push edi					; edi is modified
	pushfd						; save flags

	invoke str_length, target   ; get length of target string
    mov ecx, eax                ; set up counter with target string's length

	invoke str_length, source	; get source string's length
	mov sourceLength, eax		; store source's length
	dec sourceLength			; needs to be decremented because array indices
								; are zero-indexed

	mov esi, source				; for incrementing source's offset
	mov edi, target				; for incrementing target's offset
	mov isFound, 0				; initialize isFound

L1:
	mov bl, [esi]			; avoid memory-memory
	cmp bl, byte ptr [edi]	; source + offset == target
	jne isNotEqual			; target and source current positions are not equal
							; - go to else

	cmp esi, source			; see if source's current element is the first one
	jne increment			; go straight to incrementing

	mov eax, edi			; this is the first position of the matching string

	increment:					; go to next location in source
		push esi				; save esi's value - esi is modified in comparison

		sub esi, source			; get distance of source's current element from
								; the beginning of source
		cmp esi, sourceLength	; compare distance to source's length

		pop esi					; restore esi

		; source's current index needs to be changed since it matches, but it
		; can't be done at finishLoop because code from other places also
		; executes the code at finishLoop
		pushfd				; incrementing may change zero flag
		inc esi				; go to next element in source
		popfd				; restore flags

		jne finishLoop		; if not at end, go to loop cleanup

		mov isFound, 1		; set isFound since we're at the end of source

		jmp exitLoop		; go to end of procedure

	isNotEqual:				; target and source current positions are not equal
		mov esi, source		; non-matching element found; set source pointer
							; back to beginning of source

	finishLoop:

    cmp ecx, 0          ; see if counter has iterated through entire string
    je exitLoop			; at the end of target string - exit loop
	cmp isFound, 1		; is source string found?
	jz exitLoop			; source string was found - exit loop

	dec ecx				; go to next element in counter
	inc edi				; go to next element in target string
	jmp L1				; otherwise go back to beginning of loop

	exitLoop:
	popfd			; restore flags
	cmp isFound, 1	; set zero flag if string was found; else clear it
	pop edi			; restore edi's value at beginning of procedure
	pop esi			; restore esi's value at beginning of procedure

	pop ebx			; restore ebx's value at beginning of procedure
    pop ecx         ; restore ecx's value at beginning of procedure
	pop edx			; restore edx's value at beginning of procedure
    ret
str_find endp

end main
