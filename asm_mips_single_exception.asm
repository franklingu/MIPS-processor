# test exception
start:	lui $t0, 0x7fff
	ori $t0, 0xffff
	lui $t1, 0x7fff
	ori $t1, 0xffff
	add $t0, $t1, $t0
