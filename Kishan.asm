INCLUDE Irvine32.inc

.DATA
    radius  REAL8 ?
    str1    BYTE "Please enter the radius of the sphere (0 to exit): ", 0
    str2    BYTE "Surface Area: ", 0
    str3    BYTE "Volume: ", 0
    
    pi      REAL8 3.14159265358979323846
    four    REAL8 4.0
    third   REAL8 0.3333333333333333
    area    REAL8 ?
    volume  REAL8 ?

.CODE
main PROC
    call Clrscr
    finit

start:
    mov edx, OFFSET str1
    call WriteString
    call ReadFloat
    fstp radius

    fld radius
    fldz
    fcomip st(0), st(1)
    fstp st(0)
    je quit_program

    fld radius
    fldz
    fcomip st(0), st(1)
    fstp st(0)

    fld four
    fld pi
    fmul
    fld radius
    fmul
    fld radius
    fmul
    fstp area

    fld four
    fld third
    fmul
    fld pi
    fmul
    fld radius
    fmul
    fld radius
    fmul
    fld radius
    fmul
    fstp volume

    mov edx, OFFSET str2
    call WriteString
    fld area
    call WriteFloat
    call crlf

    mov edx, OFFSET str3
    call WriteString
    fld volume
    call WriteFloat
    call crlf

    jmp start

quit_program:
    invoke ExitProcess, 0

main ENDP
END main