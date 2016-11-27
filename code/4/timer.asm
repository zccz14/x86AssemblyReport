option casemap: none
.model small
.data
Buffer db 4 dup(?)
Format db '00:00:00', '$'
Radix db 10
.code
include macro.inc

public TimerClear
TimerClear proc
  push ax
  push cx
  push dx
  mov ah, 2ch
  int 21h
  mov Buffer[0], ch ; hour
  mov Buffer[1], cl ; minute
  mov Buffer[2], dh ; second
  mov Buffer[3], dl ; (10ms)
  pop dx
  pop cx
  pop ax
  ret
TimerClear endp

; return: CH = hour, CL = minute, DH = second, DL = (10ms)
public TimerPeek
TimerPeek proc
  push ax
  mov ah, 2ch
  int 21h
  sub dl, Buffer[3]; 100
  cmp dl, 0
  jge T1
    dec dh
    add dl, 100
  T1:
  sub dh, Buffer[2]; 60
  cmp dh, 0
  jge T2
    dec cl
    add dh, 60
  T2:
  sub cl, Buffer[1]; 60
  cmp cl, 0
  jge T3
    dec ch
    add cl, 60
  T3:
  sub ch, Buffer[0]; 24
  cmp ch, 0
  jge T4
    add ch, 24
  T4:
  pop ax
  ret
TimerPeek endp
; display HH:MM:SS format String 
; using INT 21H / AH = 09H
public TimerDisplay
TimerDisplay proc
  push ax
  push cx
  push dx
  call TimerPeek
  ; display hour
  mov ah, 0
  mov al, ch
  div Radix
  add ax, 3030h
  mov Format[0], al
  mov Format[1], ah
  ; display minute
  mov ah, 0
  mov al, cl
  div Radix
  add ax, 3030h
  mov Format[3], al
  mov Format[4], ah
  ; display second
  mov ah, 0
  mov al, dh
  div Radix
  add ax, 3030h
  mov Format[6], al
  mov Format[7], ah
  ; print
  PrintString Format
  pop dx
  pop cx
  pop ax
  ret
TimerDisplay endp

end
