# Initiate
jal ra, declare_variable

# Loop
loop:

    li a0, 2
    jal ra, delay_ms

    li a0, 0x10010000
    jal ra, read_sw
    li t0, 0x1
    li t1, 0x2
    beq a0, t0, stop
    beq a1, t1, reset

    li t0, 0x00000040
    lw a0, 0(t0)
    lw a1, 4(t0)
    lw a2, 8(t0)
    jal ra, watch_run
    sw a0, 0(t0)
    sw a1, 4(t0)
    sw a2, 8(t0)

    li t0, 0x00000040
    lw a0, 0(t0)
    lw a1, 4(t0)
    lw a2, 8(t0)
    jal ra, time_to_digit_convert
    sw s0, 12(t0)           # Hours ten
    sw s1, 16(t0)           # Hours one
    sw s2, 20(t0)           # Minutes ten
    sw s3, 24(t0)           # Minutes one
    sw s4, 28(t0)           # Seconds ten
    sw s5, 32(t0)           # Seconds one

    lw a0, 12(t0)
    li a1, 0x10002000
    jal ra, hex_led_display

    lw a0, 16(t0)
    li a1, 0x10002001
    jal ra, hex_led_display

    lw a0, 20(t0)
    li a1, 0x10002002
    jal ra, hex_led_display

    lw a0, 24(t0)
    li a1, 0x10002003
    jal ra, hex_led_display

    lw a0, 28(t0)
    li a1, 0x10003000
    jal ra, hex_led_display

    lw a0, 32(t0)
    li a1, 0x10003001
    jal ra, hex_led_display

    j loop

stop:
    j loop
reset:
    jal, ra, declare_variable
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
    # Time initialization (00:00:00), stored at 0x00000040
    # -------------------------------------------------
    li t0, 0x00000040       # Base address
    li t1, 0x00              
    sw t1, 0(t0)            # Hours
    sw t1, 4(t0)            # Minutes
    sw t1, 8(t0)            # Seconds
    li t1, 0x3F
    sw t1, 12(t0)           # Hours ten
    sw t1, 16(t0)           # Hours one
    sw t1, 20(t0)           # Minutes ten
    sw t1, 24(t0)           # Minutes one
    sw t1, 28(t0)           # Seconds ten
    sw t1, 32(t0)           # Seconds one

    ret

# -----------------------------------------------------
# Function: div
# Purpose : Unsigned integer division using subtraction
# Inputs  : a0 = dividend
#           a1 = divisor
# Outputs : a0 = quotient
#           a1 = remainder
# -----------------------------------------------------
div:
    mv t0, a0
    mv t1, a1
    li t2, 0
div_loop:
    blt t0, t1, div_end
    sub t0, t0, t1
    addi t2, t2, 1
    j div_loop
div_end:
    mv a0, t2
    mv a1, t0
    ret

# -----------------------------------------------------
# Function: Display 7 segment led
# Purpose : 
# Inputs  : a0 = digit
#           a1 = byte_address
# -----------------------------------------------------
hex_led_display:
    li t0, 0x00000000   # Base address of digit table
    slli t1, a0, 2      # Each digit stored at 4-byte aligned address
    add t0, t0, t1      # Compute the address of the digit
    lw t2, 0(t0)        # Load 7-segment code
    sb t2, 0(a1)        # Write to LED

# -----------------------------------------------------
# Function: Watch
# Purpose : Increase 1 seconds
# Inputs  : a0 = Hours
#           a1 = Minutes
#           a2 = Seconds
# Outputs : a0 = Hours
#           a1 = Minutes
#           a2 = Seconds
# -----------------------------------------------------
watch_run:
    li t0, 60        # seconds & minutes upper limit
    li t1, 24        # hours upper limit

    addi a2, a2, 1         # increment seconds
    blt a2, t0, watch_end  # if < 60, done

    addi a2, x0, 0         # reset seconds
    addi a1, a1, 1         # increment minutes
    blt a1, t0, watch_end  # if < 60, done

    addi a1, x0, 0         # reset minutes
    addi a0, a0, 1         # increment hours
    blt a0, t1, watch_end  # if < 24, done

    addi a0, x0, 0         # reset hours

watch_end:
    ret

# -----------------------------------------------------
# Function: Time to digit convert
# Purpose : Increase 1 seconds
# Inputs  : a0 = Hours
#           a1 = Minutes
#           a2 = Seconds
# Outputs : s0 = Hours ten
#           s1 = Hours one
#           s2 = Minutes ten
#           s3 = Minutes one
#           s4 = Seconds ten
#           s5 = Seconds one
# -----------------------------------------------------
time_to_digit_convert:
    mv t0, a0
    mv t1, a1
    mv t2, a2

    mv a0, t0
    li a1, 10
    jal ra, div
    mv s0, a0
    mv s1, a1

    mv a0, t1
    li a1, 10
    jal ra, div
    mv s2, a0
    mv s3, a1

    mv a0, t2
    li a1, 10
    jal ra, div
    mv s4, a0
    mv s5, a1


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
    andi a1, a1, 0x2

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
    addi t2, t2, 0
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
    blt t0, t1, delay_us

    li t0, 0
    addi t2, t2, 0
    blt t2, a0, delay_us
    ret
    
