.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
extern __read : PROC
extern _putchar :PROC
public _main

.data
dekoder		db '0123456789ABCDEFGHIJ'

.code
wczytaj_do_EAX PROC
			push	ebx
			push	ecx
			push	edx
			push	esi
			push	edi
			push	ebp

			sub		esp, 12
			mov		ebp, esp

			push	dword PTR 12
			push	dword PTR ebp
			push	dword PTR 0
			call	__read
			add		esp, 12

			mov		eax, 0
			mov		ebx, ebp
			mov		edi, 10

petla:		mov		cl, [ebx]
			inc		ebx
			cmp		cl, 10
			jz		byl_enter
			sub		cl, 30H
			movzx	ecx, cl
			mul		edi
			add		eax, ecx
			jmp		petla

byl_enter:
			add		esp, 12
			pop		ebp
			pop		edi
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			ret

wczytaj_do_EAX ENDP
wyswietl_EAX_dwu PROC
			
			pusha

			sub		esp, 12
			mov		ebp, esp
			mov		esi, 0				;indeks w znaki
			mov		ebx, 20				;dzielnik
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

petelka:
			pusha
			push	dword PTR [ebp+esi]
			call	_putchar
			add		esp, 4
			popa
			inc		esi
			dec		ecx
			jnz		petelka

			add		esp, 12
			popa
			ret
wyswietl_EAX_dwu ENDP
_main PROC

			call	wczytaj_do_EAX
			call	wyswietl_EAX_dwu

			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END