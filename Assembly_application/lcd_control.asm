



# -----------------------------------------------------
# Function: lcd_cmd
# Purpose : command for lcd
# Inputs  : a0 = command (hex)
# -----------------------------------------------------
lcd_cmd:
    

# -----------------------------------------------------
# Function: delay_us
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
