#
# Merge sort algorithm
#

.data 
arr: 54, 85, 1, 26, 87, 13, 0, 6
length: 8

.text
la $a0, arr
lw $t0, length
sll $t0, $t0, 2
add $a1, $a0, $t0 # $a1 gets length * 4 + start addr
jal mergesort
j end

# Recursive sort method
mergesort:

    addi $sp, $sp, -16 # save values
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)

    sub $t0, $a1, $a0 # subarray length

    ble $t0, 4, sortend # base case: one elem array

    srl $t0, $t0, 1
    add $a1, $a0, $t0 # get midpoint
    sw $a1, 12($sp)

    jal mergesort

    lw $a0, 12($sp)
    lw $a1, 8($sp) # load elements

    jal mergesort

    lw $a0, 4($sp) # reload values from stack
    lw $a1, 12($sp)
    lw $a2, 8($sp)

    jal merge

sortend:

    lw $ra, 0($sp)
    addi $sp, $sp, 16
    jr $ra

# Merge method
merge:

    addi $sp, $sp -16 # save values
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)

    move $s0, $a0
    move $s1, $a1 # storing arr begin and end

loop:

    lw $t0, 0($s0)
    lw $t1, 0($s1) # load elements

    bgt $t1, $t0, noshift # skip shift if val is lower

    move $a0, $s1
    move $a1, $s0 # load arguments
    jal shift

    addi $s1, $s1, 4 # increment index

noshift:

    addi $s0, $s0, 4 # increment index

    lw $a2, 12($sp) # end loop conditions
    bge $s0, $a2, loopend
    bge $s1, $a2, loopend
    j loop

loopend:

    lw $ra, 0($sp)
    addi $sp, $sp, 16
    jr $ra

shift:

    ble $a0, $a1, shiftend # order elements
    addi $t6, $a0, -4
    lw $t7, 0($a0)
    lw $t8, 0($t6)
    sw $t7, 0($t6)
    sw $t8, 0($a0)
    move $a0, $t6
    j shift

shiftend:

    jr $ra
	
end:

    li	$v0,10 #terminate
	syscall
