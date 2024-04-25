.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data
dekoder		db '0123456789ABCDEFGHIJ'
wynik		db 12 dup (32)

.code
wczytaj_do_EAX_dwu PROC
		
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi
		push	ebp

		sub		esp, 12
		mov		ebp, esp		;ebp wskazuje na nasza liczbe

		push	12
		push	ebp
		push	0
		call	__read
		add		esp, 12


		mov		ebx, 20			;mnoznik
		mov		eax, 0			;wynik
		mov		edi, 0			;indeks

wpisuj:
		
		mov		ecx, 0
		mov		cl, [ebp][edi]
		cmp		cl, 10
		je		zakoncz
		mov		edx, 0
		mul		ebx
		cmp		cl, '9'
		jbe		cyfra
		cmp		cl, 'J'
		jbe		duza
		sub		cl, 'a'-10
dalej:	add		eax, ecx
		inc		edi
		jmp		wpisuj

duza:
		sub		cl, 'A'-10
		jmp		dalej
cyfra:	
		sub		cl, '0'
		jmp		dalej

zakoncz:
		
		add		esp, 12
		pop		ebp
		pop		edi
		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		ret
wczytaj_do_EAX_dwu ENDP
_main PROC
			
			call	wczytaj_do_EAX_dwu
			mov		esi, eax				;pierwsza liczba w esi
			call	wczytaj_do_EAX_dwu
			mov		edi, eax				;druga liczba w edi
			
			mov		eax, esi
			mov		edx, 0
			div		edi						;trzeba wyswietliæ eax, kropke i edx/edi*1000
			push	edx						;zapisuje reszte na stosie
			push	edi						;zapisuje druga liczbe na stosie

			mov		esi, 0					;zapisanie wyniku dzielenia
			mov		ebx, 10
petla:		mov		edx, 0		
			div		ebx
			add		dl, 30H
			mov		wynik[esi], dl
			inc		esi
			cmp		eax, 0
			jnz		petla				;odwrocenie wyniku

			push	esi						;przechowuje ilosc znakow wyniku na stosie
			mov		ecx, esi
			mov		esi, 0
			mov		edi, ecx
			dec		edi
odwroc:		mov		al, wynik[esi]
			mov		ah, wynik[edi]
			mov		wynik[esi], ah
			mov		wynik[edi], al
			inc		esi
			dec		edi
			sub		ecx, 2
			jg		odwroc

			pop		esi
			mov		wynik[esi], '.'
			inc		esi


			pop		ebx						;dzielnik
			pop		eax						;reszta
			push	esi						;przechowanie indeksu od ktorego zaczniemy odwracac
			mov		ebp, 1000				;mnoznik
			mov		edx, 0
			mul		ebp
			div		ebx

			mov		ecx, 3
			mov		ebx, 10
petla2:		mov		edx, 0		
			div		ebx
			add		dl, 30H
			mov		wynik[esi], dl
			inc		esi
			dec		ecx
			jnz		petla2				;odwrocenie wyniku

			pop		esi
			mov		edi, esi
			add		edi, 2
			mov		al, wynik[esi]
			mov		ah, wynik[edi]
			mov		wynik[esi], ah
			mov		wynik[edi], al



			push	DWORD PTR 12
			push	DWORD PTR OFFSET wynik
			push	DWORD PTR 1
			call	__write
			add		esp, 12




			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END