.686
.model flat

public _przestaw

.code

_przestaw PROC
		
			push	ebp
			mov		ebp, esp
			push	ebx

			mov		ebx, [ebp+8]		;adres pierwszej komorki
			mov		ecx, [ebp+12]		;rozmiar tablicy

ptl:		mov		eax, [ebx]			;wpisujemy kolejny element tablicy do eax
			cmp		eax, [ebx+4]
			jle		gotowe
			mov		edx, [ebx+4]
			mov		[ebx], edx
			mov		[ebx+4], eax

gotowe:		add		ebx, 4
			loop	ptl

			pop		ebx
			pop		ebp
			ret

_przestaw ENDP
END