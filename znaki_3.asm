; iso -> utf 16
; szukanie sekwencji
; emotki
.686
.model flat
extern _MessageBoxW@16 : PROC
extern _ExitProcess@4  : PROC
public _main

.data
tytul	dw	'Z',0
tekst	db	'To jest g',234,182, ' i to te', 191,' jest g',234,182
koniec	db   ?
iso		db 117,161,230,198,234,202,179,163,241,209,243,211,182,166,188,172,191,175
utf		dw 105H,104H,107H,106H,119H,118H,142H,141H,144H,143H,0F3H,0D3H,15BH,15AH,17AH,179H,17CH,17BH
tekst_utf dw 80 dup (?)
wyjscie		dw 80 dup (?)
kaczka	dd	0DD86D83Eh
.code
_main PROC
		
		;iso -> utf16
		mov		esi, 0
		mov		edi, 0
		mov		ecx, koniec - tekst
petla:	mov		dl, tekst[esi]
		cmp		dl, 'z'
		ja		pol_zn
		mov		dh, 0
pow:	mov		tekst_utf[edi], dx
		add		edi, 2
		inc		esi
		dec		ecx
		jnz		petla
		jmp		sekwencja

pol_zn:			push	ecx											;przechowanie wartosci ecx potrzebnej w petli zewnetrznej
				mov		ecx, 18
				mov		ebx, 0										;indeks tablicy latin2
szukaj:			cmp		dl, iso[ebx]								;sprawdzenie czy ten znak jest w tablicy latin2
				je		podstaw										;postawienie znaku w utf-16
				inc		ebx
				dec		ecx
				jnz		szukaj
				pop		ecx											;przywrocenie wartosci ecx
				mov		dh, 0										;wyzerowanie starszego bajtu w utf-16
				jmp		pow	

podstaw:		mov		dx, utf[ebx*2]								;do dx zapisujemy reprezentacje znaku w utf-16 zwieta z tablicy utf
				pop		ecx											;przywrocenie wartosci ecx
				jmp		pow

				;szukanie sekwencji
sekwencja:
				mov		ecx, edi									;ilosc znakow
				mov		esi, 0
				mov		edi, 0
sek:			mov		dx, tekst_utf[esi]
				cmp		dx, 67H
				jne		brak
				cmp		ecx, 6
				jb		brak
				mov		bx, tekst_utf[esi+2]
				cmp		bx, 119H
				jne		brak
				cmp		ecx, 6
				jb		brak
				mov		bx, tekst_utf[esi+4]
				cmp		bx, 15BH
				jne		brak
				mov		ebx,  kaczka
				mov		dword PTR wyjscie[edi], ebx
				add		edi, 4
				add		esi, 6
				sub		ecx, 6
				jnz		sek
				jmp		wypisz

brak:			mov		wyjscie[edi], dx
				add		edi, 2
				add		esi, 2
				sub		ecx, 2
				jnz		sek


wypisz:
				mov		wyjscie[edi], word PTR 0
				push	0
				push	OFFSET tytul
				push	OFFSET wyjscie
				push	0
				call	_MessageBoxW@16

				push	0
		call	_ExitProcess@4

_main ENDP
END