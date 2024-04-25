.686
.model flat
extern _strtoll : PROC
extern _malloc : PROC
public _c_array

.code

_c_array PROC

			push	ebp
			mov		ebp, esp

			sub		esp, 4

			push	ebx
			push	esi
			push	edi

			mov		ebx, [ebp+8] ;adres pierwszej liczby
			lea		esi, [ebp-4] ;miejsce na enda

			push	2048
			call	_malloc
			add		esp, 4
			push	eax
			mov		edi, eax	;miejsce docelowe


ptl:		mov		dl, [ebx]
			cmp		dl, 32
			jne		dalej
			inc		ebx
			jmp		ptl
dalej:		
			cmp		dl, 10
			jne		konwersja
			jmp		koniec
konwersja:	
			mov		edx, 0
			mov		eax, 0
			push	10
			push	esi
			push	ebx
			call	_strtoll
			add		esp, 12
			mov		[edi], eax
			add		edi, 4
			mov		[edi], edx
			add		edi, 4
			mov		ebx, [esi]
			jmp		ptl

koniec:		pop		eax
			pop		edi
			pop		esi
			pop		ebx

			add		esp, 4
			pop		ebp
			ret

_c_array ENDP
END