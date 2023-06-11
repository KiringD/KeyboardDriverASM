Assume CS: Code, DS: Code
Code Segment
    org 100h
    

key_count db 0 ; Counter for key presses

frequency equ 3000
number_cycles equ 1
key_press_period equ 7 ; Play tone on every 7th key press

port_b equ 61h
    .286

Start proc near
    mov ax,cs
    mov ds,ax

main_loop: call kbin
    cmp al,'q'
    jz exit
  
    inc key_count
    cmp key_count, key_press_period
    jnz main_loop
    call ton1
    call delay
    call ton1
    mov key_count, 0 ; Counter for key presses
    jmp main_loop
exit:
    mov ah,4ch
    int 21h

start endp
ton1 proc near
    mov dx, number_cycles
    mov di, frequency
ton0 proc near
    cli
    in al, port_b
    and al,11111110b
ton01: or al,00000010b
    out port_b, al
    mov cx,di
    loop $
    and al,11111101b
    out port_b, al
    mov cx,di
    loop $
    dec dx
    jnz ton01
    sti
    ret
ton0 endp
ton1 endp
delay proc
  push cx
  push dx

  mov cx, 100
delay1:
  mov dx, 934h
delay2:
  dec dx
  jnz delay2
  loop delay1

  pop dx
  pop cx
  ret
delay endp
kbin proc near
    mov ah,1
    int 21h
    ret
kbin endp
code ends
    END Start
