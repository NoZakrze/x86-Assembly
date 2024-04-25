.686
.model flat

public _main
extern _ExitProcess@4 : proc
extern _MessageBoxW@16 : proc

.data
tekst	dw 't','y','t','u','l',0
tytul	db 'a','l','a',0
		db 'Ala',0

bufor       db    50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H
            db    0F0H, 9FH, 9AH, 82H   ; parowóz
			db    20H, 20H, 6BH, 6FH, 6CH, 65H, 6AH, 6FH, 77H, 6FH, 20H
			db    0E2H, 80H, 93H ; pó³pauza
			db    20H, 61H, 75H, 74H, 6FH, 62H, 75H, 73H, 6FH, 77H, 65H, 20H, 20H
            db    0F0H,  9FH,  9AH,  8CH ; autobus

wynik	    dw    48 dup (0)
			db    50h,0,6fh,0,42h,1h
			dw	  50h,6fh,142h
			
.code
_main PROC
			mov		ecx, OFFSET wynik - OFFSET bufor				; obliczenie liczby znaków w buforze
			mov		edi, 0											; wyzerowanie indeksów 
			mov		esi, 0
ptl:
			mov		al, bufor[esi]									; odczyt pierwszego bajtu znaku utf-8
			add		esi,1											; przesuniêcie indeksu odcztu
			cmp		al,7fh											; sprawdzenie ile bajtów zajmuje znak utf-8
			ja		znak_utf8_wielobajtowy

			; znak 1 bajtowy
			mov		ah, 0											; ax - znak utf-16
			mov		wynik[edi], ax									; zapis wyniku
			add		edi, 2											; modyfikacja indeksu zapisu
			jmp		koniec

znak_utf8_wielobajtowy:
			
			cmp		al, 0E0H
			jb		dwubajtowy
			cmp		al, 0F0H
			jb		trzybajtowy
			jmp		czterobajtowy


dwubajtowy:
			
			;110xxxxx 10xxxxxx
			mov		ah, bufor[esi]
			inc		esi
			xchg	al, ah						; ax = 110xxxxx 10xxxxxx
			shl		al, 2						; ax = 110xxxxx xxxxxx00
			shl		ax, 3						; ax = xxxxxxxx xxx00000	
			shr		ax, 5						; ax = 0000 0xxx xxxx xxxx znak w utf 16

			mov		wynik[edi], ax
			add		edi, 2

			jmp		koniec
trzybajtowy:
			;1110xxxx 10xxxxxx 10xxxxxx 
			movzx	eax, al
			shl		eax, 16
			mov		al,  bufor[esi+1]
			mov		ah, bufor[esi]
			add		esi, 2

			;00000000 1110xxxx 10xxxxxx 10xxxxxx eax
			shl		al, 2						;00000000 1110xxxx 10xxxxxx xxxxxx00 eax
			shl		ax, 2						;00000000 1110xxxx xxxxxxxx xxxx0000 eax
			shr		eax, 4						;00000000 00001110 xxxxxxxx xxxxxxxx eax

			mov		wynik[edi], ax
			add		edi, 2

			jmp		koniec
czterobajtowy:
			;11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
			mov		ah, bufor[esi]
			inc		esi
			xchg	al, ah
			shl		al, 2						;11110xxx xxxxxx00
			shl		ax, 5						;xxxxxxxx x0000000
			shr		ax, 7						;0000000x xxxxxxxx
			shl		eax, 16						;0000000x xxxxxxxx 0000000 00000000
			mov		ah, bufor[esi]
			mov		al, bufor[esi+1]			;0000000x xxxxxxxx 10xxxxxx 10xxxxxx
			add		esi, 2
			shl		al, 2						;0000000x xxxxxxxx 10xxxxxx xxxxxx00
			shl		ax, 2						;0000000x xxxxxxxx xxxxxxxx xxxx0000
			shr		eax, 4						;00000000 000xxxxx xxxxxxxx xxxxxxxx  U+

			push	ecx
			sub		eax, 10000H
			mov		ebx, eax
			shr		eax, 10						;w ax starsze 10 bitow
			mov		cx, 110110b
			shl		cx, 10
			or		cx, ax
			mov		wynik[edi], cx
			add		edi, 2
			and		bx, 03ffH
			add		bx, 0DC00H
			mov		wynik[edi], bx
			add		edi, 2
			pop		ecx
			;110110xxxxxxxxxx 110111yyyyyyyyy


koniec:
	dec		ecx
	jnz		ptl
	;mov ebx,offset wynik
	;mov [ebx+esi],al
	;mov [ebx+esi],ax

	push 4															; kod przycisków
	push OFFSET tekst
	Push OFFSET wynik
	pUSH 0															; uchwyt okna
	call  _MessageBoxW@16

	push 0
	call _ExitProcess@4

_main ENDP
END
