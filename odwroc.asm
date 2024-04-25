;ODWROCENIE TEKSTU
;LATIN2 -> UTF-16

.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
magazyn			db 80 dup (?)
magazyn_utf		dw 80 dup (?)
liczba_znakow	dd ?
win1250			db 185,165,230,198,234,202,179,163,241,209,243,211,156,140,159,143,191,175
latin2			db 165,164,134,143,169,168,136,157,228,227,162,224,152,151,171,141,190,189
utf				dw 105H,104H,107H,106H,119H,118H,142H,141H,144H,143H,0F3H,0D3H,15BH,15AH,17AH,179H,17CH,17BH
tytul			dw 't','y',0

.code
	
_main PROC
		
		;read
		push	80					
		push	OFFSET magazyn
		push	0					
		call	__read
		add		esp, 12		
		
		dec		eax
		mov		liczba_znakow, eax
		mov		edx, 0
		mov		ebx, 2
		div		ebx
		mov		ecx, eax
		mov		esi,liczba_znakow
		sub		esi, 1
		mov		edi, 0

		;odwroc tekst
odw:	mov		al, magazyn[edi]
		mov		dl, magazyn[esi]
		mov		magazyn[edi], dl
		mov		magazyn[esi], al
		inc		edi
		dec		esi
		dec		ecx
		jnz		odw



		mov		esi, 0
		mov		edi, 0
		mov		ecx, liczba_znakow
petla:	mov		dl, magazyn[esi]
		cmp		dl, 'z'
		ja		pol_zn
		mov		dh, 0
pow:	mov		magazyn_utf[edi], dx
		add		edi, 2
		inc		esi
		dec		ecx
		jnz		petla
		jmp		wypisz

pol_zn:			push	ecx											;przechowanie wartosci ecx potrzebnej w petli zewnetrznej
				mov		ecx, 18
				mov		ebx, 0										;indeks tablicy latin2
szukaj:			cmp		dl, latin2[ebx]								;sprawdzenie czy ten znak jest w tablicy latin2
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

wypisz:

		mov		ecx, liczba_znakow
		push	ecx
		push	OFFSET magazyn
		push	1
		call	__write
		add		esp, 12

		
		mov		magazyn_utf[edi], word PTR 0
		push	0
		push	OFFSET tytul
		push	OFFSET magazyn_utf
		push	0
		call	_MessageBoxW@16


		push	0
		call	_ExitProcess@4

		


_main ENDP
END
