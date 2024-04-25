.686
.model flat
extern __read : PROC
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main

.data
znaki	db 12 dup  (?)

.code
wczytaj_do_EAX_hex PROC
			
			push	ebx
			push	ecx
			push	edx
			push	esi
			push	edi
			push	ebp

			sub		esp, 12
			mov		esi, esp

			push	dword PTR 10
			push	esi
			push	dword PTR 0
			call	__read
			add		esp, 12
			
			mov		eax, 0
pocz_konw:	
			mov		dl, [esi]
			inc		esi
			cmp		dl, 10
			je		gotowe

			cmp		dl , '0'
			jb		pocz_konw			;ignorujemy inne znaki
			cmp		dl, '9'
			ja		sprawdzaj_dalej
			sub		dl, '0'
dopisz:		
			shl		eax, 4
			or		al, dl				; w al starsze 4 bity zostaja, mlodsze 4 = dl ktory ma wartosc max 1111B
			jmp		pocz_konw

sprawdzaj_dalej:
			
			cmp		dl, 'A'
			jb		pocz_konw
			cmp		dl, 'F'
			ja		sprawdzaj_dalej_2
			sub		dl, 'A' - 10
			jmp		dopisz

sprawdzaj_dalej_2:
			
			cmp		dl, 'a'
			jb		pocz_konw
			cmp		dl, 'f'
			ja		pocz_konw
			sub		dl, 'a' - 10
			jmp		dopisz

gotowe:	
			add esp, 12					;zwolnienie obszaru pamieci na wczytana liczbe
			pop ebp
			pop edi
			pop esi
			pop edx
			pop ecx
			pop ebx
			ret

wczytaj_do_EAX_hex ENDP
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

			call	wczytaj_do_EAX_hex
			call	wyswietl_EAX
		
			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END