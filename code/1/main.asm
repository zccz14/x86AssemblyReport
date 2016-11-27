option casemap: none
.model small
.data
hello db 'hello, world$'
.code
main proc far
  mov ax, @data
  mov ds, ax
  mov ah, 09h
  lea dx, hello
  int 21h
  mov ax, 4c00h
  int 21h
  ret
main endp
end main