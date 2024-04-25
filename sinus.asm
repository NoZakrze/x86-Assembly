.686
.model flat
public _findmaxrange

.data

grawitacja	dd	9.81
kat			dd 180.0
dwa			dd 2.0
.code

_findmaxrange PROC

		push	ebp
		mov		ebp,esp
		finit
		fild	dword PTR	[ebp+12]	;kat
		fldpi	
		fmul
		fld		dword PTR	kat
		fdiv						;kat w radianach
		fsincos
		fmul
		fld	dword PTR [ebp+8]		;v
		fld	dword PTR [ebp+8]		;v
		fmul						;v^2
		fmul						;v^2 * sin2alfa
		fld		dwa					
		fmul
		fld		grawitacja
		fdiv

		pop		ebp
		ret

_findmaxrange ENDP
END