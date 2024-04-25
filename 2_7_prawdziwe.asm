; LATIN2 -> WINDOWS1250
; LATIN2 -> UTF16
.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
latin2			db 165,164,134,143,169,168,136,157,228,227,162,224,152,151,171,141,190,189
utf				dw 105H,104H,107H,106H,119H,118H,142H,141H,144H,143H,0F3H,0D3H,15BH,15AH,17AH,179H,17CH,17BH
win1250			db 185,165,230,198,234,202,179,163,241,209,243,211,156,140,159,143,191,175
magazyn			db 80 dup (?)
magazyn_utf		dw 80 dup (?)
liczba_znakow	dd	?
tytulw			db 'tytul',0
tytulu			dw 't',0
.code
	
_main PROC
		
		;read
				push	80					;max znakow
				push	OFFSET magazyn
				push	0					;klawiatura ma nr 0
				call	__read
				add		esp, 12
		;zamiana na duze
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
				jmp		zamien

		
				
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
			
			;ZAMIANA NA UTF16 i windows1250

zamien:			mov		ecx, liczba_znakow
				mov		esi, 0
ptl:			mov		dl, magazyn[esi]
				cmp		dl, 'Z'
				ja		pol_zn
				mov		dh, 0
powrot:			mov		magazyn_utf[esi*2], dx
				mov		magazyn[esi], dl
powrot_z:		inc		esi
				dec		ecx
				jnz		ptl
				jmp		wypisz

pol_zn:			push	ecx
				mov		ecx, 18
				mov		edi, 0
ptl_wew:		cmp		dl, latin2[edi]
				je		podstaw
				inc		edi
				dec		ecx
				jnz		ptl_wew
				pop		ecx
				jmp		powrot

podstaw:		mov		dl,win1250[edi]
				mov		magazyn[esi], dl
				mov		dx, utf[edi*2]
				mov		magazyn_utf[esi*2], dx
				pop		ecx
				jmp		powrot_z
				
				;MESSAGEBOXY
wypisz:			mov		magazyn[esi], BYTE PTR 0
				mov		magazyn_utf[esi*2], WORD PTR 0
				
				push	0
				push	OFFSET tytulw
				push	OFFSET magazyn
				push	0
				call	_MessageBoxA@16


				push	0
				push	OFFSET tytulu
				push	OFFSET magazyn_utf
				push	0
				call	_MessageBoxW@16





		push	0
		call	_ExitProcess@4

_main ENDP
END