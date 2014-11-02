# t1: 0, t2: 1 -- storing actual data of fib
# t3: address of data memory
# t4: delay counter
# t5: max fib value
# t6: some random value
start: 	lui $t0, 0x0000
	ori $t0, 0x0000
	lui $t1, 0x0000
	ori $t1, 0x0001
loop:	jal fib
delay:		

fib: 	add $t1, $t2, $t2
     	jr $31
