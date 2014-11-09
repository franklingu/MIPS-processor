start:	jal ra1
ra1:	jal ra2	
ra2:	jal ra3
ra3:	jal ra4
ra4:	jal ra5
ra5:	jal mod
mod:	ori $t1, 0x0001
	ori $t2, 0x0004
	mult $t1, $t2
	mflo $t2
	sub $31, $31, $t2
	sub $31, $31, $t2
	sub $31, $31, $t2
	addi $31, $31, 0x0004
	jr $31