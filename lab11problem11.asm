; Programmer: Brenna Olson
; Description: Output a decimal ASCII number with an implied decimal point
; Copyright © 2016 Brenna Olson. All rights reserved.
; REUSE AND REDISTRIBUTION NOTICE: You may not modify or redistribute this code in any form including, but not limited to, source or binary. You may download it for informational purposes only.

INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
decimal1 byte "123456", 0		; 1st number
decimal1Offset = 2				; 1st number's decimal offset

decimal2 byte "2984572342", 0	; 2nd number
decimal2Offset = 5				; 2nd number's decimal offset

decimal3 byte "89247132", 0		; 3rd number
decimal3Offset = 4				; 3rd number's decimal offset

.code
main PROC

	; 1st number
	mov edx, offset decimal1	; set up writeScaled
	mov ecx, lengthof decimal1	; set up writeScaled
	mov ebx, decimal1Offset		; set up writeScaled
	call writeScaled			; display 1st number

	call crlf					; put space between numbers

	; 2nd number
	mov edx, offset decimal2	; set up writeScaled
	mov ecx, lengthof decimal2	; set up writeScaled
	mov ebx, decimal2Offset		; set up writeScaled
	call writeScaled			; display 2nd number

	call crlf					; put space between numbers

	; 3rd number
	mov edx, offset decimal3	; set up writeScaled
	mov ecx, lengthof decimal3	; set up writeScaled
	mov ebx, decimal3Offset		; set up writeScaled
	call writeScaled			; display 3rd number

	call crlf					; put space between numbers

	invoke ExitProcess,0
main ENDP

;-------------------------------------------------------------------------------
; Description:    Output a decimal ASCII number with an implied decimal point
; Preconditions:  edx contains the number's offset
;				  ecx contain's the number's length
;				  ebx contain's the decimal point's offset
; Postconditions: Number with decimal point is displayed on screen
;-------------------------------------------------------------------------------

writeScaled PROC
	pushfd		; push flags
	pushad		; push registers

	dec ecx		; so null character isn't included in the character count

	L1:
		cmp ecx, ebx		  ; compare current index from end to decimal offset
		jne displayCharacter  ; if the current index from end is not the same as
							  ; the decimal offset, jump to display the character

		mov al, '.'			  ; set up writeChar
		call writeChar		  ; display decimal point

		displayCharacter:
		mov al, [edx]		  ; set up writeChar
		call writeChar		  ; display current index's character

		inc edx				  ; go to next character
		loop L1				  ; do it again

	popad		; pop registers
	popfd		; pop flags
	ret
writeScaled ENDP

end main
