#
# FILE:         cell_auto_sim.asm
# AUTHOR:       W. Lee
#
# DESCRIPTION:
#	Simulates a elementary (1-dimensional) cellular automaton
#
# ARGUMENTS:
#	Rule Number
#	Generation Number
#	Row Size
#
# INPUT:
# 	1's and 0's (70 Max Inputs)
#
# OUTPUT:
#	Simulated cellular automata
#

# Syscall Codes
PRINT_INT =	1
PRINT_STRING = 	4
READ_INT = 	5

# Frame size used by main function
FRAMESIZE_40 =	40

# Error Check Constants
MIN_RULE_NUM = 0
MAX_RULE_NUM = 255

MAX_GEN_NUM = 25

MIN_ROW_SIZE = 1
MAX_ROW_SIZE = 70

MIN_INPUT_VAL = 0
MAX_INPUT_VAL = 1


	.data
	.align	2

# Array of inputs 
cells:
	.word	initial_array
	
initial_array:
	.space	4*MAX_ROW_SIZE
	
# Binary number 
binary_num_array:
	.word	binary

binary:
	.space	32

	
	.align	0

# Error Statements
error_1:
	.asciiz	"Invalid rule number, cell-auto-sim terminating\n"

error_2:
	.asciiz	"Invalid generation number, cell-auto-sim terminating\n"	

error_3:
	.asciiz	"Invalid row size, cell-auto-sim terminating\n"

error_4:
	.asciiz	"Illegal input value, cell-auto-sim terminating\n"
	
	
	.text			# this is program code
	
	.align	2		# instructions must be on word boundaries
	.globl	main		# main is a global label
	.globl	print_banner
	.globl	print_newline
	.globl	print_decimal_to_binary
	.globl	print_word_rule
	.globl	print_rule_decimal
	.globl	print_left_parenthese
	.globl	print_right_parenthese
	.globl	print_horizontal_scale
	.globl	print_one_space
	.globl	print_three_spaces
	.globl	print_rule_num
	.globl	algorithm
	.globl	dead_or_alive
	.globl	done
	
#
# Name:         main
#
# Description:  EXECUTION BEGINS HERE
# Arguments:    
#	Rule Number
#	Generation Number
#	Number of Inputs
#	Inputs (1's and 0's)
#
# Returns:      
#	A similates cellular automata
#

main:

#
# Save registers ra and s0 - s7 on the stack.
#
	addi 	$sp, $sp, -FRAMESIZE_40
	sw 	$ra, -4+FRAMESIZE_40($sp)
	sw 	$s7, 28($sp)
	sw 	$s6, 24($sp)
	sw 	$s5, 20($sp)
	sw 	$s4, 16($sp)
	sw 	$s3, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)

#
# Read Rule Number - s0
#	
	li	$t9, 1		 
	
	li	$v0, READ_INT		# Reads in int from first line
	syscall
	move	$s0, $v0		# s0 = rule # (first line)
	
	slti	$t0, $s0, MIN_RULE_NUM	# if s0 < 0; t0 = 1
	sgt	$t1, $s0, MAX_RULE_NUM	# if s0 > 255; t0 = 1
	beq	$t0, $t9, print_error1	# if $t0 == 1; then print_error1
	beq	$t1, $t9, print_error1	# if $t1 == 1; then print_error1
	beq	$t0, $t9, done		# if $t0 == 1; then done
	beq	$t1, $t9, done		# if $t1 == 1; then done

#
# Read Generation Number - s1
#		 
	
	li	$v0, READ_INT		# Reads in int from second
	syscall
	move	$s1, $v0		# s1 = Generation # (second line)
	
	bltz	$s1, print_error2	# if s1 < 0; then goto print_error2
	sgt	$t0, $s1, MAX_GEN_NUM	# if s1 > 25; then t0 = 1
	beq	$t0, $t9, print_error2	# if $t0 == 1; then print_error2
	beq	$t0, $t9, done		# if $t0 == 1; then done
	
#
# Read Row Size - s2
#	 
	
	li	$v0, READ_INT		# Reads in int from third line
	syscall
	move	$s2, $v0		# s1 = Row Size (third line)
	
	slti	$t0, $s2, MIN_ROW_SIZE	# if s2 < 1; t0 = 1, else t0 = 0
	sgt	$t1, $s2, MAX_ROW_SIZE	# if s2 > 70; t1 = 1, else t0 = 0
	beq	$t0, $t9, print_error3	# if $t0 == 1 then print_error3
	beq	$t1, $t9, print_error3	# if $t1 == 1 then print_error3
	beq	$t0, $t9, done		# if $t0 == 1; then done
	beq	$t1, $t9, done		# if $t1 == 1; then done
	
#
# Reads in input and stores into array - s5
#
	la	$s5, cells	# Stores the address of the newly allocated
				# memory into $s5
	
	li	$s4, 0		# Loop Counter for read_input
	jal	read_input	# Jump to read_input and save position to $ra
	
	jal 	print_banner		# Prints the banner message
	jal	print_word_rule		# Prints the word 'Rule '
	jal	print_rule_num		# Prints the rule number in decimal form
	jal	print_left_parenthese	# Prints a left parenthese
	
	la	$s7, binary_num_array	# 
	jal	print_decimal_to_binary	# Prints a left parenthese
	
	jal	print_right_parenthese	# Prints a right parenthese
	jal	print_newline		# Prints a newline
	jal	print_three_spaces	# Prints 3 spaces for padding
	jal	print_horizontal_scale	# Prints the horizontal scale
	
	move 	$a0, $s5		# $a0 = $t1
	addi	$s1, $s1, 1		# Adds 1 to s1
	jal	algorithm		# Jump to algorithm	
	
################################# Subroutines ##################################
# Reads input values and store them in cells array
read_input:
	beq	$s4, $s2, read_input_done    # If $t0 == $t1 then read_loop_done
	
	li	$v0, READ_INT			# Reads in cell
	syscall
	move	$s3, $v0			# s1 = Row Size (third line)
	
	li	$t7, 0				# MIN input value
	beq	$s3, $t7, store_input		# If $t0 == $t1 then store_input
	li	$t7, 1				# MAX input value
	beq	$s3, $t7, store_input		# If $t0 == $t1 then store_input
	bltz	$s3, print_error4		# If s3 < 0; print_error4
	sgt	$t2, $s3, MAX_INPUT_VAL		# If s3 > 1; t2 = 1, else t2 = 0
	beq	$t2, $t7, print_error4		# If t2 = 1, then print_error4
	
# Stores the input into cells array	
store_input:
	beq	$s4, $s2, read_input_done    # If $t0 == $t1 then read_loop_done
	mul	$t5, $s4, 4		# Offset
	add	$t5, $s5, $t5		# $t5 = Array($s5) + Offset
	sw	$s3, ($t5)		# Stores the current input into array
	addi	$s4, $s4, 1		# Adds 1 to counter ($s4)
	j	read_input		# Jump to read_input
	
# Jumps back to last saved $ra position (main)
read_input_done:
	jr	$ra			# Jump to $ra (main)
						
############################ Error Print Statements ############################
# Prints Invalid Rule String (Error Message 1)	
print_error1:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, error_1		# Load the address to error_1
	syscall				# Tell the OS to print string
	j	error_done			# Jump to done

# Prints Generation Number String (Error Message 2)	
print_error2:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, error_2		# Load the address to error_2
	syscall				# Tell the OS to print string
	j	error_done			# Jump to done	

# Prints Row Size String (Error Message 3)	
print_error3:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, error_3		# Load the address to error_3
	syscall				# Tell the OS to print string
	j	error_done			# Jump to done
	
# Prints Invalid Input Number String (Error Message 4)	
print_error4:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, error_4		# Load the address to error_4
	syscall				# Tell the OS to print string
	j	error_done			# Jump to done

done:
	jal	print_three_spaces	# Prints 3 spaces for padding
	jal	print_horizontal_scale	# Prints the horizontal scale
	jal	print_newline		# Prints a newline

# Exits immediately	
error_done:
	
###############################################################################	
	
#
# Restore registers ra and s0 - s7 from the stack.
#
	lw 	$ra, -4+FRAMESIZE_40($sp)
	lw 	$s7, 28($sp)
	lw 	$s6, 24($sp)
	lw 	$s5, 20($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 12($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, FRAMESIZE_40
	jr	$ra		# Return to the caller.
	