.686
.model flat
public _srednia_harm

.code

_srednia_harm PROC

			push	ebp
			mov		ebp ,esp

			finit
			mov		ecx, [ebp+12]
			mov		ebx, [ebp+8]
			fldz
szereg:		fld1
			fld		dword PTR [ebx]
			fdivp
			faddp
			add		ebx, 4
			loop	szereg

			fild	dword ptr [ebp+12]
			fxch	st(1)
			fdivp

			pop		ebp
			ret

_srednia_harm ENDP
END