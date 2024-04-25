.686
.model flat
extern _GetLocalTime@4 : PROC
public _daj_czas

.code
_daj_czas PROC

		push	ebp
		mov		ebp, esp

		sub		esp, 100


		push	ebx
		push	esi
		push	edi

		mov		esi, [ebp+8]
		lea		ebx, [esp]
		push	ebx
		call	_GetLocalTime@4
		mov		dl, [esp+8]
		mov		[esi], dl
		mov		dl, [esp+10]
		mov		[esi+1], dl

koniec:
		pop		edi
		pop		esi
		pop		ebx

		add		esp, 100


		pop		ebp
		ret
_daj_czas ENDP


END