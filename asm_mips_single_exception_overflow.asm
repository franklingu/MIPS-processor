reset: j start
exception:	and $t1, $zero, $zero
		lui $t1, 0x1002
		mfc0 $t2, $13
		sw $t2, 0($t1)
die:	j die
start: lui $t0, 0x7fff
       add $t1, $t1, $t0
       j start