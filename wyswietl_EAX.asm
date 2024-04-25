.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main

.data
znaki	db 12 dup  (?)

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
_main PROC

			mov		eax, 354

			call	wyswietl_EAX

			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END