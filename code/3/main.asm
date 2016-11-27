option casemap: none
.model small
.stack 200H
.data
welcome db '    PIANO    ', 13, 10
        db ' 2 3   5 6 7 ', 13, 10
        db 'q w e r t y u', 13, 10
        db ' s d   g h j ', 13, 10
        db 'z x c v b n m', 13, 10
        db 'Press ESC to exit$'

well dw 262, 1000
     dw 0, 500
     dw 262, 1000
     dw 0, 500
     dw 294, 2000
     dw 0, 500
     dw 262, 2000
     dw 0, 500
     dw 349, 2000
     dw 0, 500
     dw 330, 4000
     dw 0, 500
     dw 0, 0

keyno db 'zsxdcvgbhnjmq2w3er5t6y7u'
fre   dw 220, 233, 246, 261, 277, 293, 311, 329, 349, 369, 391, 415 
      dw 440, 466, 493, 523, 554, 587, 622, 659, 698, 739, 783, 830

.code
extrn delay: near
extrn init: near
extrn play: near
extrn music: near

main proc far
  mov ax, @data
  mov ds, ax
  mov es, ax
  ; display welcome
  mov ah, 09h
  lea dx, welcome
  int 21h
  ; init
  call init
  ; well
  lea dx, well
  push dx
  call music
  pop dx
  ; keyboard
  L1S:
    mov ah, 00h
    int 16h
    cmp ah, 01h
    jz L1E
    lea di, keyno
    mov cx, lengthof keyno
    cld
    repne scasb
    jnz L1S
    mov ax, 1000
    push ax
    lea si, fre
    mov bx, lengthof keyno - 1
    sub bx, cx
    shl bx, 1
    mov ax, [si + bx]
    push ax
    call play
    add sp, 4
    jmp L1S
  L1E:
  mov ax, 4c00h
  int 21h
  ret
main endp
end main
