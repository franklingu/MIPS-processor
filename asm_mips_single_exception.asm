# test exception
reset: j start
exc_handler: lui $t0, 0x1002
	ori $t0, 0x0000
	lui $t3, 0x0000
	ori $t3, 0xaaaa
	sw  $t3, 0($t0)
die:	j start
start:	lui $t2, 0x7fff
	ori $t2, 0xffff
	lui $t1, 0x7fff
	ori $t1, 0xffff
	sw $t2, 0($t1)
	ori $t0, 0xffff
	j reset
