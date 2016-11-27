option casemap: none
.model small
.data
public target
target db 'V'
targetCnt dw 7
targets db 5, 20, 1
        db 5, 22, 2
        db 5, 24, 3
        db 5, 26, 4
        db 6, 32, 5
        db 6, 20, 6
        db 6, 21, 7
.code
include macro.inc

public TargetDisplay
TargetDisplay proc
  lea si, targets
  mov cx, targetCnt
  L1:
    push cx
    mov dh, [si + 0]
    mov dl, [si + 1]
    set_cursor dh, dl
    mov al, target
    mov bl, [si + 2]
    mov bh, 0
    mov cx, 1
    mov ah, 9
    int 10h
    pop cx
    add si, 3
    dec cx
    jnz L1
  ret
TargetDisplay endp
end
