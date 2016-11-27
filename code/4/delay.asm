option casemap: none
.model small
.stack 6
.code
; public void delay(times)
; delay times in ms
; stack structure:
; [bp + 4]: times
; [bp + 2]: caller IP
; [bp + 0]: caller BP
public delay
delay proc
  push bp
  mov bp, sp
  push ax
  push cx
  push dx

  mov ax, [bp + 4]
  mov cx, 66 ; 1ms = 66 * 15.085 \mu s
  mul cx
  mov cx, ax
  ; (dx cx) cycles, each 15.085 \mu s
  L1:
    in al, 61h
    and al, 10h
    cmp al, ah
    je L1
    mov ah, al
    loop L1

    cmp dx, 0
    jz EXIT
    dec cx
    dec dx
    jmp L1
  EXIT:
  pop dx
  pop cx
  pop ax
  pop bp
  ret
delay endp
end
