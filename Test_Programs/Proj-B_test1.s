#
# First part of the Lab 3 test program
#

# data section
.data
arr:.byte 0, 1, 2, 3

# code/instruction section
.text

# Loads
la   $1, arr
lw   $2, 4($1)
addi $3, $2, 3
sw   $3, 8($1)
lw   $4, 8($1)

# Arithmetic
addi  $1,  $0,  1 		# Place “1” in $1
addi  $2,  $0,  2		# Place “2” in $2
addi  $3,  $0,  3		# Place “3” in $3
addi  $10, $0,  10		# Place “10” in $10
add   $11, $1,  $2		# $11 = $1 + $2
sub   $12, $11, $3 		# $12 = $11 - $3

# Overflow
lui   $13, 0x7FFF
addi  $14, $13, 0xFFFF
addiu $15, $14, 0xFFFF
addu  $15, $13, $1
subu  $15, $0, $14
subu  $15, $15, $13

# slt instructions
slt   $16, $1, $2
slt   $16, $2, $1
slti  $16, $2, 1
slti  $16, $2, 3
sltiu $16, $2, 1
sltiu $16, $2, 3
sltu  $16, $1, $2
sltu  $16, $2, $1

# Shifts
addi $1, $0, 0xFFFF
lui  $2, 0xFFFF
sll  $17, $1, 31 
srl  $17, $2, 31
sra  $17, $2, 31
sllv $17, $1, $10
srlv $17, $2, $10
srav $17, $2, $10

# Logical operators
# Each operation acts as a truth table
addi $1, $0, 0xF0F0
addi $2, $0, 0xFF00
and  $3, $1, $2
andi $3, $1, 0xFF00
nor  $3, $1, $2
xor  $3, $1, $2
xori $3, $1, 0xFF00
or   $3, $1, $2
ori  $3, $1, 0xFF00

addi  $2,  $0,  10              # Place "10" in $v0 to signal an "exit" or "halt"
syscall                         # Actually cause the halt
