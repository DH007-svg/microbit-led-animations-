.syntax unified
.thumb
.global main

.extern init_leds
.extern write_row_pins
.extern write_column_pins
.extern delay

.equ BTN_CNF_PULLUP,  0x0000000C
.equ BTN_A_CNF,       0x50000738
.equ BTN_B_CNF,       0x5000075C
.equ GPIO_IN_ADR,     0x50000510
.equ BTN_A_BIT,       14
.equ BTN_B_BIT,       23

.equ DEBOUNCE,        300000

.section .rodata
.align 2

patterns:
@ 4 frames per pattern (20 bytes each)

@ Pattern 0: Expanding Square
.byte 0b00000,0b00000,0b00100,0b00000,0b00000
.byte 0b00000,0b01110,0b01010,0b01110,0b00000
.byte 0b11111,0b10001,0b10001,0b10001,0b11111
.byte 0b00000,0b01110,0b01010,0b01110,0b00000

@ Pattern 1: Horizontal Scanning Line
.byte 0b11111,0b00000,0b00000,0b00000,0b00000
.byte 0b00000,0b11111,0b00000,0b00000,0b00000
.byte 0b00000,0b00000,0b00000,0b11111,0b00000
.byte 0b00000,0b00000,0b00000,0b00000,0b11111

@ Pattern 2: Spinning Line
.byte 0b00100,0b00100,0b00100,0b00100,0b00100
.byte 0b10000,0b01000,0b00100,0b00010,0b00001
.byte 0b00000,0b00000,0b11111,0b00000,0b00000
.byte 0b00001,0b00010,0b00100,0b01000,0b10000

@ Pattern 3: Heart Beating
.byte 0b00000,0b01010,0b11111,0b01110,0b00100
.byte 0b00000,0b00000,0b01010,0b00100,0b00000
.byte 0b00000,0b01010,0b11111,0b01110,0b00100
.byte 0b01010,0b11111,0b11111,0b01110,0b00100

@ Pattern 4: Raindrop Falling
.byte 0b00100,0b00000,0b00000,0b00000,0b00000
.byte 0b00000,0b00100,0b00000,0b00000,0b00000
.byte 0b00000,0b00000,0b00100,0b00000,0b00000
.byte 0b00000,0b00000,0b00000,0b00100,0b00000

.align 2

.section .text
.align 2

main:
    PUSH {r4, r5, r6, r7, lr}

    BL init_leds

    LDR r0, =BTN_A_CNF
    LDR r1, =BTN_CNF_PULLUP
    STR r1, [r0]

    LDR r0, =BTN_B_CNF
    STR r1, [r0]

    MOVS r4, #0   @ pattern
    MOVS r5, #0   @ prev buttons
    MOVS r6, #0   @ frame

loop:
    @ pass BOTH pattern + frame
    MOV r0, r4
    MOV r1, r6
    BL draw_pattern

    LDR r0, =60000
    BL delay

    @ next frame
    ADDS r6, r6, #1
    ANDS r6, r6, #3

    BL read_buttons
    MOV r7, r0   @ snapshot (FIX)

    @ ---- Button A ----
    MOV r1, r5
    ANDS r1, #1
    BNE chk_b

    MOV r2, r7
    ANDS r2, #1
    BEQ chk_b

    CMP r4, #0
    BEQ chk_b

    SUBS r4, r4, #1
    MOVS r6, #0

chk_b:
    @ ---- Button B ----
    MOV r1, r5
    ANDS r1, #2
    BNE save

    MOV r2, r7
    ANDS r2, #2
    BEQ save

    CMP r4, #4
    BEQ save

    ADDS r4, r4, #1
    MOVS r6, #0

save:
    MOV r5, r7   @ store correct state
    B loop


@ ── FIXED draw_pattern ──
@ r0 = pattern index
@ r1 = frame index
draw_pattern:
    PUSH {r4-r7, lr}

    MOV r4, r0      @ pattern
    MOV r7, r1      @ frame (SAFE STORAGE)

    @ index * 20
    MOV r5, r4
    LSLS r4, r5, #2
    ADDS r4, r4, r5
    LSLS r4, r4, #2

    @ frame * 5
    LSLS r3, r7, #2
    ADDS r3, r3, r7

    ADDS r4, r4, r3

    LDR r5, =patterns
    ADDS r4, r4, r5

    MOVS r5, #0

row_loop:
    LDRB r6, [r4, r5]

    MVNS r0, r6
    ANDS r0, #0x1F
    BL write_column_pins

    MOVS r0, #1
    LSLS r0, r0, r5
    BL write_row_pins

    LDR r0, =2000
    BL delay

    MOVS r0, #0
    BL write_row_pins

    ADDS r5, r5, #1
    CMP r5, #5
    BLT row_loop

    POP {r4-r7, pc}


read_buttons:
    PUSH {r1, r2, r4, lr}

    LDR r1, =GPIO_IN_ADR
    LDR r2, [r1]
    MOVS r4, #0

    LDR r1, =(1<<BTN_A_BIT)
    TST r2, r1
    BNE skipA
    ORRS r4, #1
skipA:

    LDR r1, =(1<<BTN_B_BIT)
    TST r2, r1
    BNE skipB
    ORRS r4, #2
skipB:

    LDR r0, =DEBOUNCE
    BL delay

    MOV r0, r4
    POP {r1, r2, r4, pc}