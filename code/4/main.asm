option casemap: none
.model small

.data
PROMPT1 DB 'SCORE:$'
PROMPT2 DB 'TIME:$'

public score
score dw 0
.stack 200H

.code
include macro.inc
extrn TimerClear: near
extrn TimerPeek: near
extrn TimerDisplay: near
extrn PlayerController: near
extrn PlayerDisplay: near
extrn TargetDisplay: near
placeTarget proc
placeTarget endp

main proc far
  mov ax, @data
  mov ds, ax
  ; init
  clear_screen 1, 1, 23, 78
  ; 80 * 25 16 colors text video mode
  mov ah, 0
  mov al, 03h
  int 10h
  ; hide cursor
  mov cx, 0100h
  mov ah, 1
  int 10h
  call TargetDisplay
  call TimerClear
  mainloop:
    ; display score
    set_cursor 2, 2
    PrintString PROMPT1
    PrintWordDec score
    ; display time
    set_cursor 2, 66
    PrintString PROMPT2
    call TimerDisplay
    ; display player
    call PlayerDisplay
    ; call player
    call PlayerController
    jmp mainloop
  ret
main endp
end main
