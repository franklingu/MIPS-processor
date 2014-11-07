start:  nop
	lui $t0, 0x1001
        ori $t0, 0x0000  # t0 = 0x10010000
        addi $t6, $t0, 0x0001  # t6 = 0x10010001
        sw  $t6, 0($t0)
        lw  $t1, 0($t0)
        lui $t1, 0x0000
        ori $t1, 0x0001  # t1 = 1
        addi $t1, $t1, 0x0001
        lui $t2, 0x0000
        ori $t2, 0x0002  # t2 = 2
        lui $t3, 0x0000
        ori $t3, 0x0003  # t3 = 3
        add $t4, $t1, $t2  # t4 = 4
        sub $t5, $t4, $t2  # t5 = 2
        mult $t2, $t3
        mfhi $t2
        mflo $t3
        ori $t2, 0x0004
        div $t3, $t2
        mfhi $t2
        mflo $t3
        lw  $t6, 0($t0)
        sw  $t6, 4($t0)
        lw  $t7, 4($t0)
        sub $s0, $t7, $t3
        nop
        nop
        nop
        nop
        nop