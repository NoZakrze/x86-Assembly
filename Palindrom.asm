.686
.model flat

public _palindrom
.data

.code

_palindrom PROC

			push	ebp
			mov		ebp, esp
			push	ebx
			push	esi

			mov		ebx, [ebp+8]	;adres napisu
			mov		ecx, [ebp+12]	;ilosc znakow

			cmp		ecx, 1
			ja		dalej
			mov		eax, 1
			jmp		zakoncz
dalej:		
			mov		esi, ecx
			sub		esi, 1			;esi = licznik - 1
			mov		dx, [ebx]		;napis[0]
			mov		ax, [ebx+esi*2]
			cmp		ax, dx
			je		zgodnosc
			mov		eax, 0
			jmp		zakoncz

zgodnosc:	
			dec		esi
			push	esi
			lea		ebx, [ebx+1]
			push	ebx
			call	_palindrom
			add		esp, 8
zakoncz:
			pop		esi
			pop		ebx
			pop		ebp
			ret

_palindrom ENDP
END