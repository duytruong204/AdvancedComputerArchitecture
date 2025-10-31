# Declaration
    # List of Digit digit = {3F,06,5B,4F,66,6D,7D,07,7F,6F,77,7C,39,5E,79,71}
    
    # Address is from 0x0000_0000 to 0x0000_0040
    li t0, 0x0000_0000
    li t1, 0x3F      # Digit 0
    sw t1, 0(t0)      
    li t1, 0x06
    sw t1, 4(t0)
    li t1, 0x5B
    sw t1, 8(t0)
    li t1, 0x3F
    sw t1, 0(t0)
    li t1, 0x4F
    sw t1, 0(t0)
    li t1, 0x66
    sw t1, 0(t0)
    li t1, 0x7D
    sw t1, 0(t0)
    li t1, 0x07
    sw t1, 0(t0)
    # Time: 00 : 00 (ab:cd)
