;WYKRYWANIE SEKWENCJI
;UTF16 -> LATIN2
;WINDOWS1250 -> LATIN2
.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main

.data
tekst			dw 017BH, 00F3H, 0142H, 0107H, ' ', 't', 'o', ' ','l','i','p','a'
koniec			db ?
do_usuniecia	db '¯ó³æ'
latin2			db 165,164,134,143,169,168,136,157,228,227,162,224,152,151,171,141,190,189
utf				dw 105H,104H,107H,106H,119H,118H,142H,141H,144H,143H,0F3H,0D3H,15BH,15AH,17AH,179H,17CH,17BH
win1250			db 185,165,230,198,234,202,179,163,241,209,243,211,156,140,159,143,191,175
nowe			db 'XXXX-XXXX'
wyjscie			db 100 dup (?)
magazyn			db 100 dup (?)
.code
	
_main PROC
		
		;ZAMIANA DO_USUNIECIA NA LATIN2

				mov		ecx, 4
				mov		ebx, OFFSET do_usuniecia
petla:			mov		dl, [ebx]
				cmp		dl, 'z'
				jb		nastepny			;jesli to zwykly znak z zakresu 0-127 to przepisujemy go

				push	ecx					;przechowujemy wartosc ecx aby nie zaburzyc zewnetrzenj petli
				mov		ecx, 18				;ilosc elementow w tablicy win1250
				mov		edi, 0				;indeks poczatkowy w tablicy win1250

szukaj:			cmp		dl, win1250[edi]	;szukamy czy dany znak jest w tablicy z win1250
				je		podstaw				;jesli tak to zamieniamy jego wartosc
				inc		edi					;zwiekszamy adres i zmniejszamy licznik i szukamy dalej
				dec		ecx
				jnz		szukaj
				pop		ecx					;znak nie nalezy do polskich znakow wiec pozostaje bez zmian
				jmp		nastepny			;przywracamy wartosc licznikowi petli i wracamy do glownej petli

podstaw:		mov		dl, latin2[edi]		;zmieniamy znak z win1250 na znak z latin2
				pop		ecx					;zwracamy wartosc ecx aby nie zaburzyc zewnetrznej petli
				jmp		nastepny			;powrot do glownej petli

nastepny:		mov		[ebx], dl			;ladujemy znak z powrotem do pamieci
				inc		ebx
				dec		ecx
				jnz		petla

		;ZAMIANA TEKSTU NA LATIN2

				mov		ecx, koniec - tekst							;ilosc znakow
				mov		ebx, OFFSET tekst							;ebx bedzie wskazywal na komórke pamieci na której obecnie operujemy
				mov		edi, OFFSET magazyn							;edi bedzie wskazywal na magazyn gdzie bedziemy ladowac znaki zakodowane w latin2
petla_utf:		mov		dx, [ebx]									;pobieramy znak utf-16 z pamieci (2 bajty)
				cmp		dx, WORD PTR 'z'
				ja		polskie_utf									;zamiane polskich znakow musimy rozpatrzec osobno
powrot:			mov		[edi], dl
				inc		edi
				add		ebx, 2
				sub		ecx, 2
				jnz		petla_utf
				jmp		do_sekwencji								;tekst zostal przekodowany, przechodzimy do nastepnej sekcji programu

polskie_utf:	push	ecx											;przechowanie wartosci ecx potrzebnej w petli zewnetrznej
				mov		ecx, 18
				mov		esi, 0										;indeks tablicy utf-16
szukaj2:		cmp		dx, utf[esi*2]								;sprawdzenie czy ten znak jest w tablicy utf-16
				je		podstaw2										;postawienie znaku w latin
				inc		esi
				dec		ecx
				jnz		szukaj2
				pop		ecx											;przywrocenie wartosci ecx									;wyzerowanie starszego bajtu w utf-16
				jmp		powrot	

podstaw2:		mov		dl, latin2[esi]								;do dx zapisujemy reprezentacje znaku w latin2 zwieta z tablicy utf
				pop		ecx											;przywrocenie wartosci ecx
				jmp		powrot

		;USUNIECIE SEKWENCJI
				
do_sekwencji:	mov		esi, OFFSET magazyn
				mov		edi, 0										;indeks w pamieci na ktorym operujemy aktualnie
				mov		ecx, koniec - tekst
ost_petla:		mov		eax, DWORD PTR [esi]						;pobieramy z magazynu 4 bajty
				cmp		eax, DWORD PTR do_usuniecia					;porownojemy te 4 bajty z bajtami z "do_usuniecia"
				je		usun										;usuwamy sekwencje jesli natrafilismy na nia
				mov		wyjscie[edi], al							;jesli nie to ladujemy bajt do tablicy wynikowej
				inc		edi
				inc		esi
pow:			sub		ecx, 2
				jnz		ost_petla
				jmp		wypisz										;caly tekst zostal sprawdzony, przechodzimy do wypisania znakow na ekran

usun:			push	ecx											;aby nie zaklocic glownej petli, przechowujemy wartosc ecx na stosie
				mov		ecx, 9										;ilosc znakow w "nowe"
				mov		ebx, OFFSET nowe
ptl:			mov		dl, [ebx]									;ta petla zapisuje po kolei kazdy znak z "nowe" do tablicy wynikowej
				mov		wyjscie[edi], dl							
				inc		ebx
				inc		edi
				dec		ecx
				jnz		ptl
				add		esi, 4										;pomijamy 4 bajty w magazynie bo zastapilismy je wlasnie sekwencje "nowe"
				pop		ecx											;przed powrotem przywracamy wartosc pierwotna ecx
				jmp		pow											;powrot do petli szukajacej sekwencji

		;WYPISANIE WYNIKU
				
wypisz:			mov		ecx, edi									;zapisujac w poprzedniej petli znak do "wyjscie" zwiekszalismy zawsze o 1
				push	ecx											;edi ktore na poczatku mialo wartosc 0 wiec aktualnie zawiera ilosc znakow
				push	OFFSET wyjscie								;zapisanych w "wyjscie"
				push	1
				call	__write
				add		esp, 12
				push	0
				call	_ExitProcess@4
		
_main ENDP
END