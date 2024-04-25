.686
.model flat
extern __write : PROC
extern __read	: PROC
extern _ExitProcess@4 : PROC
public _main

.data
magazyn		db 150 dup (?)
wyjscie		db 150 dup (?)
.code
	
_main PROC
		
			push	150
			push	OFFSET magazyn
			push	0
			call	__read
			add		esp, 12

			mov		ecx, eax
			mov		esi, 0
			mov		edi, 0
			mov		eax, 1					;flaga czy zapisywac
ptl:		mov		dl, magazyn[esi]
			cmp		dl, ' '
			jne		dalej
			xor		eax, 1
dalej:		cmp		eax, 1
			jne		nie_pisz
			mov		wyjscie[edi], dl
			inc		edi
nie_pisz:	inc		esi
			dec		ecx
			jnz		ptl

			mov		ecx, edi
			push	ecx
			push	OFFSET wyjscie
			push	1
			call	__write
			add		esp, 12
			

		push	0
		call	_ExitProcess@4

_main ENDP
END