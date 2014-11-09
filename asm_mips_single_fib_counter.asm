# t1: 0, t2: 1 -- storing actual data of fib
# t3: temp value
# t0: address of data memory
# t4: delay counter
# t5: a value that overflows when added to the max fib value in system
# t6: delay period

reset: j start

exception:	mfc0 $t1, $13
		sw $t1, 0($t0)
		and $t2, $zero, $zero
		ori $t2, 0x0003

	exc_delay:	sub $t2, $t2, $s1
		bgez $t2, exc_delay
		and $t1, $zero, $zero  # reset t1
		lui $t2, 0x0000
		ori $t2, 0x0001  # reset t2
		eret # continue the loop

start: 	lui $t0, 0x1002
	ori $t0, 0x0000  #address for data memory
	and $t1, $zero, $zero  # t1 = 0
	lui $t2, 0x0000
	ori $t2, 0x0001  # t2 = 1
	and $t3, $zero, $zero  # t3 = 0
	and $t4, $zero, $zero
	lui $t5, 0x7fff
	ori $t5, 0xfe00  # t5 restricts max fib to 0x01ff
	lui $t6, 0x0000
	ori $t6, 0x0000
	addi $t6, $t6, 0x0003  # t6 = 3
	lui $s1, 0x0000
	ori $s1, 0x0001

	loop:	jal fib
		addi $t4, $t4, 0x0001
		mult $t4, $t6
		mflo $t4

		delay:	sub $t4, $t4, $s1
			bgez $t4, delay
			add $t7, $t5, $t1
			j loop

fib: 	sw  $t1, 0($t0)
	add $t3, $t2, $zero
	add $t2, $t2, $t1
	add $t1, $t3, $zero
    jr $31
