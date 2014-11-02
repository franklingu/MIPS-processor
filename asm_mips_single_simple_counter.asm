start : lui $t1, 0x0000
    ori $t1, 0x0001 # constant 1
    lui $t0, 0x1003 # DIP pointer, for VHDL
    lw  $t4, 0($t0) 
    lui $t0, 0x1002 # LED pointer, for VHDL
    lui $t5, 0x0000
    ori $t5, 0x0000 # delay counter (n). Change according to the clock
    lui $t2, 0x0001
    and $t2, $t2, $zero
loop:   add $t5, $t5, $t1
    or $t2, $t2, $t5
delay:  sub $t2, $t2, $t1 
    slt $t3, $t2, $t1
    beq $t3, $zero, delay
    sw  $t4, 0($t0) 
    nor $t4, $t4, $zero
    j loop # infinite loop; n*3 (delay instructions) + 5 (non-delay instructions).
