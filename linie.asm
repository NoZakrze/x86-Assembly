.386
rozkazy			SEGMENT use16
		ASSUME			cs:rozkazy

linia PROC
	
		push	ax
		push	bx
		push	es

		mov		ax, 0A000H	;pamiec ekranu dla trybu 13H
		mov		es, ax

		mov		bx, cs:adres_piksela
		mov		al, cs:kolor
		mov		es:[bx], al

		add		bx, 320

		cmp		bx, 320*200
		jb		dalej
		add		word PTR cs:przyrost, 10
		mov		bx, 10
		add		bx, cs:przyrost
		inc		cs:kolor
dalej:
		mov		cs:adres_piksela, bx

		pop		es
		pop		bx
		pop		ax

		jmp		dword PTR cs:wektor8

	kolor			db 1
	adres_piksela	dw 10
	przyrost		dw 0
	wektor8			dd ?

linia ENDP

zacznij:
		mov		ah, 0
		mov		al, 13H
		int		10H

		mov		bx, 0
		mov		es, bx
		mov		eax, es:[32]
		mov		cs:wektor8, eax

		mov ax, SEG linia
		mov bx, OFFSET linia

		cli
		mov es:[32], bx
		mov es:[32+2], ax
		sti

czekaj:
		mov ah, 1 
		int 16h 
		jz czekaj

		mov	ah, 0
		mov	al, 3H
		int 10H

		mov eax, cs:wektor8
		mov es:[32], eax
		mov ax, 4C00H
		int 21H
rozkazy ENDS

stosik SEGMENT stack
		db 256 dup (?)
stosik ENDS
END zacznij
