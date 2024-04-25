.686
.model flat

public _swapik

.code
_swapik PROC

		push	ebp
		mov		ebp, esp
		push	ebx
		push	esi
		push	edi


		mov		ebx, [ebp+8]	;tablica
		mov		esi, [ebp+12]	;rozmiar
		mov		edi, [ebp+16]	;pos1
		mov		edx, [ebp+20]	;pos2

		cmp		edi, esi
		jae		blad
		cmp		edi, 0
		jl		blad
		cmp		edx, esi
		jae		blad
		cmp		edx, 0
		jl		blad
		mov		eax, [ebx+4*edi]	;arg1
		mov		ecx, [ebx+4*edx]	;arg2
		mov		[ebx+4*edi], ecx
		mov		[ebx+4*edx], eax
		mov		eax, 1
		jmp		koniec




blad:
		mov		eax, 0
		jmp		koniec
koniec:
		pop		edi
		pop		esi
		pop		ebx
		pop		ebp
		ret


_swapik ENDP


END