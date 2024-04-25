.686
.model flat

public _dzielenie

.code

_dzielenie PROC

		push	ebp
		mov		ebp, esp
		
		push	ebx

		mov		eax, [ebp+8]
		mov		eax, [eax]		;dzielna

		mov		ebx, [ebp+12]
		mov		ebx, [ebx]
		mov		ebx, [ebx]		;dzielnik

		mov		edx, 0
		idiv	ebx

		pop		ebx
		pop		ebp
		ret

_dzielenie ENDP
END