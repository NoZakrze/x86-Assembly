public szukaj64_max

.code

szukaj64_max PROC
	
		push	rbx
		push	rsi

		mov		rbx, rcx			;adres tablicy
		mov		rcx, rdx			;ilosc elementow
		mov		rsi, 0				;bierzacy indeks

		mov		rax, [rbx+rsi*8]	;pierwszy element tablicy
		dec		rcx

petla:	inc		rsi
		cmp		rax, [rbx+rsi*8]
		jge		dalej
		mov		rax, [rbx+rsi*8]
dalej:	loop	petla
		
		pop		rsi
		pop		rbx
		ret

szukaj64_max ENDP
END