.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main

.data
znaki	db 12 dup  (?)
pqr		dd 1,2,3,4,5
abx		db 2
.code
skoki	PROC

	mov		esi, [esp]
	mov		eax, [esi]
	add		eax, [esi+4]
	add		esi, 8
	mov		[esp], esi
	ret

skoki	ENDP

_main PROC

		mov		ebx, OFFSET pqr
		mov		ebx, pqr+1
		mov		eax,   [ebx+1]
		nop				



			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END