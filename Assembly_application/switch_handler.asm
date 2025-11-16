
# -----------------------------------------------------
# Function: Switch handler
# Inputs  : a0 = address of switch (0x10010000)
#           a1 = address for old switch 
# -----------------------------------------------------
switch_handler:
    li t0, a0
    li t1, a1
    li t2, 0(t0)
    li t3, 0(t1)
    addi t2, t2, 0x1
    addi t3, t3, 0x1
    bne

sw0: 

sw1:

sw2:

sw3:

sw4
