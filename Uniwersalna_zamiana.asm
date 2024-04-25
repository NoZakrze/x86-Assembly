.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data
dekoder		db '0123456789ABCDEFGHIJ'

.code
wyswietl_EAX_dwu PROC
			
			pusha

			sub		esp, 12
			mov		ebp, esp
			mov		esi, 0				;indeks w znaki
			mov		ebx, 20				;DZIELNIK
konwersja:	
			mov		edx, 0				;zerujemy starsza czesc dzielnej
			div		ebx	
			mov		cl, dekoder[edx]	;znak z dekodera o wartosci reszty
			mov		[ebp+esi], cl
			inc		esi
			cmp		eax, 0
			jnz		konwersja


			push	esi						;przechowuje ilosc znakow wyniku na stosie
			mov		ecx, esi
			mov		esi, 0
			mov		edi, ecx
			dec		edi

odwroc:		mov		dl, [ebp+esi]
			mov		dh, [ebp+edi]
			mov		[ebp+esi], dh
			mov		[ebp+edi], dl
			inc		esi
			dec		edi
			sub		ecx, 2
			jg		odwroc


wyswietl:	
			pop		ecx
			mov		esi, 0

			push	ecx
			push	ebp
			push	1
			call	__write

			add		esp, 24
			popa
			ret
wyswietl_EAX_dwu ENDP
wczytaj_do_EAX_dwu PROC
		
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi
		push	ebp

		sub		esp, 12
		mov		ebp, esp		;ebp wskazuje na nasza liczbe

		push	12
		push	ebp
		push	0
		call	__read
		add		esp, 12


		mov		ebx, 20			;MNOZNIK
		mov		eax, 0			;wynik
		mov		edi, 0			;indeks

wpisuj:
		
		mov		ecx, 0
		mov		cl, [ebp][edi]
		cmp		cl, 10
		je		zakoncz
		mov		edx, 0
		mul		ebx
		cmp		cl, '9'
		jbe		cyfra
		cmp		cl, 'J'
		jbe		duza
		sub		cl, 'a'-10
dalej:	add		eax, ecx
		inc		edi
		jmp		wpisuj

duza:
		sub		cl, 'A'-10
		jmp		dalej
cyfra:	
		sub		cl, '0'
		jmp		dalej

zakoncz:
		
		add		esp, 12
		pop		ebp
		pop		edi
		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		ret
wczytaj_do_EAX_dwu ENDP
_main PROC

			call	wczytaj_do_EAX_dwu
			nop
			call	wyswietl_EAX_dwu

			

			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END