.686
.model flat
extern __write : PROC
extern __read  : PROC
extern _ExitProcess@4 : PROC
public _main

.data
v0 dd 0
v1 dd 0
podstawa	dd 10
.code
wczytaj PROC
			push	ebp
			mov		ebp, esp

			sub		esp, 28

			push	ebx
			push	ecx
			push	esi
			push	edi
			
			mov		esi, esp  ;poczatek tekstu
			
			push	30
			push	esi
			push	0
			call	__read
			add		esp, 12

			mov		edx, 0
			mov		eax, 0
			mov		edi, 0	;indeks

wczytuj:	mov		cl, [esi+edi]
			cmp		cl, 10
			je		koniec
			mov		eax, v0
			mov		edx, 0
			mul		podstawa
			mov		ebx, edx   ;starsza czesc z pierwszego mnozenia
			sub		cl, '0'
			movzx	ecx, cl
			add		eax, ecx
			mov		v0, eax
			adc		ebx, 0
			mov		edx, 0
			mov		eax, v1
			mul		podstawa
			add		eax, ebx
			mov		v1, eax
			inc		edi
			jmp		wczytuj

koniec:
		mov		eax, v0
		mov		edx, v1
		add		esp, 28
		pop		edi
		pop		esi
		pop		ecx
		pop		ebx
		pop		ebp
		ret
wczytaj ENDP

_main PROC

			call	wczytaj
			nop
		
			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END