start:  lui $t1, 0x1001
	sw  $t1, 4($t1)
	lw  $t2, 4($t1)
	beq $t1, $t2, start
