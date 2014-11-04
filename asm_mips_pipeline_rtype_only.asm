start:  lui $t0, 0x1002
        ori $t0, 0x0000  # t0 = 0x10020000
        addi $t6, $t0, 0x0001
        lui $t1, 0x0000
        ori $t1, 0x0001  # t1 = 1
        lui $t2, 0x0000
        ori $t2, 0x0002  # t2 = 2
        lui $t3, 0x0000
        ori $t3, 0x0001  # t3 = 3
        add $t4, $t1, $t2  # t4 = 3
        sub $t5, $t4, $t2  # t5 = 1
        lui $t6, 0x0001  # dummy commands
        lui $t6, 0x0002
        lui $t6, 0x0003
        lui $t6, 0x0004
        lui $t6, 0x0005
        lui $t6, 0x0006
        lui $t6, 0x0000