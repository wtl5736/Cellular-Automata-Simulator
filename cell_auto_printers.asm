#
# FILE:         cell_auto_printers.asm
# AUTHOR:       W. Lee
#

# DESCRIPTION:
#	Print statements for various functions
#
# ARGUMENTS:
#	None
#
# INPUT:
# 	None
#
# OUTPUT:
#	None

# syscall codes
PRINT_INT = 1
PRINT_STRING = 4
READ_INT = 5

	.align	0

# Strings
banner_message:	
	.ascii	"*****************************************\n"
	.ascii	"**     Cellular Automata Simulator     **\n"
	.asciiz	"*****************************************\n\n"
	
rule:
	.asciiz	"Rule "
	
left_parenthese:
	.asciiz	" ("
	
right_parenthese:
	.asciiz	")"	

new_line:	
	.asciiz	"\n"

three_spaces:
	.asciiz	"   "

dash:
	.asciiz	"-"

plus:
	.asciiz	"+"

zero:
	.asciiz	"0"		

one_space:
	.asciiz	" "
	
	.text			# this is program code
	.align	2
	
	.globl	print_banner
	.globl	print_newline
	.globl	print_decimal_to_binary
	.globl	print_word_rule
	.globl	print_rule_num
	.globl	print_left_parenthese
	.globl	print_right_parenthese
	.globl 	print_horizontal_scale
	.globl	print_one_space
	.globl	print_three_spaces
	.globl	print_count

# Prints the banner message at the start of the simulation	
print_banner:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, banner_message	# Load the address to banner_message
	syscall				# Tell the OS to print string
	jr	$ra			# Jump to $ra
	
# Prints a newline	
print_newline:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, new_line		# Load the address to new_line
	syscall				# Tell the OS to print string
	jr	$ra			# Jump to $ra

# Converts the rule number (Base 10) to a binary number
print_decimal_to_binary:
	add	$t0, $s0, $zero		# Rule Number in Decimal form
	li	$t1, 0			# Zero out t1
	li	$t2, 1 			# $t2 = 1; 1 Mask
	sll	$t2, $t2, 7		# Move mask to correct position
	addi	$t3, $zero, 8		# Loop counter
	li	$t4, 24 		
	li	$t7, 0 			
	li	$t5, 0 			 

# Loop for print_binary_to_decimal	
decimal_to_binary_loop:
	and	$t1, $t0, $t2
	beq	$t1, $zero, decimal_to_binary_done  # If t1 = 0; goto
						       # decimal_to_binary_done
						       
	add	$t1, $zero, $zero	# Add 0 to t1
	addi	$t1, $zero, 1		# Add 1 to t1
	
# Sub-routine for decimal_to_binary; goes here when done
decimal_to_binary_done:
	li	$v0, PRINT_INT 		# Load the syscall code to print int
	move 	$a0, $t1		# Move t1 into a0 
	syscall				# Tell the OS to print integer
	
	mul	$t5, $t7, 4		# Offset
	add	$t5, $s7, $t5		# $t5 = Array($s5) + Offset
	sw	$t1, ($t5)		# Stores the current input into array
	addi	$t7, $t7, 1		# Adds 1 to counter ($s4)
	
	srl	$t2, $t2, 1		# Shifts t2 to the right 1
	addi 	$t3, $t3, -1		# Adds -1 to t3
	bne	$t3, $zero, decimal_to_binary_loop  # If t3 = 0; goto
							# decimal_to_binary_loop
							
	jr	$ra				    # Jump to $ra

# Prints the word 'Rule '
print_word_rule:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, rule		# Load the address to dash
	syscall				# Tell the OS to print string	
	jr	$ra			# jump to $ra

# Prints the rule number in decimal form
print_rule_num:
	li 	$v0, PRINT_INT		# Load the syscall code to print str
	move 	$a0, $s0		# Load the address to error_1
	syscall				# Tell the OS to print string
	jr	$ra			# Jump to $ra

# Prints a left parenthese	
print_left_parenthese:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, left_parenthese	# Load the address to dash
	syscall	
	jr	$ra			# jump to $ra

# Prints a right parenthese	
print_right_parenthese:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, right_parenthese	# Load the address to dash
	syscall	
	jr	$ra			# jump to $ra	
	
# Prints a dash for horizontal scale
print_dash:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, dash		# Load the address to dash
	syscall				# Tell the OS to print string
	addi	$t0, $t0, 1		# Adds 1 to t5 count
	j	print_horizontal_scale_loop	# Goto print_horizontal_scale

# Prints a plus for horizontal scale
print_plus:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, plus		# Load the address to plus
	syscall				# Tell the OS to print string
	addi	$t0, $t0, 1		# Adds 1 to t5 count
	addi	$t1, $t1, 10		# Adds 10 to t6 count
	j	print_horizontal_scale_loop	# Goto print_horizontal_scale

# Prints a zero for horizontal scale	
print_zero:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, zero		# Load the address to zero
	syscall				# Tell the OS to print string
	addi	$t0, $t0, 1		# Adds 1 to t5 count
	addi	$t2, $t2, 10		# Adds 10 to t7 count
	j	print_horizontal_scale_loop	# Goto print_horizontal_scale

# Prints three spaces before horizontal scale	
print_three_spaces:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, three_spaces	# Load the address to three_spaces
	syscall				# Tell the OS to print string
	jr	$ra			# Jump to $ra
	
# Prints the scale for the number of columns
print_horizontal_scale:
	li 	$t0, 1 		# Main counter	
	li 	$t1, 5		# Side counter for every five columns		
	li 	$t2, 10		# Side counter for every ten columns	
	move	$t3, $s2	# Moves s2 into s3	
	addi	$t3, $t3, 1	# Adds 1 to t3
	
# Sub-routine for print_horizontal_scale
print_horizontal_scale_loop:		
	# If Main counter = number of rows; goto print_horizontal_done	
	beq	$t0, $t3, print_horizontal_scale_done	
	
	beq	$t0, $t1, print_plus	# If t0 == t1; print plus string
	beq	$t0, $t2, print_zero	# Elif t0 == t2; print zero string
	j	print_dash		# Else: print a dash

# Sub-routine for print_horizontal_scale		
print_horizontal_scale_done:
	jr	$ra			# Jump to $ra

# Prints a space
print_one_space:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, one_space		# Load the address to one_space
	syscall				# Tell the OS to print string
	jr	$ra			# Jump to $ra

# Prints the current count of the algorithm function
print_count:
	li	$t6, 10			# t6 = 10; 10-25 doesn't need space
	blt	$v1, $t6, less_than_ten	# If v1 < 10; goto less_than_ten
	
	li	$v0, PRINT_INT 		# Load the syscall code to print int 
	move 	$a0, $v1		# Moves the current count num to a0
	syscall				# Tell the OS to print string
	jr	$ra			# Jump to $ra

# If counter is less than 10, print a space before the number
less_than_ten:
	li 	$v0, PRINT_STRING	# Load the syscall code to print str
	la 	$a0, one_space		# Load the address to one_space
	syscall				# Tell the OS to print string
	
	li	$v0, PRINT_INT 		# Load the syscall code to print int
	move 	$a0, $v1		# Moves the current count num to a0
	syscall				# Tell the OS to print int
	jr	$ra			# Jump to $ra
		