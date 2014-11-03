reset: j start
exception:	and $t0, $zero, $zero
		and $t1, $zero, $zero
		lui $t0, 0x1001
		lui $t1, 0x1002
		lw $t2, 0($t0)
		sw $t2, 0($t1)
die:	j die
start: lui $t0, 0x7fff
       lui $t1, 0x0000
       bne $t1, $t0, start
       j start