.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy

obsluga_zegara PROC
	push ax
	push bx
	push cx
	push dx
	push es

	cmp cs:czas, 0
	je wypisywanie

czekanie:
	dec	cs:czas
	jmp	koniec_obslugi_zegara

wypisywanie:
	
	mov	cs:czas, 18
	mov	ax, 0B800h
	mov	es, ax

	cmp	cs:licznik_znakow, 10
	jb	dalej_30
	mov	cs:licznik_znakow, 0

dalej_30:
	
	movzx	bx, cs:licznik_znakow
	mov		dl, cs:mapa[bx]
	inc		cs:licznik_znakow

	mov		bx, cs:licznik
	mov		byte PTR es:[bx], dl
	mov		byte PTR es:[bx+1], 00000111B

	add		bx, 2
	cmp		bx, 4000
	jb		wysw_dalej
	mov		bx, 0

wysw_dalej:
	
	mov cs:licznik, bx

	

koniec_obslugi_zegara:
	pop es
	pop dx
	pop cx
	pop bx
	pop ax

	jmp dword PTR cs:wektor8


	licznik dw 0
	wektor8 dd ?
	czas db 0
obsluga_zegara ENDP

obsluga_klawiatury PROC
	push ax
	push bx
	push cx
	push es

	in		al, 60h
	cmp		al, 128
	jb		wcisnieto
	sub		al, 128
	movzx	bx, al
	mov		cs:mapa_wcisnietych[bx], 0
	jmp		sprawdz

wcisnieto:
	movzx	bx, al
	mov		cs:mapa_wcisnietych[bx], 1

sprawdz:
	mov		bx, 128
petla:
	mov		dl, cs:mapa_wcisnietych[bx]
	mov		al, cs:poprawna_mapa_wcisnietych[bx]
	cmp		al, dl
	jne		koniec_obslugi_klawiatury
	dec		bx
	jnz		petla

	mov		cs:czy_wyjsc, 1

koniec_obslugi_klawiatury:	
	pop es
	pop cx
	pop bx
	pop ax

	jmp dword PTR cs:wektor9

	wektor9 dd ?
	mapa db '0123456789'
	licznik_znakow db 0
	mapa_wcisnietych db 128 dup (0)
	poprawna_mapa_wcisnietych db 44 dup (0), 1, 1, 83 dup (0)
	czy_wyjsc db 0
obsluga_klawiatury	ENDP

zacznij:
	mov al, 0
	mov ah, 5
	int 10

	mov ax, 0
	mov ds,ax 
	mov eax,ds:[32]
	mov cs:wektor8, eax

	mov ax, SEG obsluga_zegara
	mov bx, OFFSET obsluga_zegara
	cli
	mov ds:[32], bx
	mov ds:[32+2], ax
	sti

	mov eax,ds:[36]
	mov cs:wektor9, eax

	mov ax, SEG obsluga_klawiatury
	mov bx, OFFSET obsluga_klawiatury
	cli
	mov ds:[36], bx
	mov ds:[36+2], ax
	sti

aktywne_oczekiwanie:
	cmp cs:czy_wyjsc, 1
	jne aktywne_oczekiwanie

	mov eax, cs:wektor8
	cli
	mov ds:[32], eax 
	sti

	mov eax, cs:wektor9
	cli
	mov ds:[36], eax 
	sti

	mov ah,0ch
	mov al,0
	int 21h

	mov al, 0
	mov ah, 4CH
	int 21H
rozkazy ENDS

nasz_stos SEGMENT stack
	db 128 dup (?)
nasz_stos ENDS

END zacznij