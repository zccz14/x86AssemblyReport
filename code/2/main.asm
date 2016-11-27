option casemap: none
.model small
.data
a dw 100
n dw 7
.code
main proc far
  mov ax, @data
  mov ds, ax

  mov dx, 0
  mov ax, a
  div n

  mov dx, 0
  mov bx, ax
  mov ax, n
  mul bx
  inc bx
  mul bx
  ; unsigned divide 32-bit result by 2
  shr dx, 1
  rcr ax, 1

  mov ax, 4c00h
  int 21h
  ret
main endp
end main
