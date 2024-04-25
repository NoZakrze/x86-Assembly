.686
.model flat

public _szukaj_max

.code

_szukaj_max PROC

			push	ebp
			mov		ebp, esp

			mov		eax, [esp+8]
			cmp		eax, [esp+12]
			jge		x_wieksza
			mov		eax, [esp+12]
			cmp		eax, [esp+16]
			jge		y_wieksza

wpisz_z:	mov		eax, [esp+16]

zakoncz:	pop		ebp
			ret

x_wieksza:	cmp		eax, [esp+16]
			jge		zakoncz
			jmp		wpisz_z

y_wieksza:	jmp		zakoncz

_szukaj_max ENDP
END