.386
rozkazy SEGMENT use16
		ASSUME	CS:rozkazy

obsluga_klawiatury PROC

			in		al, 60H

			call	wyswietl_Al

			jmp		dword PTR cs:wektor9

		wektor9		dd ?
obsluga_klawiatury ENDP


wyswietl_Al	PROC
			
			push	ax
			push	cx
			push	dx

			mov		cx, 0B800h
			mov		es, cx	
			xor		cx, cx

			mov		cl, 10		;dzielnik
			mov		ah, 0		;zerowanie starszej czesci dzielnej
			
			div		cl
			add		ah, 30H
			mov		es:[bx+4], ah
			mov		ah, 0
			div		cl
			add		ah, 30H
			mov		es:[bx+2], ah
			add		al, 30H
			mov		es:[bx+0], al

			mov		al, 00001111B
			mov		es:[bx+1], al
			mov		es:[bx+3], al
			mov		es:[bx+5], al

			pop		dx
			pop		cx
			pop		ax
			ret

wyswietl_Al	ENDP



;GLOWNY PROGRAM

zacznij:	
			mov		al, 0
			mov		ah, 5
			int		10

			mov		ax, 0
			mov		ds, ax							;zerowanie rejestru DS

			mov		eax,ds:[36]
			mov		cs:wektor9, eax

			mov		ax, SEG obsluga_klawiatury
			mov		bx, OFFSET obsluga_klawiatury

			cli

			mov		ds:[36], bx
			mov		ds:[38], ax

			sti
aktywne_oczekiwanie:
			mov		ah, 1
			int		16H								;ustawia ZF=1 jesli nacisnieto klawisz
			jz		aktywne_oczekiwanie
			
			mov		ah, 0
			int 	16H
			cmp		al, 'x'
			jne		aktywne_oczekiwanie

			mov		eax, cs:wektor9
			cli
			mov		ds:[36], eax
			sti

			mov		al, 0
			mov		ah, 4Ch
			int     21H
rozkazy ENDS

nasz_stos		SEGMENT stack
	db			128 dup (?)
nasz_stos		ENDS

END zacznij