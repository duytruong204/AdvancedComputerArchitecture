# Setting stack frame using for all functions
 li sp, 0x000007FC # max 0x000007FF 

# Initiate
jal ra, declare_variable

# Loop
loop:

    li a0, 100
    jal ra, delay_ms

    li s0, 0x00000040 
    lw a0, 0(s0)
    lw a1, 4(s0)
    lw a2, 8(s0)
    lw a3, 12(s0)
    jal ra, hex_led_display

    li a0, 0x10010000
    jal ra, read_sw
    li s0, 0x1
    beq a0, s0, stop
    beq a1, s0, reset

    li s0, 0x00000040
    lw a0, 0(s0)           # Minutes ten
    lw a1, 4(s0)           # Minutes one
    lw a2, 8(s0)           # Seconds ten
    lw a3, 12(s0)          # Seconds one
    jal ra, watch_run
    li t0, 0x00000040
    sw a0, 0(s0)
    sw a1, 4(s0)
    sw a2, 8(s0)
    sw a3, 12(s0)

    j loop

stop:
    j loop
reset:
    jal ra, declare_variable
    j loop

declare_variable:
    # Allocate stack (8 bytes)
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)

    # -------------------------------------------------
    # Digit table (0–F), stored at 0x00000000
    # Each entry = 1 byte, aligned to 4 bytes for sw
    # -------------------------------------------------
    li t0, 0x00000000       # Base address
    li t1, 0x40             # 0
    sw t1, 0(t0)
    li t1, 0x79             # 1
    sw t1, 4(t0)
    li t1, 0x24             # 2
    sw t1, 8(t0)
    li t1, 0x30             # 3
    sw t1, 12(t0)
    li t1, 0x19             # 4
    sw t1, 16(t0)
    li t1, 0x12             # 5
    sw t1, 20(t0)
    li t1, 0x02             # 6
    sw t1, 24(t0)
    li t1, 0x78             # 7
    sw t1, 28(t0)
    li t1, 0x00             # 8
    sw t1, 32(t0)
    li t1, 0x10             # 9
    sw t1, 36(t0)
    li t1, 0x08             # A
    sw t1, 40(t0)
    li t1, 0x03             # B
    sw t1, 44(t0)
    li t1, 0x46             # C
    sw t1, 48(t0)
    li t1, 0x21             # D
    sw t1, 52(t0)
    li t1, 0x06             # E
    sw t1, 56(t0)
    li t1, 0x0E             # F
    sw t1, 60(t0)

    
    # -------------------------------------------------
    # Time initialization (00:00), stored at 0x00000040
    # -------------------------------------------------
    li t0, 0x00000040       # Base address  
    li t1, 0
    sw t1, 0(t0)            # Minutes ten
    sw t1, 4(t0)            # Minutes one
    sw t1, 8(t0)            # Seconds ten
    sw t1, 12(t0)           # Seconds one

    # Restore registers
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8
    ret

# -----------------------------------------------------
# Function: Display 7 segment LED
# Inputs  : a0 = digit0 (minutes ten)
#           a1 = digit1 (minutes one)
#           a2 = digit2 (seconds ten)
#           a3 = digit3 (seconds one)
# -----------------------------------------------------
hex_led_display:
    # Allocate stack (20 bytes)
    addi sp, sp, -20
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t4, 8(sp)
    sw t5, 12(sp)
    sw ra, 16(sp)

    # Load address of digit pattern table
    la   t4, digit_table      # <<< FIXED
    li   t5, 0                # Clear accumulator

    # --- Digit a0 ---
    slli t0, a0, 2
    add  t0, t0, t4
    lw   t1, 0(t0)
    slli t1, t1, 24
    or   t5, t5, t1

    # --- Digit a1 ---
    slli t0, a1, 2
    add  t0, t0, t4
    lw   t1, 0(t0)
    slli t1, t1, 16
    or   t5, t5, t1

    # --- Digit a2 ---
    slli t0, a2, 2
    add  t0, t0, t4
    lw   t1, 0(t0)
    slli t1, t1, 8
    or   t5, t5, t1

    # --- Digit a3 ---
    slli t0, a3, 2
    add  t0, t0, t4
    lw   t1, 0(t0)
    or   t5, t5, t1

    # Write to LED register
    li   t0, 0x10002000
    sw   t5, 0(t0)

    # Restore registers
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t4, 8(sp)
    lw t5, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20

    ret

# -----------------------------------------------------
# Function: Watch
# Purpose : Increase 1 seconds
# Inputs  : a0 = Minutes ten
#           a1 = Minutes one
#           a2 = Seconds ten
#           a3 = Seconds one
# Outputs : a0 = Minutes ten
#           a1 = Minutes one
#           a2 = Seconds ten
#           a3 = Seconds one
# -----------------------------------------------------
watch_run:
    # Allocate stack (12 bytes)
    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw ra, 8(sp)

    li t0, 9        # one limit
    li t1, 6        # ten limit

    addi a3, a3, 1
    li   t0, 10
    blt  a3, t0, watch_end      # if seconds one < 10, done

    # Reset seconds one, increment seconds ten
    addi a3, x0, 0
    addi a2, a2, 1
    li   t1, 6
    blt  a2, t1, watch_end      # if seconds ten < 6, done

    # Reset seconds, increment minutes one
    addi a2, x0, 0
    addi a1, a1, 1
    li   t2, 10
    blt  a1, t2, watch_end      # if minutes one < 10, done

    # Reset minutes one, increment minutes ten
    addi a1, x0, 0
    addi a0, a0, 1
    li   t3, 6
    blt  a0, t3, watch_end      # if minutes ten < 6, done

    # Reset minutes ten (rollover at 60:00)
    addi a0, x0, 0
watch_end:
    # Restore registers
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    ret

# -----------------------------------------------------
# Function: Read SW
# Purpose : Read SW
# Inputs  : a0 = SW address
# Outputs : a0 = Stop
#           a1 = Reset
# -----------------------------------------------------
read_sw:
    # Allocate stack (12 bytes)
    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw ra, 8(sp)
    
    mv t0, a0
    lw t1, 0(t0)
    mv a0, t1
    andi a0, a0, 0x1
    mv a1, t1
    srli a1, a1, 1
    andi a1, a1, 0x1

    # Restore registers
    lw t0, 0(sp)
    lw t1, 4(sp)
    sw ra, 8(sp)
    addi sp, sp, 12
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
