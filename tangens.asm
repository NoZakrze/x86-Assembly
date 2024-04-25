.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main

.data

dns		dd 12.0
tangens	dd	?
ulamek	dd	?
wartosc	dd	?
tysiac	dd	1000.0
rejestr	dw	437H
wyniki	db 12 dup (?)
tmp_ecx	dd	?
.code

_main PROC

			mov		ecx, 5
			fldcw  rejestr
			fldpi
			fld		dns
			fdiv
			fldz
ptl:
			mov		tmp_ecx, ecx
			fst		st(2)
			fptan
			fdiv
			fstp	tangens
			fxch
			fadd	st(0), st(1)


			fld		tangens
			fld     tangens
			frndint
			fsub	st(1), st(0)	;st(1) czesc ulamkowa 
			fistp	wartosc
			fld		tysiac
			fmulp
			fistp	ulamek
			mov		eax, wartosc

					mov		esi, 0					;zapisanie wyniku dzielenia
			mov		ebx, 10
petla:		mov		edx, 0		
			div		ebx
			add		dl, 30H
			mov		wyniki[esi], dl
			inc		esi
			cmp		eax, 0
			jnz		petla				;odwrocenie wyniku

			push	esi					;przechowuje ilosc znakow wyniku na stosie
			mov		ecx, esi
			mov		esi, 0
			mov		edi, ecx
			dec		edi
odwroc:		mov		al, wyniki[esi]
			mov		ah, wyniki[edi]
			mov		wyniki[esi], ah
			mov		wyniki[edi], al
			inc		esi
			dec		edi
			sub		ecx, 2
			jg		odwroc

			pop		esi
			mov		wyniki[esi], '.'
			inc		esi


			mov		eax, ulamek
			push	esi						;przechowanie indeksu od ktorego zaczniemy odwracac

			mov		ecx, 3
			mov		ebx, 10
petla2:		mov		edx, 0		
			div		ebx
			add		dl, 30H
			mov		wyniki[esi], dl
			inc		esi
			dec		ecx
			jnz		petla2				;odwrocenie wyniku

			
			pop		esi
			mov		edi, esi
			add		edi, 2
			mov		al, wyniki[esi]
			mov		ah, wyniki[edi]
			mov		wyniki[esi], ah
			mov		wyniki[edi], al
			mov		wyniki[11], 10


			
			push	DWORD PTR 12
			push	DWORD PTR OFFSET wyniki
			push	DWORD PTR 1
			call	__write
			add		esp, 12
			

			mov		ecx, tmp_ecx
			dec		ecx
			jnz		ptl

			push	0
			call	_ExitProcess@4




_main ENDP
END