.686
.model flat

public _odejmij_jeden

.code

_odejmij_jeden PROC

		push	ebp
		mov		ebp, esp
		push	ebx
		
		mov		ebx, [ebp+8]	;w ebx jest adres komorki w ktorej jest adres zmiennej
		mov		eax, [ebx]		; w eax jest adres zmiennej
		dec		dword PTR [eax]

		pop		ebx
		pop		ebp
		ret

_odejmij_jeden ENDP
END