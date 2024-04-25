.686
.model flat
extern _GetEnvironmentVariableW@12 : PROC
extern __write : PROC
public _rozmiar

.code

_rozmiar PROC

		push	ebp
		mov		ebp, esp

		sub		esp, 100

		push	ebx
		push	esi
		push	edi

		mov		ebx, [ebp+8]	;adres nazwy
		lea		esi, [ebp-100]	;miejsce na output z funkcji

		mov		edi, ebx
nl:		mov		ax, [edi]
		add		edi, 2
		cmp		ax, 0Ah
		jne		nl
		mov		ax, 0
		lea		edi,[edi-2]
		mov		[edi], ax
		

		push	80
		push	esi
		push	ebx
		call	_GetEnvironmentVariableW@12

		cmp		eax, 0
		jne		sukces
		mov		[esi], byte PTR 'B'
		inc		esi
		mov		[esi], byte PTR 136
		inc		esi
		mov		[esi], byte PTR 165
		inc		esi
		mov		[esi], byte PTR 'd'
		inc		esi
		mov		[esi], byte PTR 10
		sub		esi, 4
		push	5
		push	esi
		push	1
		call	__write
		add		esp, 12
		mov		eax, -1
		jmp		koniec

sukces:

		;tutaj powinna byc jeszcze konwersja uft16 -> latin ale juz mi sie nie chce

		push	eax
		lea		eax,[eax+eax]
		push	eax
		push	esi
		push	1
		call	__write
		add		esp, 12
		pop		eax

koniec:
		pop		edi
		pop		esi
		pop		ebx
		add		esp, 100
		pop		ebp
		ret		


_rozmiar ENDP
END