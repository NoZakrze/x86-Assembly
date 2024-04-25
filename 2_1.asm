.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main

.data
tekst	db 'Nazywam si', 0A9H, ' Norbert Zakrzewski', 10
		db 'm', 0A2H, 'j pierwszy program 32-bitowy', 10
		db 'dzia', 88H, 'a ju', 0BEH, ' poprawnie!',0
koniec	db ?

.code
	
_main PROC
		
		mov		ecx, OFFSET koniec - OFFSET tekst
		push	ecx
		push	OFFSET tekst
		push	1
		call	__write
		add		esp, 12
		push	0
		call	_ExitProcess@4

_main ENDP
END