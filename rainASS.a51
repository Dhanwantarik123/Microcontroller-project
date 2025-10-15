ORG 0H          ; Program start

;---------------- LCD Pins ----------------
RS      BIT P3.0
EN      BIT P3.1

;---------------- I/O ----------------
RAIN    BIT P1.0
LED     BIT P1.1

;---------------- Variables ----------------
ORG 30H         ; RAM variables if needed

;---------------- Delay ----------------
DELAY_MS:
    MOV R2, #5       ; Outer loop (adjust for timing)
D1: MOV R1, #250
D2: DJNZ R1, D2
    DJNZ R2, D1
    RET

;---------------- LCD Commands ----------------
LCD_CMD:
    MOV P2, A       ; Put command on data port
    CLR RS
    SETB EN
    ACALL DELAY_MS
    CLR EN
    RET

LCD_DATA:
    MOV P2, A
    SETB RS
    SETB EN
    ACALL DELAY_MS
    CLR EN
    RET

LCD_INIT:
    MOV A, #38H     ; 8-bit, 2 lines, 5x7
    ACALL LCD_CMD
    MOV A, #0C0H    ; Display ON, Cursor OFF
    ACALL LCD_CMD
    MOV A, #06H     ; Auto increment
    ACALL LCD_CMD
    MOV A, #01H     ; Clear display
    ACALL DELAY_MS
    RET

LCD_STRING:           ; Display string pointed by DPTR
    MOVC A, @A+DPTR
    JZ L_END
    ACALL LCD_DATA
    INC DPTR
    SJMP LCD_STRING
L_END:
    RET

;---------------- Main Program ----------------
ORG 100H
START:
    ACALL LCD_INIT
    MOV DPTR, #MSG1
    ACALL LCD_STRING
    ACALL DELAY_MS

MAIN_LOOP:
    ; Move cursor to first line
    MOV A, #80H
    ACALL LCD_CMD

    JB RAIN, NO_RAIN   ; If RAIN=1 ? no rain
    ; Rain detected
    MOV DPTR, #MSG2
    ACALL LCD_STRING
    SETB LED
    SJMP LOOP_END

NO_RAIN:
    MOV DPTR, #MSG3
    ACALL LCD_STRING
    CLR LED

LOOP_END:
    ACALL DELAY_MS
    SJMP MAIN_LOOP

;---------------- Messages ----------------
ORG 200H
MSG1: DB "Rain Sensor", 0
MSG2: DB "Rain Detected   ", 0
MSG3: DB "No Rain Detected", 0

END START
