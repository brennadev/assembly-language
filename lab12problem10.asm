; Programmer: Brenna Olson
; Description: Show parameters for a procedure
; Copyright © 2016 Brenna Olson. All rights reserved.
; REUSE AND REDISTRIBUTION NOTICE: You may not modify or redistribute this code in any form including, but not limited to, source or binary. You may download it for informational purposes only.

INCLUDE Irvine32.inc

ExitProcess proto, dwExitCode:dword
showParams proto, count: dword, stackParametersLabel: dword, dividerLine: dword,
				  addressLabel: dword
testProcedure1 proto, param1: dword, param2: dword, param3: dword

.data
stackParameters byte "Stack parameters:", 0
divider byte "---------------------------", 0
address byte "Address ", 0

.code
main proc
	invoke testProcedure1, 1425, 4522, 564 ; test showParams with this procedure
	invoke ExitProcess, 0
main endp

;-------------------------------------------------------------------------------
; Description:    Show addresses and values of parameters of a procedure
; Preconditions:  count contains the number of parameters in the calling
;				  procedure
; Postconditions: Parameter addresses and values shown on screen from lowest
;				  address to highest address
;-------------------------------------------------------------------------------
showParams proc,
	count: dword,			     ; number of parameters in calling procedure
	stackParametersLabel: dword, ; pointer to stack parameters label's string
	dividerLine: dword,			 ; line displayed after stack parameters label
	addressLabel: dword		     ; pointer to address label's string
	local counter: dword	     ; offset from ebp of current location

	pushad					   ; push registers
	pushfd					   ; push flags

	mov counter, 32			   ; offset from ebp of 1st parameter in calling
							   ; procedure
	mov ecx, count			   ; loop needs to iterate through each parameter,
							   ; which count indicates

	mov edx, stackParametersLabel	; set up writeString
	call writeString				; display stack parameters label
	call crlf						; new line

	mov edx, dividerLine			; set up writeString
	call writeString				; display divider line
	call crlf						; new line

	L1:
		mov edx, addressLabel  ; set up writeString
		call writeString	   ; display address label

		push ebp			   ; ebp will be modified temporarily to the current
							   ; parameter's location
		add ebp, counter	   ; move ebp to current parameter's location
		mov eax, ebp		   ; set up writeHex

		call writeHex		   ; display address

		mov al, ' '			   ; set up writeChar
		call writeChar		   ; display space before =
		mov al, '='			   ; set up writeChar
		call writeChar		   ; display =
		mov al, ' '			   ; set up writeChar
		call writeChar		   ; display space after =

		mov eax, [ebp]		   ; set up writeHex
		pop ebp				   ; restore ebp to value at beginning of loop
		call writeHex		   ; display value at current parameter's address

		call crlf			   ; put next result on new line

		add counter, 4		   ; go to next parameter
		loop L1				   ; do it again

	popfd					   ; pop flags
	popad					   ; pop registers
	ret
showParams endp

;-------------------------------------------------------------------------------
; Description:    Test procedure for showParams
; Preconditions:  param1, param2, and param3 are valid dword values
; Postconditions: showParams for this procedure called
;-------------------------------------------------------------------------------
testProcedure1 proc,
		param1: dword,
		param2: dword,
		param3: dword
	; test showParams
	invoke showParams, 3, offset stackParameters, offset divider, offset address
	ret
testProcedure1 endp

end main
