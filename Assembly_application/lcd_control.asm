# List command
# Sr.No.	Hex Code	Command to LCD instruction Register
# 1	    01	Clear display screen
# 2	    02	Return home
# 3	    04	Decrement cursor (shift cursor to left)
# 4	    06	Increment cursor (shift cursor to right)
# 5	    05	Shift display right
# 6	    07	Shift display left
# 7 	08	Display off, cursor off
# 8	    0A	Display off, cursor on
# 9	    0C	Display on, cursor off
# 10	0E	Display on, cursor blinking
# 11	0F	Display on, cursor blinking
# 12	10	Shift cursor position to left
# 13	14	Shift the cursor position to the right
# 14	18	Shift the entire display to the left
# 15	1C	Shift the entire display to the right
# 16	80	Force cursor to the beginning ( 1st line)
# 17	C0	Force cursor to the beginning ( 2nd line)

# Main
jal ra, lcd_init
li a0, 41 # "A"
jal ra, lcd_char
li a0, 0xC0
jal ra, lcd_cmd
li a0, 42 # "B"
jal ra, lcd_char
loop:
    j loop


# -----------------------------------------------------
# Function: lcd_init
# Purpose :  LCD Initialize function
# Inputs  : 
# -----------------------------------------------------
lcd_init:
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
    ret
# -----------------------------------------------------
# Function: lcd_char
# Purpose : Send data to LCD (for characters)
# Inputs  : a0 = data (8-bit)
# -----------------------------------------------------
lcd_char:
    li t0, 0x10004000   # Addr of LCD
    mv t1, a0            # Preserve original data

    # --- Step 1: Send with EN = 1 ---
    mv a0, s1            # a0 = data
    li a1, 0             # R/W = 0 (write)
    li a2, 1             # RS  = 1 (data mode)
    li a3, 1             # EN  = 1 (enable high)
    li a4, 1             # ON  = 1 (LCD on)
    jal ra, make_lcd_word
    sw a0, 0(t0)         # write to LCD

    li a0, 1             # delay 1ms
    jal ra, delay_ms

    # --- Step 2: Send with EN = 0 ---
    mv a0, s1            # restore data
    li a1, 0             # R/W = 0
    li a2, 1             # RS  = 1 (data mode)
    li a3, 0             # EN  = 0 (disable)
    li a4, 1             # ON  = 1
    jal ra, make_lcd_word
    sw a0, 0(t0)         # write to LCD again

    li a0, 5             # delay 5ms
    jal ra, delay_ms

    ret



# -----------------------------------------------------
# Function: lcd_cmd
# Purpose : Send command to LCD
# Inputs  : a0 = command (8-bit)
# -----------------------------------------------------
lcd_cmd:
    li t0, 0x10004000   # Addr of LCD
    mv t1, a0            # Preserve original command in t1

    # --- Step 1: Send with EN = 1 ---
    mv a0, s0            # a0 = data (command)
    li a1, 0             # R/W = 0 (write)
    li a2, 0             # RS  = 0 (command mode)
    li a3, 1             # EN  = 1 (enable high)
    li a4, 1             # ON  = 1 (LCD on)
    jal ra, make_lcd_word
    sw a0, 0(t0)         # write to LCD

    li a0, 1             # delay 1ms
    jal ra, delay_ms

    # --- Step 2: Send with EN = 0 ---
    mv a0, s0            # restore command
    li a1, 0             # R/W = 0
    li a2, 0             # RS  = 0
    li a3, 0             # EN  = 0 (disable)
    li a4, 1             # ON  = 1
    jal ra, make_lcd_word
    sw a0, 0(t0)         # write to LCD again

    li a0, 5             # delay 5ms
    jal ra, delay_ms
    ret


# =====================================================
# Function: make_lcd_word(data, rw, rs, en, on)
# Purpose : Build 32-bit LCD control word
# Inputs:
#   a0 = data (bits [7:0])
#   a1 = rw   (bit 8)
#   a2 = rs   (bit 9)
#   a3 = en   (bit 10)
#   a4 = on   (bit 31)
# Output:
#   a0 = packed 32-bit LCD word
# =====================================================
make_lcd_word:
    mv   t0, a0          # start with data in t0
    slli a1, a1, 8       # shift R/W
    slli a2, a2, 9       # shift RS
    slli a3, a3, 10      # shift EN
    slli a4, a4, 31      # shift ON
    or   t0, t0, a1
    or   t0, t0, a2
    or   t0, t0, a3
    or   t0, t0, a4
    mv   a0, t0
    ret

# -----------------------------------------------------
# Function: delay_ms(a0)
# Purpose : delay
# Inputs  : a0 = ms
# -----------------------------------------------------
delay_ms:
    li t0, 0
    li t1, 25000
    li t2, 0
delay_ms_loop:
    addi t0, t0, 1
    blt t0, t1, delay_ms_loop

    li t0, 0
    addi t2, t2, 1
    blt t2, a0, delay_ms_loop
    ret
# -----------------------------------------------------
# Function: delay_us(a0)
# Purpose : delay
# Inputs  : a0 = us
# -----------------------------------------------------
delay_us:
    li t0, 0
    li t1, 25
    li t2, 0
delay_us_loop:
    addi t0, t0, 1
    blt t0, t1, delay_us_loop

    li t0, 0
    addi t2, t2, 1
    blt t2, a0, delay_us_loop
    ret
