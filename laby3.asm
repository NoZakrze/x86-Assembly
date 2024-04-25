.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data
dekoder		db '0123456789'
dzielnik	dd	10
kropka		db 0
.code
wyswietl_EAX_dwu PROC
			
			pusha

			sub		esp, 12
			mov		ebp, esp
			mov		esi, 0				;indeks w znaki
			movzx	ebx, cl				;przesuniecie

konwersja:	
			mov		edx, 0				;zerujemy starsza czesc dzielnej
			div		dzielnik	
			mov		cl, dekoder[edx]	;znak z dekodera o wartosci reszty
			mov		[ebp+esi], cl
			inc		esi
			dec		ebx
			cmp		ebx, 0
			jz		wstaw_kropke
wracam:
			cmp		eax, 0
			jnz		konwersja

			mov		cl, kropka
			cmp		cl, 1
			je		kropka_wstawiona
			
dop:		mov		[ebp+esi], byte ptr '0'
			inc		esi
			dec		ebx
			jnz		dop
			mov		[ebp+esi], byte ptr '.'
			inc		esi
			mov		[ebp+esi], byte ptr '0'
			inc		esi

kropka_wstawiona:
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
			jmp		koniec

wstaw_kropke:
			mov		[ebp+esi], byte ptr '.'
			inc		esi
			mov		kropka, byte ptr 1
			jmp		wracam

koniec:
			add		esp, 24
			popa
			ret
wyswietl_EAX_dwu ENDP

_main PROC

			mov eax, 15
			;mov cl, 1
			;call wyswietl_EAX_dwu     ; w konsoli: 1.5
			mov cl, 3
			call wyswietl_EAX_dwu     ; w konsoli: 0.015

			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END