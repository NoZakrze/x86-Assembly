.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
extern __read		  : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
magazyn			db 80 dup (0)
liczba_znakow	dd ?
magazyn2		db 80 dup(0)
slonce			dd	0DF1ED83Ch
tekst_utf		dw 160 dup(0)
latin2			db 165,164,134,143,169,168,136,157,228,227,162,224,152,151,171,141,190,189
utf				dw 105H,104H,107H,106H,119H,118H,142H,141H,144H,143H,0F3H,0D3H,15BH,15AH,17AH,179H,17CH,17BH
tytul			dw 't' 

.code
	
_main PROC


		push	80					;max znakow
		push	OFFSET magazyn
		push	0					;klawiatura ma nr 0
		call	__read
		add		esp, 12

		mov		ebx, 0					;indeks magazyn2
		mov		liczba_znakow, eax
		mov		ecx, eax
		mov		esi, ecx
		sub		ecx, 1
		sub		esi, 2
ptl:	mov		dl, magazyn[esi]
		cmp		dl ,32
		je		kopiuj
pow:	dec		esi
		dec		ecx
		jnz		ptl
		inc		esi

kopiuj: mov		edi, esi
		cmp		ecx, 0
		jz		ptl2
		inc		edi	
ptl2:	mov		dh, magazyn[edi]
		cmp		dh, 32
		je		zapisz_i_wroc
		cmp		dh, 10
		je		zapisz_i_wroc
		mov		magazyn2[ebx], dh
		inc		ebx
		inc		edi
		jmp		ptl2

zapisz_i_wroc:
		mov		magazyn2[ebx], 32
		inc		ebx
		cmp		ecx, 0
		jnz		pow



		;zamiana na utf
				mov		ecx, liczba_znakow
				mov		esi, OFFSET magazyn2						;esi jest indeksem tablicy magazyn
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
			

wypisz:
				mov	eax,  slonce
				mov	DWORD PTR tekst_utf[edi], eax 


				mov		ecx, liczba_znakow
				push	ecx
				push	OFFSET magazyn2
				push	1
				call	__write
				add		esp, 12


				push	0						;stala MB_OK
				push	OFFSET tytul
				push	OFFSET tekst_utf
				push	0						;uchwyt
				call	_MessageBoxW@16		


				push	0
				call	_ExitProcess@4

		
_main ENDP
END