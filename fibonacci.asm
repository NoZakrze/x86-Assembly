.686
.model flat

public _fibonacci

.code


_fibonacci PROC

		push	ebp
		mov		ebp, esp

		push	ebx
		push	esi
		push	edi

		mov		edx, [ebp+8]
		cmp		edx, 0
		je		r_zero
		cmp		edx, 2
		jbe		r_jeden
		cmp		edx, 47
		ja		r_minusjeden
		lea		esi, [edx-2]
		lea		edi, [edx-1]
		push	esi
		call	_fibonacci
		add		esp, 4
		xor		edx, edx
		mov		edx, eax		;wynik posredni
		push	edx
		push	edi
		call	_fibonacci
		add		esp, 4
		pop		edx
		add		eax, edx		;wynik koncowy 
		jmp		koniec

r_jeden:
		mov		eax, 1
		jmp		koniec
r_minusjeden:
		mov		eax, -1
		jmp		koniec
r_zero:
		mov		eax, 0
		jmp		koniec

koniec:  
		pop		edi
		pop		esi
		pop		ebx
		pop		ebp
		ret

_fibonacci ENDP
END