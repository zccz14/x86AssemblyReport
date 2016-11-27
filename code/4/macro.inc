clear_screen macro op1,op2,op3,op4
  mov ax,0600h
  mov bh,7h
  mov ch,op1
  mov cl,op2
  mov dh,op3
  mov dl,op4
  int 10h
  set_cursor 0, 0
endm

; ah, bh, dx
set_cursor macro row, column
  mov ah, 02h
  mov bh, 00h
  mov dh, row
  mov dl, column
  int 10h
endm

; ah, dx
PrintString macro string
  mov ah, 09h
  lea dx, string
  int 21h
endm

; putchar at cursor
putchar macro ch
  mov ah, 09h
  mov al, ch
  mov bh, 0
  mov bl, 0fh
  mov cx, 1
  int 10h
endm

putcharColor macro ch, fg
  push bx
  push cx
  mov ah, 9
  mov al, ch
  mov bh, 0
  mov bl, fg
  mov cx, 1
  int 10h
  pop cx
  pop bx
endm


PrintByteDec macro num
  mov ah, 0
  mov al, num
  _PrintDec
endm

PrintWordDec macro num
  mov ax, num
  _PrintDec 
endm

_PrintDec macro
  local L1, L2
  mov dx, 0
  mov bx, 10
  mov cx, 0
  L1:
    div bx
    push dx
    mov dx, 0
    inc cx
    cmp ax, 0
    jne L1
  L2:
    pop ax
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h
    dec cx
    jnz L2
endm
