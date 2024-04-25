.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
extern __read : PROC
public _main

.data
dekoder	db	'0123456789ABC'

.code
wyswietl_EAX_U13 PROC
			pusha

			sub		esp, 12
			mov		ebp, esp


			bt		eax, 31
			jc		ujemna
			mov		byte PTR [ebp], '+'		;liczba dodatnia
wypisz:
			mov		esi, 1					
			mov		ebx, 13
petla:		mov		edx, 0		
			div		ebx
			cmp		dl, 9
			ja		litera
			add		dl, '0'
			jmp		dalej
litera:		add		dl, 'A' - 10
dalej:		mov		[ebp][esi], dl
			inc		esi
			cmp		eax, 0
			jnz		petla				;odwrocenie wyniku

			push	esi
			mov		ecx, esi
			dec		ecx
			mov		esi, 1
			mov		edi, ecx
odwroc:		mov		al, [ebp][esi]
			mov		ah, [ebp][edi]
			mov		[ebp][esi], ah
			mov		[ebp][edi], al
			inc		esi
			dec		edi
			sub		ecx, 2
			jg		odwroc
			jmp		zakoncz

ujemna:
			mov		byte PTR [ebp], '-'		;liczba ujemna
			neg		eax						;zamiana liczby ujemnej na dodatnia
			jmp		wypisz


zakoncz:
			
			pop		ecx
			push	ecx
			push	ebp
			push	1
			call	__write
			add		esp, 24

			popa
			ret
wyswietl_EAX_U13 ENDP

wczytaj_do_EAX_U13 PROC
	
			push	ebx
			push	ecx
			push	edx
			push	esi
			push	edi
			push	ebp

			mov		ebp, esp
			sub		esp, 12

			push	12
			push	ebp
			push	0
			call	__read
			add		esp, 12

			mov		dl, [ebp]
			cmp		dl, '-'
			je		ujemna2			;jesli liczba zaczyna sie od znaku '-' to jest ujemna
			mov		ebx, 13			;mnoznik
			mov		eax, 0			;wynik
			mov		edi, 0			;indeks
wpisuj:
			mov		ecx, 0
			mov		cl, [ebp][edi]
			cmp		cl, 10
			je		zakoncz2
			mov		edx, 0
			mul		ebx
			cmp		cl, '9'
			jbe		cyfra
			cmp		cl, 'J'
			jbe		duza
dalej2:		add		eax, ecx
			inc		edi
			jmp		wpisuj

duza:
		sub		cl, 'A'-10
		jmp		dalej2
cyfra:	
		sub		cl, '0'
		jmp		dalej2
		
		;CZESC UJEMNA

ujemna2:
			mov		ebx, 13			;mnoznik
			mov		eax, 0			;wynik
			mov		edi, 1			;indeks			;bo znak o indeksie 0 to '-'
wpisuj2:
			mov		ecx, 0
			mov		cl, [ebp][edi]
			cmp		cl, 10
			je		neguj
			mov		edx, 0
			mul		ebx
			cmp		cl, '9'
			jbe		cyfra2
			cmp		cl, 'J'
			jbe		duza2
dalej3:		add		eax, ecx
			inc		edi
			jmp		wpisuj2

duza2:
			sub		cl, 'A'-10
			jmp		dalej3
cyfra2:	
			sub		cl, '0'
			jmp		dalej3
		
neguj:		neg		eax
zakoncz2:
			add		esp, 12
			pop		ebp
			pop		edi
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			ret

wczytaj_do_EAX_U13 ENDP
_main PROC

			call	wczytaj_do_EAX_U13
			sub		eax, 10
			call	wyswietl_EAX_U13

			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END