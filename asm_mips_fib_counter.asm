start: 	lui $t0, 0x1001
	ori $t0, 0x0000     #address for data memory
	lui $t1, 0x0001
	ori $t1, 0x0001     # t1 = 1
	andi $t1, 0x0000    # forwarding to ex stage, not from mem stage
	lui $t2, 0x0000
	ori $t2, 0x0001     # t2 = 1
	sw  $t2, 0($t0)
	lw  $t3, 0($t0)     # t3 = 1
	sub $t3, $t3, $t2   # t3 = 0, load use hazard
	lui $t4, 0x0000
	lui $t5, 0x0000
	ori $t5, 0x01ff     # at most "111111111"
	lui $t6, 0x0000
	addi $t6, $t6, 0x0003  # t6 = 3
	lui $s1, 0x0000
	ori $s1, 0x0001
	lui $t0, 0x1002
loop:	jal fib
	addi $t4, $t4, 0x0001
	mult $t4, $t6
	mflo $t4
delay:	sub $t4, $t4, $s1
	bgez $t4, delay    # control stall, control hazard
	addi $t4, $t4, 0x0001
	slt $t7, $t5, $t1
	beq $t7, $zero, loop
	j start
fib: 	sw  $t1, 0($t0)
	add $t3, $t2, $zero
	add $t2, $t2, $t1
	add $t1, $t3, $zero
     	jr $31
