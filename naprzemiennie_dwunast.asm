.686
.model flat
extern __read : PROC
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main

.data
liczba_1	db	12 dup (?)
liczba_2    db	12 dup (?)
dekoder		db '0123456789AB'
.code
wyswietl_EAX_dwu PROC
			
			pusha

			sub		esp, 12
			mov		ebp, esp
			mov		esi, 10				;indeks w znaki
			mov		ebx, 12				;dzielnik
konwersja:	
			mov		edx, 0				;zerujemy starsza czesc dzielnej
			div		ebx	
			mov		cl, dekoder[edx]	;znak z dekodera o wartosci reszty
			mov		[ebp+esi], cl
			dec		esi
			cmp		eax, 0
			jnz		konwersja
wypel:		
			or		esi, esi
			jz		wyswietl
			mov		 byte PTR [ebp+esi], 20H
			dec		esi
			jmp		wypel
wyswietl:	
			mov		BYTE PTR [ebp], 20H	
			mov		BYTE PTR [ebp+11], 0AH
			push	DWORD PTR 12
			push	DWORD PTR ebp
			push	DWORD PTR 1
			call	__write
			add		esp, 24

			popa
			ret
wyswietl_EAX_dwu ENDP

wczytaj_do_EAX_dwu PROC
		
		push	ebp
		mov		ebp, esp		;ebp+8 adres naszej liczby
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi


		mov		ebx, 12			;mnoznik
		lea		esi, [ebp+8]	;w esi jest teraz adres naszej liczby
		mov		eax, [esi]
		mov		esi, eax
		mov		eax, 0			;wynik
		mov		edi, 0			;indeks

wpisuj:
		
		mov		ecx, 0
		mov		cl, [esi][edi]
		cmp		cl, 10
		je		zakoncz
		mov		edx, 0
		mul		ebx
		cmp		cl, '9'
		jbe		cyfra
		cmp		cl, 'B'
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
		
		pop		edi
		pop		esi
		pop		edx
		pop		ecx
		pop		ebx
		pop		ebp
		ret
wczytaj_do_EAX_dwu ENDP

_main PROC
		
	
		;wczytanie 2 liczb

		push	10
		push	offset liczba_1
		push	0
		call	__read
		add		esp, 12

		push	10
		push	offset liczba_2
		push	0
		call	__read
		add		esp, 12

		;sprawdzenie poprawnosci liczb

		mov		esi, 0

sprawdz_1:		
		cmp		liczba_1[esi],10
		je		koniec_1
		cmp		liczba_1[esi],'0'
		jb		wyjscie
		cmp		liczba_1[esi],'9'
		jbe		oki_1
		cmp		liczba_1[esi],'A'
		jb		wyjscie
		cmp		liczba_1[esi],'B'
		jbe		oki_1	
		cmp		liczba_1[esi],'a'
		jb		wyjscie
		cmp		liczba_1[esi],'b'
		ja		wyjscie


oki_1:
	inc		esi
	jmp		sprawdz_1

koniec_1:

		mov		esi, 0

sprawdz_2:		
		cmp		liczba_2[esi],10
		je		koniec_2
		cmp		liczba_2[esi],'0'
		jb		wyjscie
		cmp		liczba_2[esi],'9'
		jbe		oki_2
		cmp		liczba_2[esi],'A'
		jb		wyjscie
		cmp		liczba_2[esi],'B'
		jbe		oki_2	
		cmp		liczba_2[esi],'a'
		jb		wyjscie
		cmp		liczba_2[esi],'b'
		ja		wyjscie

oki_2:
	inc		esi
	jmp		sprawdz_2


koniec_2:

		;wczytanie liczb z pamieci do rejestrow esi i edi

		push	OFFSET liczba_1
		call	wczytaj_do_EAX_dwu
		add		esp, 4
		mov		esi, eax				;esi = n
		push	OFFSET liczba_2
		call	wczytaj_do_EAX_dwu
		add		esp, 4
		mov		edi, eax				;edi = p

		;petla programu

		mov		ecx, esi
		mov		ebx, 0						;wartosc dodawana/odejmowana
		mov		edx, 0					;flaga czy dodajemy czy odejmujemy
		mov		eax, edi
petla:
		cmp		edx, 0
		je		dodajemy
		sub		eax, ebx
		call	wyswietl_EAX_dwu
wroc:	
		xor		edx, 1	
		inc		ebx
		dec		ecx
		jnz		petla
		jmp		wyjscie

dodajemy:
		add		eax, ebx
		call	wyswietl_EAX_dwu
		jmp		wroc



wyjscie:
		push	1
		call	_ExitProcess@4


_main ENDP
END