.386
rozkazy SEGMENT use16
    ASSUME cs:rozkazy

linia PROC

    push ax
    push bx
    push cx
    push di
    push es

    mov ax, 0A000H
    mov es, ax

    mov ax, cs:current_y
    mov cx, 320
    mul cx
    mov bx, ax
    mov cx, ax
    add bx, cs:current_x

    mov al, cs:kolor
    mov es:[bx], al
    mov di, 320
    sub di, cs:current_x
    add cx, di

    xchg cx, bx
    mov es:[bx], al
    xchg cx, bx

    mov cx, cs:D
    cmp cx, 0
    jle niedodawac
    inc word ptr cs:current_y
    sub cx, 640
niedodawac:
    inc word ptr cs:current_x
    add cx, 400
    mov cs:D, cx

    cmp bx, 320*200
    jb dalej
    
    mov bx, 0
    inc byte ptr cs:kolor
    mov cs:current_x, 0
    mov cs:current_y, 0
    mov cs:D, 80

dalej:
    mov cs:adres_piksela, bx
    pop es
    pop di
    pop cx
    pop bx
    pop ax

    jmp dword PTR cs:wektor8

; zmienne
kolor            db 5
D                dw 80
current_y        dw 0
current_x        dw 0
adres_piksela    dw 0
wektor8          dd ?

linia ENDP

; int 10h - funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
    mov ah, 0
    mov al, 13h
    int 10h
    mov bx, 0
    mov es, bx
    mov eax, es:[32]
    mov cs:wektor8, eax

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

    mov ah, 0
    mov al, 3h
    int 10h
    mov eax, cs:wektor8
    mov es:[32], eax

    mov ax, 4C00h
    int 21h
rozkazy ENDS

stosik  SEGMENT stack
    db 256 dup (?)
stosik ENDS
END zacznij