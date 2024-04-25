.686
.model flat
extern __write : PROC
extern __read : PROC
extern _MessageBoxW@16 : PROC
extern _ExitProcess@4 : PROC
public _main

.data
dekoder		db '0123456789ABCD'
utf			dw 80 dup (?)
tytul		dw 't','y','t','u','l',0
.code
wyswietl_EAX_dwu PROC
			
			pusha

			sub		esp, 12
			mov		ebp, esp
			mov		esi, 0				;indeks w znaki
			mov		ebx, 14				;DZIELNIK
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
			pop		ecx				;ilosc znakow
			mov		esi,0			;znaki
			mov		edi,0			;utf
		
moja_petla:	mov		dl, [ebp+esi]
			mov		dh,0
			mov		utf[edi],dx
			add		edi, 2
			inc		esi
			dec		ecx
			jnz		moja_petla

			mov		utf[edi], word ptr 0
			add		edi,2

			push	0
			push	OFFSET tytul
			push	 OFFSET utf
			push	0
			call	_MessageBoxW@16


			add		esp, 12
			popa
			ret
wyswietl_EAX_dwu ENDP

_main PROC

			mov eax, 138
			call	wyswietl_EAX_dwu

			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END