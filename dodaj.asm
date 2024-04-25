public suma

.code


suma PROC

		push	rbp
		mov		rbp, rsp

		push	rbx
		push	rsi

		mov		rax, 0	;suma

		cmp		rcx, 0
		je		koniec
		add		rax, rdx
		dec		rcx
		cmp		rcx, 0
		je		koniec
		add		rax, r8
		dec		rcx
		cmp		rcx, 0
		je		koniec
		add		rax, r9
		dec		rcx
		cmp		rcx, 0
		je		koniec

		mov		rsi, 48
stosik:	
		mov		rbx, [rbp+rsi]
		add		rax, rbx
		dec		rcx
		cmp		rcx, 0
		je		koniec
		add		rsi, 8
		jmp		stosik

koniec:
		pop		rsi
		pop		rbx
		pop		rbp
		ret

suma ENDP
END