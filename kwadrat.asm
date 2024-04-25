.386
rozkazy SEGMENT use16
	ASSUME cs:rozkazy

obsluga_klawiatury PROC
push	ax
		push	cx
		push	dx
		in		al, 60h

		cmp		al, 77
		jne		dalej1
		mov		cs:kierunek, 0
		jmp		koniec_klaw
dalej1:
		cmp		al, 80
		jne		dalej2
		mov		cs:kierunek, 1
		jmp		koniec_klaw
dalej2:
		cmp		al, 75
		jne		dalej3
		mov		cs:kierunek, 2
		jmp		koniec_klaw
dalej3:
		cmp		al, 72
		jne		koniec_klaw
		mov		cs:kierunek, 3
koniec_klaw:
		pop dx
		pop cx
		pop ax
		jmp dword PTR cs:wektor9

kierunek db 3
wektor9 dd ?

obsluga_klawiatury ENDP

linia PROC
	push ax
    push bx
    push cx
    push dx
    push di
	push si
    push es


	dec		cs:czas
	cmp		cs:czas, 0
	jne		bez_zmian
	mov		cs:czas, 18
	cmp		cs:cykl, 0
	jne		dalej11
	mov		cs:cykl, 1
	mov		cs:kolor, 2
	jmp		bez_zmian
dalej11:
	cmp		cs:cykl, 1
	jne		dalej12
	mov		cs:cykl, 2
	mov		cs:kolor, 1
	jmp		bez_zmian
dalej12:
	mov		cs:cykl, 0
	mov		cs:kolor, 4

bez_zmian:
	

	mov		ax, cs:obecny
	cmp		cs:pozycja, 3		;gora lewo
		jne		idz1
		cmp		cs:kierunek, 0	;gora->prawo
		jne		idz12
		mov		dx, 160
		mov		ax, 0A000h
		add		ax, dx
		mov		cs:pozycja, 0
		jmp		kwadrat
	idz12:
		cmp		kierunek, 1		;gora->dol
		jne		kwadrat
		mov		dx, 32000
		mov		ax, 0A000h
		add		ax, dx
		mov		cs:pozycja, 2
		jmp		kwadrat
	idz1:
	cmp		cs:pozycja, 2		;lewo dol
		jne		idz2
		cmp		cs:kierunek, 0	;lewo dol->prawo dol
		jne		idz22
		mov		dx, 32160
		mov		ax, 0A000h
		add		ax, dx
		mov		cs:pozycja, 1
		jmp		kwadrat
	idz22:
		cmp		kierunek, 3		;lewo dol -> lewo gora
		jne		kwadrat
		mov		ax, 0A000h
		mov		cs:pozycja, 3
		jmp		kwadrat
	idz2:
	cmp		cs:pozycja, 1		;dol prawo
		jne		idz3
		cmp		cs:kierunek, 3	; dol prawo gora prawo
		jne		idz32
		mov		dx, 160
		mov		ax, 0A000h
		add		ax, dx
		mov		cs:pozycja, 0
		jmp		kwadrat
	idz32:
		cmp		kierunek, 2		;dol prawo ->dol lewo
		jne		kwadrat
		mov		dx, 32000
		mov		ax, 0A000h
		add		ax, dx
		mov		cs:pozycja, 2
		jmp		kwadrat
	idz3:
	cmp		cs:pozycja, 0		;gora prawo
		jne		kwadrat
		cmp		cs:kierunek, 1	; gora prawo dol prawo
		jne		idz42
		mov		dx, 32160
		mov		ax, 0A000h
		add		ax, dx
		mov		cs:pozycja, 1
		jmp		kwadrat
		idz42:
		cmp		cs:kierunek, 2	; gora prawo gora lewo
		jne		kwadrat
		mov		ax, 0A000h
		mov		cs:pozycja, 3

	
	mov		cs:obecny, ax
kwadrat:
	mov		es, ax
	mov		al, cs:kolor
	mov		bx, 0			;x
	mov		cx, cs:wielkosc
	mov		si, cs:szerokosc

petla_kwadrat_1:
		
petla_kwadratu_2:
		mov		al, cs:kolor
		mov		es:[bx], al
		inc		bx
		dec		si
		jnz		petla_kwadratu_2
		sub		bx, cs:szerokosc
		add		bx, cs:dlugosc_linii
		mov		si, cs:szerokosc
		dec		cx
		jnz		petla_kwadrat_1
		
    pop es
	pop	si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax

    jmp dword PTR cs:wektor8

kolor       db 4
migajacy_kolor  db 14
czarny_kolor    db 0
dlugosc_linii    dw 320
licznik     dw 5
r_licznik   dw 36
wielkosc    dw 100
szerokosc	dw 160
wektor8     dd ?
cykl		dw 0
czas		db 18
pozycja		db 3
obecny		dw 0A000h
zmiana		dw 0

linia ENDP

zacznij:

	mov		ah,0
	mov		al, 13h
	int		10h
	mov		bx, 0
	mov		es, bx
	mov		eax, es:[32]
	mov		cs:wektor8, eax

	mov		ax, SEG linia
	mov		bx, OFFSET linia
	cli
	mov		es:[32], bx
	mov		es:[34], ax
	sti

	mov		eax, es:[36]
	mov		cs:wektor9, eax

	mov ax, SEG obsluga_klawiatury 
    mov bx, OFFSET obsluga_klawiatury

	cli 
    mov es:[36], bx 
    mov es:[38], ax
    sti 

czekaj:
	mov		ah, 1
	int		16h
	jz		czekaj
	mov		ah, 0
	int		16h
	cmp		al, 'x'
	jne		czekaj

	mov		ah, 0
	mov		al, 3
	int		10h
	mov		eax, cs:wektor8
	cli
	mov es:[32], eax
    sti
	mov eax, cs:wektor9
    cli
    mov es:[36], eax
    sti

	mov ax, 4C00h
    int 21h
rozkazy ENDS

stosik  SEGMENT stack
    db 256 dup (?)
stosik ENDS
END zacznij

