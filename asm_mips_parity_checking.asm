start:  lui $s0, 0x1002  # address to LED
        lui $s1, 0x1003  # address of DIP switch
        lui $s4, 0x0000
        ori $s4, 0x0001  # s4 is 1
        lui $t0, 0x0000
loop:   lw  $t1, 0($s1)  # read the value of DIP switch
        lui $t2, 0x0000
        sw  $t0, 0($s0)
        lui $t0, 0x0000
        lui $s3, 0x0000
        ori $s3, 0x000f  # s3 is 15
count:  and $t2, $t1, $s4
        add $t0, $t2, $t0
        srl $t1, $t1, 0x0001
        sub $s3, $s3, $s4
        bgez $s3, count
        j   loop  
