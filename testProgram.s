addi $t0, $t0, -100
addi $t1, $t1, 100

slt $t2, $t0, $t1
sub $t3, $t1, $t0

add $t4, $t4, $zero
sw $t3, 0($t4)
lw $t5, 0($t4)
