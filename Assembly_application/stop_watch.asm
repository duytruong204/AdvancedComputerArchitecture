# Initiate
jal ra, declare_variable

# Loop
loop:

    #li a0, 2
    #jal ra, delay_ms

    li s0, 0x00000040 
    lw a0, 0(s0)
    lw a1, 4(s0)
    lw a2, 12(s0)
    lw a3, 16(s0)
    nop
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
    # -------------------------------------------------
    # Digit table (0–F), stored at 0x00000000
    # Each entry = 1 byte, aligned to 4 bytes for sw
    # -------------------------------------------------
    li t0, 0x00000000       # Base address
    li t1, 0x3F             # 0
    sw t1, 0(t0)
    li t1, 0x06             # 1
    sw t1, 4(t0)
    li t1, 0x5B             # 2
    sw t1, 8(t0)
    li t1, 0x4F             # 3
    sw t1, 12(t0)
    li t1, 0x66             # 4
    sw t1, 16(t0)
    li t1, 0x6D              # 5
    sw t1, 20(t0)
    li t1, 0x7D              # 6
    sw t1, 24(t0)
    li t1, 0x07              # 7
    sw t1, 28(t0)
    li t1, 0x7F              # 8
    sw t1, 32(t0)
    li t1, 0x6F              # 9
    sw t1, 36(t0)
    li t1, 0x77              # A
    sw t1, 40(t0)
    li t1, 0x7C              # B
    sw t1, 44(t0)
    li t1, 0x39              # C
    sw t1, 48(t0)
    li t1, 0x5E              # D
    sw t1, 52(t0)
    li t1, 0x79              # E
    sw t1, 56(t0)
    li t1, 0x71              # F
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

    ret
# -----------------------------------------------------
# Function: Display 7 segment led
# Purpose : 
# Inputs  : a0 = digit 0
#           a1 = digit 1
#           a2 = digit 2
#           a3 = digit 3
# Output:Display
# -----------------------------------------------------
hex_led_display:
    li   t4, 0x00000000      # Base address of digit table
    li   t5, 0               # Clear accumulator (final display value)

    # --- Digit a0: minutes ten ---
    slli t0, a0, 2           # offset = a0 * 4
    add  t0, t0, t4          # actual address
    lw   t1, 0(t0)           # load pattern
    slli t1, t1, 23          # shift to [31:23]
    or   t5, t5, t1          # add into result

    # --- Digit a1: minutes one ---
    slli t0, a1, 2
    add  t0, t0, t4
    lw   t1, 0(t0)
    slli t1, t1, 15          # shift to [22:15]
    or   t5, t5, t1

    # --- Digit a2: seconds ten ---
    slli t0, a2, 2
    add  t0, t0, t4
    lw   t1, 0(t0)
    slli t1, t1, 7           # shift to [14:7]
    or   t5, t5, t1

    # --- Digit a3: seconds one ---
    slli t0, a3, 2
    add  t0, t0, t4
    lw   t1, 0(t0)
    or   t5, t5, t1          # [6:0]

    # --- Output to LED ---
    li   t0, 0x10002000
    sw   t5, 0(t0)

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
    ret

# -----------------------------------------------------
# Function: Read SW
# Purpose : Read SW
# Inputs  : a0 = SW address
# Outputs : a0 = Stop
#           a1 = Reset
# -----------------------------------------------------
read_sw:
    mv t0, a0
    lw t1, 0(t0)
    mv a0, t1
    andi a0, a0, 0x1
    mv a1, t1
    srli a1, a1, 1
    andi a1, a1, 0x1
    ret

# -----------------------------------------------------
# Function: delay_ms
# Purpose : delay
# Inputs  : a0 = ms
# -----------------------------------------------------
delay_ms:
    li t0, 0
    li t1, 500000
    li t2, 0
delay_ms_loop:
    addi t0, t0, 1
    blt t0, t1, delay_ms_loop

    li t0, 0
    addi t2, t2, 1
    blt t2, a0, delay_ms_loop
    ret

# -----------------------------------------------------
# Function: delay_us
# Purpose : delay
# Inputs  : a0 = us
# -----------------------------------------------------
delay_us:
    li t0, 0
    li t1, 500
    li t2, 0
delay_us_loop:
    addi t0, t0, 1
    blt t0, t1, delay_us_loop

    li t0, 0
    addi t2, t2, 1
    blt t2, a0, delay_us_loop
    ret
    
