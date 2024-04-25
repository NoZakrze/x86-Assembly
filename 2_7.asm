.686
.model flat
extern _ExitProcess@4 :PROC
extern __write : PROC
extern __read : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
tekst			db 'Prosze podac tekst '
				db 'i nacisnac Enter '
tekst_koniec	db ?
magazyn			db 80 dup(?)
ilosc_znakow	dd ?
tytul			dw 'Z','a','d','a','n','i','e',' ','2','_','7',0
tekst_UTF		dw 80 dup(?)
latin2			db 165,164,134,143,169,168,136,157,228,227,162,224,152,151,171,141,190,189
utf				dw 105H,104H,107H,106H,119H,118H,142H,141H,144H,143H,0F3H,0D3H,15BH,15AH,17AH,179H,17CH,17BH

.code

_main PROC
				;write z tekstem
				mov		ecx, OFFSET tekst_koniec - OFFSET tekst
				push	ecx
				push	OFFSET tekst
				push	1
				call	__write
				add		esp, 12

				;read do magazynu
				push	80
				push	OFFSET magazyn
				push	0
				call	__read
				add		esp, 12

				mov		ilosc_znakow, eax							;zapisanie ilosci znakow
				mov		ecx, eax
				mov		esi, OFFSET magazyn							;esi jest indeksem tablicy magazyn
				mov		edi, 0										;adres wynikowej tablicy
petla:			mov		dl, [esi]									;pobranie bajtu z magazynu
				cmp		dl, 'z'										;sprawdzenie czy to moze byc polski znak
				ja		polskie_zn
				mov		dh,0										;wyzerowanie starszego bajtu w UTF-16
pow_do_petli:	mov		tekst_UTF[edi], dx							;zapis znaku w UTF-16 do tablicy z wynikiem
				add		edi, 2										;zwiekszenie licznika tablicy wynikowej
				inc		esi											;zwiekszenie licznika indeksu magazynu
				dec		ecx											;zmniejszenie licznika petli
				jnz		petla
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

wypisz:			mov		tekst_UTF[edi], word PTR 0					;wpisnanie znaku o kodzie 0 na koniec tablicy wynikowej
				push	0
				push	OFFSET tytul
				push	OFFSET tekst_utf
				push	0
				call	_MessageBoxW@16								;wywolanie MessageBoxa

				push	0
				call	_ExitProcess@4

_main ENDP
END