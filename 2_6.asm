.686
.model flat
extern _ExitProcess@4 :PROC
extern __write : PROC
extern __read : PROC
extern _MessageBoxA@16 : PROC
public _main

.data
tekst			db 'Prosze podac tekst '
				db 'i nacisnac Enter '
tekst_koniec	db ?
magazyn			db 80 dup(?)
ilosc_znakow	dd ?
tytul			db 'Zadanie 2_6',0
latin2			db 165,164,134,143,169,168,136,157,228,227,162,224,152,151,171,141,190,189
win1250			db 185,165,230,198,234,202,179,163,241,209,243,211,156,140,159,143,191,175

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

				;petla szukajaca polskich znakow
				mov		ilosc_znakow, eax
				mov		ecx, ilosc_znakow
				mov		esi, OFFSET magazyn

petla:			mov		dl, [esi]
				cmp		dl, 'z'
				ja		polskie_zn			;polskie znaki maja inne kody wiec trzeba je zmienic
nastepna:		inc		esi
				dec		ecx
				jnz		petla
				jmp		wypisz				;przeszlismy caly tekst, teraz idziemy do wypisac

polskie_zn:		push	ecx					;przechowujemy wartosc ecx aby nie zaburzyc zewnetrzenj petli
				mov		ecx, 18				;ilosc elementow w tablicy latin2
				mov		edi, 0				;indeks poczatkowy w tablicy latin 2

szukaj:			cmp		dl, latin2[edi]		;szukamy czy dany znak jest w tablicy z latin2
				je		podstaw				;jesli tak to zamieniamy jego wartosc
				inc		edi					;zwiekszamy adres i zmniejszamy licznik i szukamy dalej
				dec		ecx
				jnz		szukaj
				pop		ecx					;znak nie nalezy do polskich znakow wiec pozostaje bez zmian
				jmp		nastepna			;przywracamy wartosc licznikowi petli i wracamy do glownej petli

podstaw:		mov		dl, win1250[edi]	;zmieniamy znak z latin2 na znak z windows1250
				mov		[esi], dl			;wstawiamy do magazynu
				pop		ecx					;zwracamy wartosc ecx aby nie zaburzyc zewnetrznej petli
				jmp		nastepna			;powrot do glownej petli

wypisz:
		
		mov		[esi], byte PTR 0			;wstawiamy na koncu tekstu w magazynie znak 0
		push	0
		push	OFFSET tytul
		push	OFFSET magazyn
		push	0
		call	_MEssageBoxA@16				;wypisujemy zawartosc magazynu w MessageBoxie

		push	0
		call	_ExitProcess@4

_main ENDP
END
