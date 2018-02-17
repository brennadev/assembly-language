; Programmer: Brenna Olson
; Description: Remove all instances of a given character from a string
; Copyright © 2016 Brenna Olson. All rights reserved.
; REUSE AND REDISTRIBUTION NOTICE: You may not modify or redistribute this code in any form including, but not limited to, source or binary. You may download it for informational purposes only.

INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
string byte 51 dup(?)		; string entered by user
character byte ?			; character to remove entered by user
numberOfCharacters dword ?	; number of characters entered not including null
							; character

stringPrompt byte "Enter a string: ", 0				  ; prompt for user to enter
													  ; string
characterPrompt byte "Enter character to remove: ", 0 ; prompt for user to enter
													  ; character to remove

.code
main PROC
	; get string from user
	mov edx, offset stringPrompt	; set up writeString
	call writeString				; display prompt for user to enter string
	mov edx, offset string			; set up readString
	mov ecx, lengthof string		; set up readString
	call readString					; get string from user
	mov numberOfCharacters, eax		; store the number of characters entered

	call crlf						; put space between the prompts

	; get character to remove from user
	mov edx, offset characterPrompt	; set up writeString
	call writeString				; display prompt for user to enter character
									; to remove
	call readChar					; get character to remove from user
	mov character, al				; store character in memory
	call writeChar					; display character entered to user


	; remove instances of the character
	mov esi, offset string			; set up removeCharacterFromString
	mov edi, offset character		; set up removeCharacterFromString
	mov ecx, numberOfCharacters		; set up removeCharacterFromString
	call crlf						; put space between the prompts and output

	call removeCharacterFromString	; remove all instances of entered character
									; from entered string

	; display edited string
	mov edx, offset string			; set up writeString
	call writeString				; display string with character removed
	invoke ExitProcess,0
main ENDP

;-------------------------------------------------------------------------------
; Description:    Remove all instances of a given character from a string
; Preconditions:  esi contains the offset of the string to be modified
;				  edi contains the offset of the character to remove from string
;				  ecx contains the number of characters in the string not
;					including the null character
; Postconditions: String has been edited to remove all instances of the
;					passed-in character
;-------------------------------------------------------------------------------

removeCharacterFromString PROC
	pushfd		  ; push flags
	push esi	  ; esi is modified by loop
	push ecx	  ; ecx is modified by loop
	push eax	  ; ah and al store characters
	push edx	  ; dh is modified by inner loop

	mov ah, [edi] ; put the character to be removed in ah to avoid memory-memory

	; loop through each character in string
	L1:
		cmp [esi], ah	; compare string's current index contents to the
						; character to remove
		jne L2			; if the string's current index contents is not the
						; character to remove, do nothing
		push ecx		; ecx will be modified by inner loop
		push esi		; esi will be modified by inner loop

		; when the current index's character does match the character to remove
		L3:

			mov dh, [esi + 1]		; contains character to move
			mov byte ptr [esi], dh	; put charcter to move in 1 location before

			inc esi					; move to next character
			loop L3					; do it again

		pop esi			; restore esi's value at beginning of inner loop
		pop ecx			; restore ecx's value at beginning of inner loop

		cmp ah, [esi]	; compare characters again in case there's double
						; (or more) letters
		je L1			; go back to beginning of loop if characters are still
						; equal

		; ready to go to next character index
		L2:
		inc esi	  ; move to next character in string
		loop L1	  ; do it again

	pop edx		  ; restore edx's value at beginning of procedure
	pop eax		  ; restore eax's value at beginning of procedure
	pop ecx		  ; restore ecx's value at beginning of procedure
	pop esi		  ; restore esi's value at beginning of procedure
	popfd		  ; restore flags
	ret
removeCharacterFromString ENDP

end main
