.686
.model flat
extern _GetSystemDirectoryA@8 : PROC
public _check_dir

.code

_check_dir PROC

			push	ebp
			mov		ebp, esp

			sub		esp, 100

			push	ebx
			push	esi
			push	edi

			lea		ebx, [ebp-100]

			push	100
			push	ebx
			call	_GetSystemDirectoryA@8

			mov		ecx, eax
			lea		esi, [ebp+8]
			lea		edi, [ebx]
			mov		eax, [esi]
			mov		esi, eax

petla:		mov		dl,  [esi]
			cmp		dl,	 [edi]
			jne		falsz
			inc		esi
			inc		edi
			loop	petla
			mov		eax, 1
			jmp		koniec

falsz:		mov		eax, 0

koniec:		pop		edi
			pop		esi
			pop		ebx
			add		esp, 100
			pop		ebp
			ret

_check_dir ENDP
END