.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data

dekoder db '0123456789ABCDEF'
obszar		db 12 dup (?)
dziesiec	dd	10

.code
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

wyswietl_EAX_hex PROC

			pusha
			sub		esp, 12
			mov		edi, esp	;adres roboczego obszaru pamieci na stosie
			mov		ecx, 8
			mov		esi, 1

ptl3hex:	
			rol		eax, 4
			mov		ebx, eax
			and		ebx, 0000000FH
			mov		dl, dekoder[ebx]
			mov		[edi][esi], dl
			inc		esi
			loop	ptl3hex

			mov		byte PTR [edi][0], 10
			mov		byte PTR [edi][9], 10

			mov		esi, 1
			mov		ecx, 7

spacje:		mov		dl, [edi][esi]
			cmp		dl, '0'
			jne		wypisz
			mov		dl, 20H
			mov		[edi][esi], dl
			inc		esi
			dec		ecx
			loop	spacje


wypisz:
			push	dword PTR 10
			push	edi
			push	1
			call	__write
			add		esp, 24

			popa
			ret

wyswietl_EAX_hex ENDP
_main PROC

			call	wczytaj_do_EAX
			call	wyswietl_EAX_hex
			
			push	DWORD PTR 0
			call	_ExitProcess@4
_main ENDP
END