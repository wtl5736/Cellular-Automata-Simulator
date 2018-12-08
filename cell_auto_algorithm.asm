#
# FILE:         cell_auto_algorithm.asm
# AUTHOR:       W. Lee
#
# DESCRIPTION:
#	Performs generations and prints them out
#
# ARGUMENTS:
#	Generation Number
#	Array of Inputs
#
# INPUT:
# 	1's and 0's (70 Max Inputs)
#
# OUTPUT:
#	Generations

# syscall codes
PRINT_INT = 1
PRINT_STRING = 4
READ_INT = 5
PRINT_CHAR = 11	

# Max row size constant
MAX_ROW_SIZE = 70


	.data
	.align	2
	
# Generation Array
zero_generation:
	.space	4*MAX_ROW_SIZE
first_generation:
	.space	4*MAX_ROW_SIZE
second_generation:
	.space	4*MAX_ROW_SIZE
third_generation:
	.space	4*MAX_ROW_SIZE	
fourth_generation:
	.space	4*MAX_ROW_SIZE
fifth_generation:
	.space	4*MAX_ROW_SIZE
sixth_generation:
	.space	4*MAX_ROW_SIZE
seventh_generation:
	.space	4*MAX_ROW_SIZE
eighth_generation:
	.space	4*MAX_ROW_SIZE
ninth_generation:
	.space	4*MAX_ROW_SIZE
tenth_generation:
	.space	4*MAX_ROW_SIZE
eleventh_generation:
	.space	4*MAX_ROW_SIZE
twelfth_generation:
	.space	4*MAX_ROW_SIZE
thirteenth_generation:
	.space	4*MAX_ROW_SIZE
fourteenth_generation:
	.space	4*MAX_ROW_SIZE
fifteenth_generation:
	.space	4*MAX_ROW_SIZE
sixteenth_generation:
	.space	4*MAX_ROW_SIZE
seventeenth_generation:
	.space	4*MAX_ROW_SIZE
eighteenth_generation:
	.space	4*MAX_ROW_SIZE
nineteenth_generation:
	.space	4*MAX_ROW_SIZE
twentyth_generation:
	.space	4*MAX_ROW_SIZE
twentyfirst_generation:
	.space	4*MAX_ROW_SIZE
twentysecond_generation:
	.space	4*MAX_ROW_SIZE	
twentythird_generation:
	.space	4*MAX_ROW_SIZE		
twentyfourth_generation:
	.space	4*MAX_ROW_SIZE
twentyfifth_generation:
	.space	4*MAX_ROW_SIZE	
twentysixth_generation:
	.space	4*MAX_ROW_SIZE		

# Converted generation row array
return_array:
	.space	4*MAX_ROW_SIZE
	
# Array of letters that are used for consecutive alive cells
letter_array:
	.asciiz	".ABCDEFGHIJKLMNOPQRSTUVWXYZ"

# Initial Alive Cell	
letter:
	.asciiz	"A"
	
# Dead Cell
period:
	.asciiz	"."
test1:
	.asciiz	"keep:"
test:
	.asciiz	"consec:"
	.text				     # this is program code
	.align	2
	
	.globl	algorithm
	.globl	dead_or_alive
	.globl	print_newline
	.globl	print_one_space
	.globl	print_count
	.globl	done
	
# Main function that performs generations and prints them	
algorithm:
	beq	$v1, $s1, algorithm_done     # If Loop Count = Row Size
	jal	print_newline		     # Prints a newline
	jal	print_count		     # Prints the current generation num
	jal	print_one_space		     # Prints a space
	
	# Sees which generation its in and loads that array to $s4
	li	$t6, 0			     # $t6 = Zero Generation
	beq	$v1, $zero, zero_gen	     # If v1 = 0; goto zero_gen
		
	li	$t6, 1			     # $t6 = First Generation
	beq	$v1, $t6, first_gen	     # If v1 = 1; goto first_gen
	
	li	$t6, 2			     # $t6 = Second Generation
	beq	$v1, $t6, second_gen	     # If v1 = 2; goto second_gen
	
	li	$t6, 3			     # $t6 = Third Generation
	beq	$v1, $t6, third_gen	     # If v1 = 3; goto third_gen
	
	li	$t6, 4			     # $t6 = Fourth Generation
	beq	$v1, $t6, fourth_gen	     # If v1 = 4; goto fourth_gen
	
	li	$t6, 5			     # $t6 = Fifth Generation
	beq	$v1, $t6, fifth_gen	     # If v1 = 5; goto fifth_gen
	
	li	$t6, 6			     # $t6 = Sixth Generation
	beq	$v1, $t6, sixth_gen	     # If v1 = 6; goto sixth_gen
		
	li	$t6, 7			     # $t6 = Seventh Generation
	beq	$v1, $t6, seventh_gen	     # If v1 = 7; goto seventh_gen
	
	li	$t6, 8			     # $t6 = Eighth Generation
	beq	$v1, $t6, eighth_gen	     # If v1 = 8; goto eighth_gen
	
	li	$t6, 9	                     # $t6 = Ninth Generation
	beq	$v1, $t6, ninth_gen	     # If v1 = 9; goto ninth_gen
	
	li	$t6, 10			     # $t6 = Tenth Generation
	beq	$v1, $t6, tenth_gen	     # If v1 = 10; goto tenth_gen
	
	li	$t6, 11			     # $t6 = Eleventh Generation
	beq	$v1, $t6, eleventh_gen	     # If v1 = 12; goto eleventh_gen
	
	li	$t6, 12			     # $t6 = Twelfth Generation
	beq	$v1, $t6, twelfth_gen	     # If v1 = 12; goto twelfth_gen
	
	li	$t6, 13			     # $t6 = Thirteenth Generation
	beq	$v1, $t6, thirteenth_gen     # If v1 = 13; goto thirteenth_gen
	
	li	$t6, 14			     # $t6 = Fourteenth Generation
	beq	$v1, $t6, fourteenth_gen     # If v1 = 14; goto fourteenth_gen
	
	li	$t6, 15			     # $t6 = Fifteenth Generation
	beq	$v1, $t6, fifteenth_gen	     # If v1 = 15; goto fifteenth_gen
	
	li	$t6, 16			     # $t6 = Sixteenth Generation
	beq	$v1, $t6, sixteenth_gen	     # If v1 = 16; goto sixteenth_gen
	
	li	$t6, 17			     # $t6 = Seventeenth Generation
	beq	$v1, $t6, seventeenth_gen    # If v1 = 17; goto seventeenth_gen
	
	li	$t6, 18			     # $t6 = Eighteenth Generation
	beq	$v1, $t6, eighteenth_gen     # If v1 = 18; goto eighteenth_gen
	
	li	$t6, 19			     # $t6 = Nineteenth Generation
	beq	$v1, $t6, nineteenth_gen     # If v1 = 19; goto nineteenth_gen
	
	li	$t6, 20			     # $t6 = Twentyth Generation
	beq	$v1, $t6, twentyth_gen	     # If v1 = 20; goto twenyth_gen
	
	li	$t6, 21			     # $t6 = Twenty First Generation
	beq	$v1, $t6, twentyfirst_gen    # If v1 = 21; goto twentyfirst_gen
	
	li	$t6, 22			     # $t6 = Twenty Second Generation
	beq	$v1, $t6, twentysecond_gen   # If v1 = 22; goto twentysecond_gen
	
	li	$t6, 23			     # $t6 = Twenty Third Generation
	beq	$v1, $t6, twentythird_gen    # If v1 = 23; goto twentythird_gen
	
	li	$t6, 24			     # $t6 = Twenty Fourth Generation
	beq	$v1, $t6, twentyfourth_gen   # If v1 = 24; goto twentyfourth_gen
	
	li	$t6, 25			     # $t6 = Twenty fifth Generation
	beq	$v1, $t6, twentyfifth_gen    # If v1 = 25; goto twentyfifth_gen

algorithm_done:
	jal	print_newline	             # Prints a newline
	j	done			     # Jump to done	
	
################################# Subroutines ##################################
# Loads the corresponding generation array and performs generation
zero_gen:
	la	$s4, first_generation	     # Loads the first_gen array 
	jal	dead_or_alive		     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation

first_gen:	
	move 	$s5, $s4			# $s5 = $t1
	la	$s4, second_generation	     # Loads the second_gen array 
	jal	dead_or_alive		     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 

second_gen:
	la	$s5, ($s4)		     # Loads second_gen into s5 
	la	$s4, third_generation	     # Loads the third_gen array 
	jal	dead_or_alive	             # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation
	
third_gen:
	la	$s5, ($s4)		     # Loads third_gen into s5 
	la	$s4, fourth_generation	     # Loads the fourth_gen array 
	jal	dead_or_alive		     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation
	
fourth_gen:
	la	$s5, ($s4)		     # Loads fourth_gen into s5 
	la	$s4, fifth_generation	     # Loads the fifth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation
		
fifth_gen:
	la	$s5, ($s4)		     # Loads fifth_gen into s5 
	la	$s4, sixth_generation	     # Loads the sixth_gen array
	jal	dead_or_alive	   	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 
	
sixth_gen:
	la	$s5, ($s4)		     # Loads sixth_gen into s5
	la	$s4, seventh_generation	     # Loads the seventh_gen array
	jal	dead_or_alive	             # Performs generation
	addi	$v1, $v1, 1                  # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 
	 
seventh_gen:
	la	$s5, ($s4)		     # Loads seventh_gen into s5
	la	$s4, eighth_generation	     # Loads the eighth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation  
	
eighth_gen:
	la	$s5, ($s4)		     # Loads eighth_gen into s5
	la	$s4, ninth_generation	     # Loads the ninth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 
	
ninth_gen:
	la	$s5, ($s4)		     # Loads ninth_gen into s5
	la	$s4, tenth_generation	     # Loads the tenth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 
	
tenth_gen:
	la	$s5, ($s4)		     # Loads tenth_gen into s5
	la	$s4, eleventh_generation     # Loads the eleventh_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation

eleventh_gen:
	la	$s5, ($s4)		     # Loads eleventh_gen into s5
	la	$s4, twelfth_generation      # Loads the twelfth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation
	
twelfth_gen:
	la	$s5, ($s4)		     # Loads twelfth_gen into s5
	la	$s4, thirteenth_generation   # Loads the thirteenth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 	
	
thirteenth_gen:
	la	$s5, ($s4)		     # Loads thirteenth_gen into s5
	la	$s4, fourteenth_generation   # Loads the fourteenth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 	

fourteenth_gen:
	la	$s5, ($s4)		     # Loads fourteenth_gen into s5
	la	$s4, fifteenth_generation    # Loads the fifteenth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation
	
fifteenth_gen:
	la	$s5, ($s4)		     # Loads fifteenth_gen into s5
	la	$s4, sixteenth_generation    # Loads the sixteenth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 
	
sixteenth_gen:
	la	$s5, ($s4)		     # Loads sixteenth_gen into s5
	la	$s4, seventeenth_generation  # Loads the seventeenth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 

seventeenth_gen:
	la	$s5, ($s4)		     # Loads seventeenth_gen into s5
	la	$s4, eighteenth_generation   # Loads the eighteenth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 
	
eighteenth_gen:
	la	$s5, ($s4)		     # Loads eighteenth_gen into s5
	la	$s4, nineteenth_generation   # Loads the nineteenth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 
	
nineteenth_gen:
	la	$s5, ($s4)		     # Loads nineteenth_gen into s5
	la	$s4, twentyth_generation     # Loads the twentyth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 	
	
twentyth_gen:
	la	$s5, ($s4)		     # Loads twentyth_gen into s5
	la	$s4, twentyfirst_generation  # Loads the twentyfirst_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 
	
twentyfirst_gen:
	la	$s5, ($s4)		     # Loads twentyfirst_gen into s5
	la	$s4, twentysecond_generation # Loads the twentysecond_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation
	
twentysecond_gen:
	la	$s5, ($s4)		     # Loads twentysecond_gen into s5
	la	$s4, twentythird_generation  # Loads the twentythird_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 
	
twentythird_gen:
	la	$s5, ($s4)		     # Loads twentythird_gen into s5
	la	$s4, twentyfourth_generation # Loads the twentyfourth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation
	
twentyfourth_gen:
	la	$s5, ($s4)		     # Loads twentyfourth_gen into s5
	la	$s4, twentyfifth_generation  # Loads the twentyfifth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 	
	
twentyfifth_gen:
	la	$s5, ($s4)		     # Loads twentyfifth_gen into s5
	la	$s4, twentysixth_generation  # Loads the twentysixth_gen array
	jal	dead_or_alive	 	     # Performs generation
	addi	$v1, $v1, 1		     # Adds 1 to algorithm loop counter
	j	print_gen		     # Prints the generation 

################################################################################
# Prints the generation array with dead or alive cells
print_gen:
	li	$t0, 0			     # Loop counter
	la	$s6, return_array	     # Loads the address of return_array
	move 	$t1, $s5		     # Loads the last gen array -> t1
	move 	$t7, $s6		     # Loads the return_array -> t1
	
# Loop to print generation array (s4)	
print_gen_loop:
	beq	$t0, $s2, print_row	     # if $t0 == $t1 then target
	
	mul	$t2, $t0, 4		     # Offset for last gen array (t2) 
	mul	$t3, $t0, 4		     # Offset for return_array (t3)
	add	$t2, $t1, $t2		     # $t2 = Array($t1) + Offset (t2)
	add	$t3, $t7, $t3		     # $t3 = Array($t7) + Offset (t3)
	lw	$t4, ($t2)		     # Loads curr num <- last gen array
	lw	$t5, ($t3)		     # Loads curr num <- return_array
	
	beq	$t4, $zero, keep_current     # If t4 != 0; goto keep_current
	j	store_consecutive	     # Else: store_consecutive

	
# Keeps the current num from last gen array
keep_current:
	sw	$t4, ($t3)		     # Stores curr -> return_array
	addi	$t0, $t0, 1		     # Adds 1 to loop counter
	j	print_gen_loop		     # Jump to print_gen_loop

# Adds up the numbers from last gen array and return_array
store_consecutive:	
	add	$t6, $t4, $t5		     # Adds the prev gen num and num
					     #   from return_array

	sw	$t6, ($t3)		     # Stores addes num -> return_array
	addi	$t0, $t0, 1		     # Adds 1 to loop counter
	j	print_gen_loop		     # Jump to print_gen_loop

# Jump back to algorithm_loop when done printing 	
print_row:
	li	$t0, 0			     # Loop counter
	la	$t1, letter_array            # Loads the address of the 
					     #    letter_array	

# Print loop to print out entire row converted to . = Dead, and Letters = Alive	
print_row_loop:
	beq	$t0, $s2, print_row_done     # If t0 = Row Size; goto
					     #     print_row_done
					     
	mul	$t3, $t0, 4                  # Offset for return_array (s6) 
	add	$t3, $s6, $t3		     # $t3 = Array($s6) + Offset (t93)
	lw	$t4, ($t3)		     # Loads the num from the
					     #     return_array -> t4
        j	print_gen_letter	     # Jump to print_gen_letter
     

# Prints a letter if cell is alive	
print_gen_letter:
	add	$t9, $t4, $zero		     # Adds -1 to current num
	add	$t9, $t1, $t9		     # $t9 = Array($t1) + Offset (t9)
	lb	$a0, ($t9)		     # Loads letter into a0
	
	li	$v0, PRINT_CHAR 	   # Load the syscall code to print char
	syscall				   # Tell the OS to print char
	addi	$t0, $t0, 1		   # Adds 1 to loop counter
	j	print_row_loop		   # Jump to print_row_loop 

# After finished printing the whole row, jump to algorithm	
print_row_done:
	j	algorithm		   # Jump to algorithm
