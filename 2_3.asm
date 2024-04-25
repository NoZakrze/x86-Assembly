.686
.model flat
extern _MessageBoxW@16 : PROC
extern _ExitProcess@4  : PROC
public _main

.data
tekst	dw	'T','o',' ','j','e','s','t',' ','p','a','n',' '
		dw	0D83DH, 0DEB9H,' ','a',' ','t','o',' ','j','e','s','t',' '
		dw	'p','a','n','i',' ',0D8E3h, 0DD86h,0
tytul	dw	'Z','a','d','a','n','i','e',' ','2','_','3',0

.code
_main PROC
		
		push	0
		push	OFFSET tytul
		push	OFFSET tekst
		push	0
		call	_MessageBoxW@16

		push	0
		call	_ExitProcess@4

_main ENDP
END