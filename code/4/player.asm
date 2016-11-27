option casemap: none
.model small
.data
row db 22
col db 15
t dw 100
show db 'A'
bullet db 1eh
extrn target: byte
extrn score: word
.code
include macro.inc

public PlayerController
PlayerController proc
  ; keyboard
  mov ah, 06h  ; direct console input [or output]
  mov dl, 0ffh ; for input
  int 21h
  ; input router
  cmp al, 'e' ; e for exit
  je InputE
  cmp al, ' ' ; space for shoot (disappear)
  je InputSpace
  cmp al, 4bh ; (left)
  je InputLeft
  cmp al, 4dh ; (right)
  je InputRight
  ret
  ; routines
  InputE:
    mov ax, 4c00h
    int 21h
    ret
  InputLeft:
    set_cursor row, col
    putchar ' '
    dec col
    ret
  InputRight:
    set_cursor row, col
    putchar ' '
    inc col
    ret
  InputSpace:
    call shoot
    ret
PlayerController endp

public PlayerDisplay
PlayerDisplay proc
  set_cursor row, col
  putchar show
  ret
PlayerDisplay endp

extrn delay: near
shoot proc
  ; generate bullet at (row - 1, col)
  mov dh, row
  mov dl, col
  dec dh
  set_cursor dh, dl
  putchar bullet
  ; let it fly
  ; do while
  flyingS:
    cmp dh, 0
    jl flyingE ; out of range

    
    set_cursor dh, dl
    putchar ' '; clean old
    dec dh
    ; read @bullet judge
    set_cursor dh, dl
    mov ah, 08h
    mov bh, 00h
    int 10h
    cmp al, target
    jnz notHit
      inc score
      putchar ' '
      ret
    notHit:
      
      cmp dh, 0
      jz flyingT1
        set_cursor dh, dl
        putchar bullet
        push t
        call delay
        pop t
      flyingT1:
    jmp flyingS
  flyingE:
  ret
shoot endp

end
