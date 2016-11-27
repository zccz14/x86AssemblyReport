option casemap: none
.model small
.stack 10
.code
extrn delay: near
; public void init()
; init the player
public init
init proc
  mov al, 0B6h
  out 43h, al
  ret
init endp

; public void play(int f, int d)
; stack structure
; [bp + 6]: duration dw (ms)
; [bp + 4]: frequency dw (Hz)
; [bp + 2]: caller IP
; [bp + 0]: caller BP
public play
play proc
  push bp
  mov bp, sp
  ; compute divisor
  mov dx, 0012H
  mov ax, 34DEH
  mov bx, [bp + 4]
  div bx
  ; pass divisor
  out 42h, al
  mov al, ah
  out 42h, al
  ; turn on
  in al, 61h
  mov ah, al
  or al, 11b
  out 61h, al
  ;delay
  push ax
  mov ax, [bp + 6]
  push ax
  call delay
  pop ax
  pop ax
  ; turn off
  mov al, ah
  out 61h, al
  ; exit
  pop bp
  ret
play endp

; public void music(int *music)
; stack structure
; [bp + 4]: music: the address of music
; [bp + 2]: caller IP
; [bp + 0]: caller BP
public music
music proc
  push bp
  mov bp, sp
  mov si, [bp + 4]
  L1S:
    mov ax, [si + 2]
    cmp ax, 0
    jz L1E
    push ax
    mov ax, [si]
    cmp ax, 0
    jnz T1 
      ; if f == 0
      call delay
      add sp, 2
      jmp T2
    T1:
      ; if f > 0
      push ax
      call play
      add sp, 4
    T2:
    add si, 4
    jmp L1S
  L1E:
  pop bp
  ret
music endp
end
