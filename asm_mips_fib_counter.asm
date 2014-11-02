# t1: 0, t2: 1 -- storing actual data of fib
# t3: temp value
# t0: address of data memory
# t4: delay counter
# t5: max fib value
# t6: some random value
start: 	lui $t0, 0x1002
	ori $t0, 0x0000  #address for data memory
	lui $t1, 0x0000
	ori $t1, 0x0000  # t1 = 0
	lui $t2, 0x0000
	ori $t2, 0x0001  # t2 = 1
	lui $t3, 0x0000
	ori $t3, 0x0000  # t3 = 0
	lui $t4, 0x0000
	ori $t4, 0x0000
	lui $t5, 0x0000
	ori $t5, 0x01ff  # at most "111111111"
	lui $t6, 0x0000
	ori $t6, 0x0000
	addi $t6, $t6, 0x0003  # t6 = 3
	lui $s1, 0x0000
	ori $s1, 0x0001
loop:	jal fib
	add $t4, $t4, 0x0001
	mult $t4, $t6
	mflo $t4
delay:	sub $t4, $t4, $s1
	bgez $t4, delay
	slt $t7, $t1, $t5
	bne $t7, $zero loop
	j start
fib: 	sw  $t1, 0($t0)
	add $t3, $t2, $zero
	add $t2, $t2, $t1
	add $t1, $t3, $zero
     	jr $31
