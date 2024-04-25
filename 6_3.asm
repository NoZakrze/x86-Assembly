.386
rozkazy SEGMENT use16
		ASSUME	CS:rozkazy

obsluga_zegara PROC
		
			push	ax
			push	bx
			push	cx
			push	es

			mov		ax, 0B800h
			mov		es, ax							;adres pamieci ekranu
		
			mov		bx, cs:licznik

			mov		byte PTR es:[bx], '*'
			mov		byte PTR es:[bx+1] , 00000111B	;kolor
			add		bx, 160
			cmp		bx, 4000						;zakres pamieci ekranu
			jb		wysw_dalej
			add		cs:bok, 2
			mov		bx, cs:bok
wysw_dalej:
			mov		cs:licznik, bx

			pop		es
			pop		cx
			pop		bx
			pop		ax

			jmp		dword PTR cs:wektor8

		licznik		dw 320
		wektor8		dd ?
		bok			dw 0
obsluga_zegara ENDP

;GLOWNY PROGRAM

zacznij:	
			mov		al, 0
			mov		ah, 5
			int		10

			mov		ax, 0
			mov		ds, ax							;zerowanie rejestru DS

			mov		eax,ds:[32]
			mov		cs:wektor8, eax

			mov		ax, SEG obsluga_zegara
			mov		bx, OFFSET obsluga_zegara

			cli

			mov		ds:[32], bx
			mov		ds:[34], ax

			sti
aktywne_oczekiwanie:
			mov		ah, 1
			int		16H								;ustawia ZF=1 jesli nacisnieto klawisz
			jz		aktywne_oczekiwanie
			
			mov		ah, 0
			int 	16H
			cmp		al, 'x'
			jne		aktywne_oczekiwanie

			mov		eax, cs:wektor8
			cli
			mov		ds:[32], eax
			sti

			mov		al, 0
			mov		ah, 4Ch
			int     21H
rozkazy ENDS

nasz_stos		SEGMENT stack
	db			128 dup (?)
nasz_stos		ENDS

END zacznij