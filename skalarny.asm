.686
.model flat

public _iloczyn

.code

_iloczyn PROC

		push	ebp
		mov		ebp, esp

		push	ebx
		push	esi
		push	edi

		mov		esi, [ebp+8]	;tab1
		mov		edi, [ebp+12]	;tab2
		mov		ecx, [ebp+16]	;n

		mov		eax, 0			;wynik
ptl:	push	eax
		mov		edx, 0
		mov		eax, [esi]
		imul	dword PTR [edi]
		pop		ebx
		add		eax, ebx
		add		esi, 4
		add		edi, 4
		dec		ecx
		jnz		ptl

		pop		edi
		pop		esi
		pop		ebx
		pop		ebp
		ret

_iloczyn ENDP
END