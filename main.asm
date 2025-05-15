.386
.model flat, stdcall
.stack 4096
includelib kernel32.lib
ExitProcess proto, dwExitCode:dword
GetStdHandle proto, nStdHandle:dword
ReadConsoleA proto, hConsoleInput:dword, lpBuffer:ptr byte, \
                    nNumberOfCharsToRead:dword, lpNumberOfCharsRead:ptr dword, \
                    lpReserved:dword
WriteConsoleA proto, hConsoleOutput:dword, lpBuffer:ptr byte, \
                     nNumberOfCharsToWrite:dword, lpNumberOfCharsWritten:ptr dword, \
                     lpReserved:dword

.data
    four        real4 4.0
    three       real4 3.0
    pi          real4 3.1415926

    prompt      byte "Enter radius of the sphere (0 to exit): ",0
    neg_msg     byte "Radius cannot be negative. Please try again.",13,10,0
    area_msg    byte "Surface Area computed.",13,10,0
    volume_msg  byte "Volume computed.",13,10,0
    newline     byte 13,10,0

    radius      real4 ?
    input_buf   byte 16 dup(?)
    bytes_read  dword ?
    bytes_written dword ?
    hInput      dword ?
    hOutput     dword ?

.code
main proc
    invoke GetStdHandle, -10
    mov hInput, eax
    invoke GetStdHandle, -11
    mov hOutput, eax

input_loop:
    ; Prompt for radius
    invoke WriteConsoleA, hOutput, offset prompt, lengthof prompt - 1, offset bytes_written, 0
    invoke ReadConsoleA, hInput, offset input_buf, lengthof input_buf, offset bytes_read, 0

    ;Simulated float input: use fixed float radius (e.g., 3.0)
    fldpi                   ; just load a fixed value temporarily 
    fstp radius

    fld radius
    fldz
    fcomip st(0), st(1)
    je exit_program

    ftst
    fstsw ax
    sahf
    jb negative_input

    fstp radius

    ; Surface Area = 4 * pi * r^2
    fld radius
    fmul st(0), st(0)       ; r^2
    fld pi
    fmul                   ; pi * r^2
    fld four
    fmul                   ; 4 * pi * r^2
    ; result in ST(0) 
    invoke WriteConsoleA, hOutput, offset area_msg, lengthof area_msg - 1, offset bytes_written, 0

    ; Volume = 4/3 * pi * r^3
    fld radius
    fmul st(0), st(0)
    fmul radius            ; r^3
    fld pi
    fmul                   ; pi * r^3
    fld four
    fdiv three             ; 4/3
    fmul                   ; 4/3 * pi * r^3
    ; result in ST(0)
    invoke WriteConsoleA, hOutput, offset volume_msg, lengthof volume_msg - 1, offset bytes_written, 0

    jmp input_loop

negative_input:
    invoke WriteConsoleA, hOutput, offset neg_msg, lengthof neg_msg - 1, offset bytes_written, 0
    jmp input_loop

exit_program:
    invoke ExitProcess, 0
main endp
end main
