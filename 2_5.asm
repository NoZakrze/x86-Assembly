.686
.model flat
extern _ExitProcess@4 : PROC
extern __write		  : PROC
extern __read		  : PROC
public _main

.data
tekst_pocz		db 10,'Prosze napisac jakis tekst '
				db 'i nacisnac Enter', 10
koniec_t		db ?
magazyn			db 80 dup (?)
nowa_linia		db 10
liczba_znakow	dd ?

.code

_main PROC
		
				;write
				mov		ecx, OFFSET koniec_t - OFFSET tekst_pocz
				push	ecx
				push	OFFSET tekst_pocz
				push	1					;ekran nr 1
				call	__write
				add		esp,12

				;read
				push	80					;max znakow
				push	OFFSET magazyn
				push	0					;klawiatura ma nr 0
				call	__read
				add		esp, 12

				mov		liczba_znakow, eax	;read zapisuje liczbe znakow w eax
				mov		ecx, eax
				mov		esi, OFFSET magazyn

petla:			mov		dl, [esi]		;zaladowanie liczby z magazynu do dl
				cmp		dl, 'a'			
				jb		nastepna		;skok jesli mniejsza od 'a'
				cmp		dl, 'z'
				ja		polskie_znaki	;szukamy polskich znakow
				sub		dl, 20H			;zamiana malej na duza litere
				mov		[esi], dl		;podstawianie nowej wartosci do magazynu
nastepna:		inc		esi				;przejscie do kolejnego litery w magazynie
				dec		ecx				;zmniejszenie licznika petli
				jnz		petla
				jmp		wypisz

		
				
polskie_znaki:	cmp		dl, 0A5H
				je		litera_a
				cmp		dl, 86H
				je		litera_c
				cmp		dl, 0A9H
				je		litera_e
				cmp		dl, 88H
				je		litera_l
				cmp		dl, 0E4H
				je		litera_n
				cmp		dl, 0A2H
				je		litera_o
				cmp		dl, 98H
				je		litera_s
				cmp		dl, 0ABH
				je		litera_z_kreska
				cmp		dl, 0BEH
				je		litera_z_kropka
				jmp		nastepna

litera_a :		mov		dl, 0A4H
				mov		[esi], dl
				jmp		nastepna
litera_c :		mov		dl, 8FH
				mov		[esi], dl
				jmp		nastepna
litera_e :		mov		dl, 0A8H
				mov		[esi], dl
				jmp		nastepna
litera_l :		mov		dl, 9DH
				mov		[esi], dl
				jmp		nastepna
litera_n :		mov		dl, 0E3H
				mov		[esi], dl
				jmp		nastepna
litera_o :		mov		dl, 0E0H
				mov		[esi], dl
				jmp		nastepna
litera_s :		mov		dl, 97H
				mov		[esi], dl
				jmp		nastepna
litera_z_kreska : mov		dl, 8DH
				  mov		[esi], dl
				  jmp		nastepna
litera_z_kropka : mov		dl, 0BDH
				  mov		[esi], dl
				  jmp		nastepna

					
				;write z wynikiem
wypisz:			mov		ecx, liczba_znakow
				push	ecx
				push	OFFSET magazyn
				push	1
				call	__write
				add		esp, 12

				push	0
				call	_ExitProcess@4

_main ENDP
END