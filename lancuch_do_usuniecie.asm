;USUWANIE SEKWENCJI
;UTF16 BE -> UTF16 LE
.686
.model flat
extern _ExitProcess@4 :PROC
extern __write : PROC
extern __read : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
tekst			db	0,'A',0,'l',0,'a',0,' ',0,'m',0,'a',0,' ',0,'k',0,'o',0,'t',0,'a'
koniec			db ?
wyjscie			db	80 dup (?)
dlugosc_tekstu	dd ?
tytul			dw 'Z','a','d','a','n','i','e',' ','2','_','7',0
do_usuniecia	db 'l',0,'a',0

.code
	
_main PROC
			mov		ecx, OFFSET koniec - OFFSET tekst
			mov		dlugosc_tekstu, ecx
			mov		esi, OFFSET tekst

ptl1:		mov		ax, [esi]
			xchg	ah, al
			mov		[esi], ax
			add		esi, 2
			sub		ecx, 2
			jnz		ptl1

			mov		ecx, dlugosc_tekstu
			mov		esi, OFFSET tekst
			mov		edi, OFFSET wyjscie
			mov		edx, DWORD PTR do_usuniecia

petla:		mov		eax, [esi]
			cmp		eax, edx
			je		usun
			mov		[edi], ax
			add		esi, 2
			add		edi, 2
			sub		ecx, 2
			jnz		petla
			jmp		wyswietl

usun:		add		esi, 4
			sub		ecx, 4
			jnz		petla
			jmp		wyswietl

wyswietl:
			mov		[edi], word ptr 0
			push	0
			push	OFFSET tytul
			push	OFFSET wyjscie
			push	0
			call	_MessageBoxW@16

			push	0
			call	_ExitProcess@4
			


_main ENDP
END