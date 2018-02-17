; Programmer: Brenna Olson
; Description: Concatenate a string to another string
; Copyright © 2016 Brenna Olson. All rights reserved.
; REUSE AND REDISTRIBUTION NOTICE: You may not modify or redistribute this code in any form including, but not limited to, source or binary. You may download it for informational purposes only.

INCLUDE Irvine32.inc

str_concat proto, target: dword, source: dword
ExitProcess proto, dwExitCode:dword

.data
targetStr byte "ABCDE", 10 dup(0)	; concatenate source to this string
sourceStr byte "FGH", 0				; concatenated to target

.code
main PROC
	mov edx, offset targetStr		; set up writeString
	call writeString				; display target before concatenating
	call crlf						; space between strings
	mov edx, offset sourceStr		; set up writeString
	call writeString				; display source before concatenating
	call crlf						; space between strings
	call crlf						; space between strings

	invoke str_concat, addr targetStr, addr sourceStr ; concatenate string

	mov edx, offset targetStr		; set up writeString
	call writeString				; display string after concatenating
	call crlf						; space after string

	invoke ExitProcess, 0
main ENDP

;-------------------------------------------------------------------------------
; Description:    Concatenate a string to another string
; Preconditions:  target points to target string; source points to source string
;				  target has enough space to store its current value and source
; Postconditions: target has source concatenated
;-------------------------------------------------------------------------------
str_concat proc,
target: dword,	; pointer to target string
source: dword	; pointer to source string

	pushad		; push registers
	pushfd		; push flags

	invoke str_length, target			; get length of target's string
	add target, eax						; move to the first empty element
	invoke str_copy, source, target		; copy source string to target

	popfd		; pop flags
	popad		; pop registers
	ret
str_concat endp

end main
