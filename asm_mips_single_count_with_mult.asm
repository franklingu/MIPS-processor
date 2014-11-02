start : lui $t1, 0x0000
	ori $t1, 0x0001 # constant 1
	and $t6, $t6, $zero
	addi $t6, $t6, 0x0002
	lui $t0, 0x1003 # DIP pointer, for VHDL
	lw  $t4, 0($t0) 
	lui $t0, 0x1002 # LED pointer, for VHDL
	lui $t5, 0x0000
	ori $t5, 0x0001 # delay counter (n). Change according to the clock
	lui $t2, 0x0001
	and $t2, $t2, $zero
	lui $t3, 0x0040
	ori $t3, 0x0034
loop: 	mult $t5, $t6
	mflo $t5
	add $t2, $t2, $t1
	or $t2, $t2, $t5
delay: 	sub $t2, $t2, $t1 
	bgez $t2, delay
	sw  $t4, 0($t0)	
	nor $t4, $t4, $zero
	jr $t3 # infinite loop; n*3 (delay instructions) + 5 (non-delay instructions).
