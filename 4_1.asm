.686
.model flat

public _szukaj_maxa_4

.code

_szukaj_maxa_4 PROC
		
				push	ebp
				mov		ebp, esp

				mov		eax, [ebp+8]	;liczba a
				cmp		eax, [ebp+12]
				jge		a_wieksza
				mov		eax, [ebp+12]	;liczba b
				cmp		eax, [ebp+16]
				jge		b_wieksza
por_cd:			mov		eax, [ebp+16]	;liczba c
				cmp		eax, [ebp+20]
				jge		zakoncz			;c najwieksza

wpisz_d:		mov		eax, [ebp+20]	;liczba d najwieksza

zakoncz:		pop		ebp
				ret

a_wieksza:		cmp		eax, [ebp+16]	
				jl		por_cd			
				cmp		eax, [ebp+20]
				jl		wpisz_d
				jmp		zakoncz			;a najwieksza

b_wieksza:		cmp		eax, [ebp+20]
				jl		wpisz_d
				jmp		zakoncz			;b najwieksza


_szukaj_maxa_4 ENDP
END