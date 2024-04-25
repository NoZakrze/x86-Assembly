.686
.model flat
extern __write : PROC
extern __read	: PROC
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
magazyn		db 80 dup (?)
magazyn2	db	80 dup (?)
magazyn_utf	dw	80 dup (?)
latin2			db 165,164,134,143,169,168,136,157,228,227,162,224,152,151,171,141,190,189
utf				dw 105H,104H,107H,106H,119H,118H,142H,141H,144H,143H,0F3H,0D3H,15BH,15AH,17AH,179H,17CH,17BH
liczba_znakow	dd ?
sekwencja		db '1234'
nowe			db 'liczba'
tytul			dw 'y'
.code
	
_main PROC
		
		;read
				push	80					;max znakow
				push	OFFSET magazyn
				push	0					;klawiatura ma nr 0
				call	__read
				add		esp, 12

		;odwroc czworkami
				
				dec		eax
				mov		liczba_znakow, eax
				mov		esi, 0
				mov		ecx, eax
odwroc:			mov		eax,  dword PTR magazyn[esi]
				bswap	eax
				mov		dword PTR magazyn[esi], eax
				add		esi, 4
				sub		ecx, 4
				jnz		odwroc

			

		;szukaj sekwencji
				
			mov		ecx, liczba_znakow
			mov		edi, OFFSET magazyn
			mov		esi, 0
			mov		edx, DWORD PTR sekwencja

petla:		mov		eax, [edi]
			cmp		eax, edx
			je		usun
			mov		magazyn2[esi], al
			add		edi, 1
			inc		esi
			sub		ecx, 1
			jnz		petla
			jmp		utfy

usun:		
			push	ecx
			mov		ecx, 6
			mov		ebp, 0
ptl:		mov		bl, nowe[ebp]
			mov		magazyn2[esi], bl
			add		esi, 1
			inc		ebp
			sub		ecx, 1
			jnz		ptl
			add		edi, 4
			pop		ecx
			sub		ecx, 4
			jnle	petla

		;latin->utf
utfy:

				mov		liczba_znakow, esi							;zapisanie ilosci znakow
				mov		ecx, esi
				mov		esi, OFFSET magazyn2						;esi jest indeksem tablicy magazyn
				mov		edi, 0										;adres wynikowej tablicy
petla2:			mov		dl, [esi]									;pobranie bajtu z magazynu
				cmp		dl, 'z'										;sprawdzenie czy to moze byc polski znak
				ja		polskie_zn
				mov		dh,0										;wyzerowanie starszego bajtu w UTF-16
pow_do_petli:	mov		magazyn_utf[edi], dx							;zapis znaku w UTF-16 do tablicy z wynikiem
				add		edi, 2										;zwiekszenie licznika tablicy wynikowej
				inc		esi											;zwiekszenie licznika indeksu magazynu
				dec		ecx											;zmniejszenie licznika petli
				jnz		petla2
				jmp		wypisz										;gdy wszyskie znaki beda zapisane w utf_16 skok do wypisania ich

polskie_zn:		push	ecx											;przechowanie wartosci ecx potrzebnej w petli zewnetrznej
				mov		ebx, 0										;indeks tablicy latin2
szukaj:			cmp		dl, latin2[ebx]								;sprawdzenie czy ten znak jest w tablicy latin2
				je		podstaw										;postawienie znaku w utf-16
				inc		ebx
				dec		ecx
				jnz		szukaj
				pop		ecx											;przywrocenie wartosci ecx
				mov		dh, 0										;wyzerowanie starszego bajtu w utf-16
				jmp		pow_do_petli	

podstaw:		mov		dx, utf[ebx*2]								;do dx zapisujemy reprezentacje znaku w utf-16 zwieta z tablicy utf
				pop		ecx											;przywrocenie wartosci ecx
				jmp		pow_do_petli


wypisz:
				mov		magazyn_utf[edi], word PTR 0					;wpisnanie znaku o kodzie 0 na koniec tablicy wynikowej
				push	0
				push	OFFSET tytul
				push	OFFSET magazyn_utf
				push	0
				call	_MessageBoxW@16								;wywolanie MessageBoxa


		push	0
		call	_ExitProcess@4

_main ENDP
END