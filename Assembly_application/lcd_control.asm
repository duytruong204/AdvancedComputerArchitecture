# Setting stack frame using for all functions
 li sp, 0x000007FC # max 0x000007FF 

# Initial main
jal ra, lcd_init
li a0, 'A'
jal ra, lcd_char
li a0, 0xC0
jal ra, lcd_cmd
li a0, 'B'
jal ra, lcd_char
# Loop main
loop:
    j loop


# -----------------------------------------------------
# Function: lcd_init
# Purpose :  LCD Initialize function
# Inputs  : 
# -----------------------------------------------------
lcd_init:    
    # Allocate stack (8 bytes)
    addi sp, sp, -8
    sw a0, 0(sp)
    sw ra, 4(sp)

    li a0, 0x0
    jal ra, lcd_cmd
    li a0, 20             # delay 20ms
    jal ra, delay_ms
    li a0, 0x38
    jal ra, lcd_cmd
    li a0, 0x0C
    jal ra, lcd_cmd
    li a0, 0x06
    jal ra, lcd_cmd
    li a0, 0x01
    jal ra, lcd_cmd
    li a0, 0x80
    jal ra, lcd_cmd

    # Restore registers
    lw a0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret
# -----------------------------------------------------
# Function: lcd_char
# Purpose : Send data to LCD (for characters)
# Inputs  : a0 = data (8-bit)
# -----------------------------------------------------
# Bits Usage
# 31 : ON
# 30 - 11 : (Reserved)
# 10 : EN
# 9 : RS
# 8 : R/W
# 7 - 0: Data
lcd_char:
    # Allocate stack (16 bytes)
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw a0, 8(sp)
    sw ra, 12(sp)

    # --- Step 1: Send with EN = 1 ---
    # ON  = 1 (LCD on)          [31]
    # Resever                   [30:11]
    # EN  = 1 (enable high)     [10]
    # RS  = 1 (data mode)       [9]
    # R/W = 0 (write)           [8]
    # a0 = data (command)       [7:0]
    lui t0, 0x80000          # bit 31 = 1
    ori t0, t0, 0x0600       # 110 0000 0000
    or  t0, t0, a0           # insert data bits 7:0
    li  t1, 0x10004000       # Addr of LCD
    sw  t0, 0(t1)            # write to LCD

    li a0, 1             # delay 1ms
    jal ra, delay_ms

    # --- Step 2: Send with EN = 0 ---
    # ON  = 1 (LCD on)          [31]
    # Resever                   [30:11]
    # EN  = 0 (enable low)      [10]
    # RS  = 1 (data mode)       [9]
    # R/W = 0 (write)           [8]
    # a0 = data (command)       [7:0]

    lw a0, 8(sp)
    lui t0, 0x80000          # bit 31 = 1
    ori t0, t0, 0x0200       # 010 0000 0000
    or  t0, t0, a0           # insert data bits 7:0
    li  t1, 0x10004000       # Addr of LCD
    sw  t0, 0(t1)            # write to LCD

    li a0, 5             # delay 5ms
    jal ra, delay_ms

     # Restore registers
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw a0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    ret

# -----------------------------------------------------
# Function: lcd_cmd
# Purpose : Send command to LCD
# Inputs  : a0 = command (8-bit)
# -----------------------------------------------------
# Bits Usage
# 31 : ON
# 30 - 11 : (Reserved)
# 10 : EN
# 9 : RS
# 8 : R/W
# 7 - 0: Data

# List command
# Sr |  Hex-Code |  Command to LCD instruction Register
# 1	    01	        Clear display screen
# 2	    02	        Return home
# 3	    04	        Decrement cursor (shift cursor to left)
# 4	    06	        Increment cursor (shift cursor to right)
# 5	    05	        Shift display right
# 6	    07	        Shift display left
# 7 	08	        Display off, cursor off
# 8	    0A	        Display off, cursor on
# 9	    0C	        Display on, cursor off
# 10	0E	        Display on, cursor blinking
# 11	0F	        Display on, cursor blinking
# 12	10	        Shift cursor position to left
# 13	14	        Shift the cursor position to the right
# 14	18	        Shift the entire display to the left
# 15	1C	        Shift the entire display to the right
# 16	80	        Force cursor to the beginning ( 1st line)
# 17	C0	        Force cursor to the beginning ( 2nd line)

lcd_cmd:
    # Allocate stack (16 bytes)
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw a0, 8(sp)
    sw ra, 12(sp)

    # --- Step 1: Send with EN = 1 ---
    # ON  = 1 (LCD on)          [31]
    # Resever                   [30:11]
    # EN  = 1 (enable high)     [10]
    # RS  = 0 (command mode)    [9]
    # R/W = 0 (write)           [8]
    # a0 = data (command)       [7:0]

    lui t0, 0x80000          # bit 31 = 1
    ori t0, t0, 0x0400       # 100 0000 0000
    or  t0, t0, a0           # insert data bits 7:0
    li  t1, 0x10004000       # Addr of LCD
    sw  t0, 0(t1)             # write to LCD

    li a0, 1                 # delay 1ms
    jal ra, delay_ms

    # --- Step 2: Send with EN = 0 ---
    # ON  = 1 (LCD on)          [31]
    # Resever                   [30:11]
    # EN  = 0 (enable low)      [10]
    # RS  = 0 (command mode)    [9]
    # R/W = 0 (write)           [8]
    # a0 = data (command)       [7:0]
    lw a0, 8(sp)
    lui t0, 0x80000          # bit 31 = 1
    ori t0, t0, 0x0000        # 000 0000 0000
    or  t0, t0, a0           # insert data bits 7:0
    li  t1, 0x10004000       # Addr of LCD
    sw  t0, 0(t1)            # write to LCD

    li a0, 5                 # delay 5ms
    jal ra, delay_ms

     # Restore registers
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw a0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    ret

# -----------------------------------------------------
# Function: delay_ms(a0)
# Purpose : delay
# Inputs  : a0 = ms
# -----------------------------------------------------
delay_ms:
    # Allocate stack (16 bytes)
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw ra, 12(sp)

    li t0, 0
    li t1, 25000
    li t2, 0
delay_ms_loop:
    addi t0, t0, 1
    blt t0, t1, delay_ms_loop

    li t0, 0
    addi t2, t2, 1
    blt t2, a0, delay_ms_loop

    # Restore registers
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    ret
# -----------------------------------------------------
# Function: delay_us(a0)
# Purpose : delay
# Inputs  : a0 = us
# -----------------------------------------------------
delay_us:
    # Allocate stack (16 bytes)
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw ra, 12(sp)

    li t0, 0
    li t1, 25
    li t2, 0
delay_us_loop:
    addi t0, t0, 1
    blt t0, t1, delay_us_loop

    li t0, 0
    addi t2, t2, 1
    blt t2, a0, delay_us_loop

    # Restore registers
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    ret
