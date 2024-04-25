.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data
znaki		db 12 dup  (?)
obszar		db 12 dup (?)
dziesiec	dd	10

.code
wyswietl_EAX PROC
			
			pusha

			mov		esi, 10			;indeks w znaki
			mov		ebx, 10			;dzielnik
konwersja:	
			mov		edx, 0			;zerujemy starsza czesc dzielnej
			div		ebx	
			add		dl, 30H
			mov		znaki[esi], dl
			dec		esi
			cmp		eax, 0
			jnz		konwersja
wypel:		
			or		esi, esi
			jz		wyswietl
			mov		 byte PTR znaki[esi], 20H
			dec		esi
			jmp		wypel
wyswietl:	
			mov		BYTE PTR znaki[0], 0AH	
			mov		BYTE PTR znaki[11], 0AH
			push	DWORD PTR 12
			push	DWORD PTR OFFSET znaki
			push	DWORD PTR 1
			call	__write
			add		esp, 12

			popa
			ret
wyswietl_EAX ENDP

wczytaj_do_EAX PROC
			push	ebx
			push	ecx
			push	edx
			push	esi
			push	edi
			push	ebp

			push	dword PTR 12
			push	dword PTR offset obszar
			push	dword PTR 0
			call	__read
			add		esp, 12

			mov		eax, 0
			mov		ebx, OFFSET obszar

petla:		mov		cl, [ebx]
			inc		ebx
			cmp		cl, 10
			jz		byl_enter
			sub		cl, 30H
			movzx	ecx, cl
			mul		dword PTR dziesiec
			add		eax, ecx
			jmp		petla

byl_enter:
			pop		ebp
			pop		edi
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			ret

wczytaj_do_EAX ENDP
_main PROC

			call	wczytaj_do_EAX

			mov		ebx, eax
			mul		ebx

			call	wyswietl_EAX

			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END