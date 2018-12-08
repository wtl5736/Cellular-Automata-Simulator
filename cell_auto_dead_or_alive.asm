#
# FILE:         cell_auto_dead_or_alive.asm
# AUTHOR:       W. Lee
#
# DESCRIPTION:
#	Checks if cells will be dead or alive for next generation
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
#	Returns an array of dead or alive cells

# syscall codes
PRINT_INT = 1
PRINT_STRING = 4
READ_INT = 5

# Constants
MAX_ON_OFF_COUNT = 3
MAX_ROW_SIZE = 70

	.data
	.align	2

# Translation Rule Bits	
SeventhBit:	.word	1, 1, 1
SixthBit:	.word	1, 1, 0
FifthBit:	.word	1, 0, 1
FourthBit:	.word	1, 0, 0
ThirdBit:	.word	0, 1, 1
SecondBit:	.word	0, 1, 0
FirstBit:	.word	0, 0, 1
ZeroBit:	.word	0, 0, 0

# Array for tranlation rule (4 bytes * 3 elements = 12)	
current_array:
	.space	12
	
	.text				# this is program code
	
	.align	2
	.globl	dead_or_alive

dead_or_alive:
	li	$t1, 0			# dead_or_alive_array Counter
	li	$t2, 0			# Loop Counter (0 indexed)
	la	$s6, current_array 	# Array that stores the current vals
	move	$t3, $s2		# Storing Row Size into t3
	mul	$t3, $t3, 4		# Multiplies the Row Size by 4 for Max
					# Array Size
		
dead_or_alive_loop:
	move	$t6, $s2			# $t6 = $s2 (Num of inputs)
	addi	$t6, $t6, -1			# Subtracts 1 from t6
	beq	$t2, $s2, dead_or_alive_done	# Check to see if 
						#       Loop Counter = Row Size
	
	mul	$t4, $t2, 4			# Offset
	add	$t4, $s5, $t4			# $t4 = Array($s5) + Offset
	lw	$t5, ($t4)			# Stores the curr input -> array
	li	$t9, 0 				# 3 cell look counter (Max 3)
						# Resets every time
	li	$t8, 0 				# First cell
		
	beq	$t2, $t8, first_cell	# If Loop counter = 0; 
					# goto first_cell
					
	beq	$t2, $t6, last_cell	# Elif Loop counter = Row Size; 
					# 	goto first_cell
					
	j	middle_cells		# Else: go to middle_cells 
	
dead_or_alive_done:
	jr	$ra			# Jump to $ra

################################# Subroutines ##################################

# When program is looking at the first cell
first_cell:
	li	$t6, MAX_ON_OFF_COUNT	# t6 = 3
	beq	$t9, $t6, dead_or_alive_check # Checks if 3 cells were hit 
	li	$t7, 0			# Initializing t7 to equal 0 	
		
	beq	$t9, $zero, FCLN 	# If Loop Counter = 0; goto FCLN
	li	$t8, 1			# Number used to go to SFC
	beq	$t9, $t8, SFC		# Elif Loop Counter = 1; goto SFC
	li	$t8, 2			# Number used to go to FCRN
	beq	$t9, $t8, FCRN		# Elif Loop Counter = 2; goto FCRN
	
# The First Cell's Left Neighbor(Last Cell)	
FCLN:
	# Loads input from cells array
	add	$t7, $zero, $t3		# Adds Last column
	addi	$t7, $t7, -4		# Offset; Gets previous cell
	add	$t7, $s5, $t7		# $t7 = Array($s5) + Offset
	lw	$s3, ($t7)		# Loads the previous cell into array
	
	# Stores loaded cell into temp array
	mul	$t7, $t9, 4		# Offset for temp array (t7)
	add	$t7, $s6, $t7		# # $t5 = Array($s6) + Offset
	sw	$s3, ($t7)		# Stores the previous input into array
	addi	$t9, $t9, 1		# Adds 1 to current cell loop counter
	j	first_cell		# Jump to first_cell (t9 = 1)

# Store the First Cell (Current Cell being looked at)	
SFC:
	move 	$s3, $t5		# The current cell's numer (1 or 0)
	mul	$t7, $t9, 4		# Offset for temp array (t7)
	add	$t7, $s6, $t7		# $t7 = Array($s6) + Offset
	sw	$s3, ($t7)		# Stores the current input into array
	addi	$t9, $t9, 1		# Adds 1 to current cell loop counter
	j	first_cell		# Jump to first_cell (t9 = 2)

# The First Cell's Right Neighbor		
FCRN:	
	# Loads input from cells array
	mul	$t7, $t2, 4		# Offset for cells array (s5)
	addi	$t7, $t7, 4		# Offset; Gets to the next cell
	add	$t7, $s5, $t7		# $t7 = Array($s5) + Offset
	lw	$s3, ($t7)		# Loads the current input into array
	
	# Stores loaded cell into temp array
	mul	$t7, $t9, 4		# Offset for temp array (t7)
	add	$t7, $s6, $t7		# $t7 = Array($s6) + Offset
	sw	$s3, ($t7)		# Stores the next input into array
	addi	$t9, $t9, 1		# Adds 1 to current cell loop counter
	j	first_cell		# jump to first_cell (t9 = 3)

################################################################################

# When program is looking at a middle cell
middle_cells:
	li	$t6, MAX_ON_OFF_COUNT	# t6 = 3
	beq	$t9, $t6, dead_or_alive_check
	li	$t7, 0			# Initializing t7 to equal 0  		
	beq	$t9, $zero, MCLN 	# If Loop Counter = 0; goto MCLN
	li	$t8, 1			# Number used to goto SMC
	beq	$t9, $t8, SMC		# Elif Loop Counter = 1; goto SMC
	li	$t8, 2			# Number used to goto MCRN
	beq	$t9, $t8, MCRN		# Elif Loop Counter = 2; goto MCRN
	
# The Middle Cell's Left Neighbor			
MCLN:
	# Loads input from cells array
	mul	$t7, $t2, 4		# t7 = Loop Counter * 4
	addi	$t7, $t7, -4		# Offset; Gets to previous cell
	add	$t7, $s5, $t7		# $t7 = Array($s5) + Offset
	lw	$s3, ($t7)		# Loads the previous cell into array
	
	# Stores loaded cell into temp array
	mul	$t7, $t9, 4		# Offset for temp array (t7)
	add	$t7, $s6, $t7		# $t7 = Array($s6) + Offset
	sw	$s3, ($t7)		# Stores the current input into array
	addi	$t9, $t9, 1		# Adds 1 to current cell loop counter
	j	middle_cells		# Jump to middle_cells (t9 = 1)
	
# Store the Current Cell being looked at		
SMC:
	# Loads input from cells array
	mul	$t7, $t2, 4		# t7 = Loop Counter * 4
	add	$t7, $s5, $t7		# $t7 = Array($s5) + Offset
	lw	$s3, ($t7)		# Loads the previous cell into array
	
	# Stores loaded cell into temp array
	mul	$t7, $t9, 4		# Offset temp array
	add	$t7, $s6, $t7		# $t5 = Array($s5) + Offset
	sw	$s3, ($t7)		# Stores the current input into array
	addi	$t9, $t9, 1		# Adds 1 to current cell loop counter
	j	middle_cells		# Jump to middle_cells (t9 = 2)
	
# The Middle Cell's Right Neighbor	
MCRN:	
	# Loads input from cells array
	mul	$t7, $t2, 4		# Offset for cells array (s5)
	addi	$t7, $t7, 4		# Offset; Gets to next cell
	add	$t7, $s5, $t7		# $t7 = Array($s5) + Offset
	lw	$s3, ($t7)		# Loads the current input into array

	# Stores loaded cell into temp array
	mul	$t7, $t9, 4		# Offset for temp array (t7)
	add	$t7, $s6, $t7		# $t7 = Array($s6) + Offset
	sw	$s3, ($t7)		# Stores the current input into array
	addi	$t9, $t9, 1		# Adds 1 to current cell loop counter
	j	middle_cells		# Jump to middle_cells (t9 = 3)

################################################################################

# When program is looking at a last cell
last_cell:
	li	$t6, MAX_ON_OFF_COUNT	# t6 = 3 
	beq	$t9, $t6, dead_or_alive_check	
	li	$t7, 0			# Initializing t7 to equal 0 		
	beq	$t9, $zero, LCLN 	# If Loop Counter = 0; goto LCLN
	li	$t8, 1			# Number used to goto SLC
	beq	$t9, $t8, SLC		# Elif Loop Counter = 1; goto SLC
	li	$t8, 2			# Number used to goto LCRN
	beq	$t9, $t8, LCRN		# Elif Loop Counter = 2; goto LCRN

# The Last Cell's Left Neighbor
LCLN:
	# Loads input from cells array
	mul	$t7, $t2, 4		# # t7 = Loop Counter * 4
	addi	$t7, $t7, -4		# Offset; Gets to previous cells
	add	$t7, $s5, $t7		# $t7 = Array($s5) + Offset
	lw	$s3, ($t7)		# Stores the current input into array

	# Stores loaded cell into temp array
	mul	$t7, $t9, 4		# Offset for temp array (t7)
	add	$t7, $s6, $t7		# $t7 = Array($s6) + Offset
	sw	$s3, ($t7)		# Stores the current input into array
	addi	$t9, $t9, 1		# Adds 1 to current cell loop counter
	j	last_cell		# Jump to last_cell (t9 = 1)

# Store the Current Cell being looked at
SLC:
	move 	$s3, $t5		# The current cell's numer (1 or 0)
	mul	$t7, $t9, 4		# Offset for temp array (t7)
	add	$t7, $s6, $t7		# $t7 = Array($s6) + Offset
	sw	$s3, ($t7)		# Stores the current input into array
	addi	$t9, $t9, 1		# Adds 1 to current cell loop counter
	j	last_cell		# Jump to last_cell (t9 = 2)

# The Last Cell's Right Neighbor(First Cell)
LCRN:
	# Loads input from cells array
	mul	$t7, $zero, 4		# Offset for cells array (s5)
	add	$t7, $s5, $t7		# $t7 = Array($s5) + Offset
	lw	$t5, ($t7)		# Stores the current input into array
	
	# Stores loaded cell into temp array
	add	$t7, $zero, $zero	# Sets t7 back to 0 index
	add	$t7, $s5, $t7		# $t7 = Array($s5) + Offset
	lw	$s3, ($t7)		# Stores the current input into array
	
	mul	$t7, $t9, 4		# Offset for temp array (t7)
	add	$t7, $s6, $t7		# $t5 = Array($s6) + Offset
	sw	$s3, ($t7)		# Stores the current input into array
	addi	$t9, $t9, 1		# Adds 1 to current cell loop counter
	j	last_cell		# Jump to last_cell (t9 = 3)

################################################################################
	
dead_or_alive_check:
	# Starts the check process and adds the correct corresponding number s5
	addi	$t2, $t2, 1			# $t2 = $t1 + 0
	
check_1:
	la	$t6, SeventhBit		# Loads the addr of the SeventhBit Array
	lw	$t8, 0($t6)		# Loads the element from the 0th index
						# of the SeventhBit Array
	lw	$t9, 0($s6)		# Loads the element at the 0th index of
						# the temp array
	bne	$t8, $t9, check_2	# If 0($t6) != 0($s6) then goto check_2

	lw	$t8, 4($t6)		# Loads the element from the 4th index
						# of the SeventhBit Array
	lw	$t9, 4($s6)		# Loads the element at the 4th index of
						# the temp array
	bne	$t8, $t9, check_2	# If 4($t6) != 4($s6) then goto check_2
	
	lw	$t8, 8($t6)		# Loads the element from the 8th index
						# of the SeventhBit Array
	lw	$t9, 8($s6)		# Loads the element at the 8th index of
						# the temp array
	bne	$t8, $t9, check_2	# If 8($t6) != 8($s6) then goto check_2
	
	lw	$t6, 0($s7)		# Loads the word @ the zero index of
						# the binary num array

	addi	$t8, $t2, -1		# Adds -1 to count to start @ index 0
	mul	$t9, $t8, 4		# Offset
	add	$t9, $s4, $t9		# $t9 = Array($s4) + Offset
	sw	$t6, ($t9)		# Stores the current input into array
	j	dead_or_alive_loop	# Jump to dead_or_alive_loop
		
check_2:
	la	$t6, SixthBit		# Loads the addr of the SixthBit Array
	lw	$t8, 0($t6)		# Loads the element from the 0th index
						# of the SixthBit Array
	lw	$t9, 0($s6)		# Loads the element at the 0th index of
						# the temp array
	bne	$t8, $t9, check_3	# If 0($t6) != 0($s6) then goto check_3

	lw	$t8, 4($t6)		# Loads the element from the 4th index
						# of the SixthBit Array
	lw	$t9, 4($s6)		# Loads the element at the 4th index of
						# the temp array
	bne	$t8, $t9, check_3	# If 4($t6) != 4($s6) then goto check_3

	lw	$t8, 8($t6)		# Loads the element from the 8th index
						# of the SixthBit Array
	lw	$t9, 8($s6)		# Loads the element at the 8th index of
						# the temp array
	bne	$t8, $t9, check_3	# If 8($t6) != 8($s6) then goto check_3

	lw	$t6, 4($s7)		# Loads the word @ the 4th index of
						# the binary num array

	addi	$t8, $t2, -1		# Adds -1 to count to start @ index 0
	mul	$t9, $t8, 4		# Offset
	add	$t9, $s4, $t9		# $t9 = Array($s4) + Offset
	sw	$t6, ($t9)		# Stores the current input into array
	j	dead_or_alive_loop	# Jump to dead_or_alive_loop

check_3:
	la	$t6, FifthBit		# Loads the addr of the FifthBit Array
	lw	$t8, 0($t6)		# Loads the element from the 0th index
						# of the FifthBit Array
	lw	$t9, 0($s6)		# Loads the element at the 0th index of
						# the temp array
	bne	$t8, $t9, check_4	# If 0($t6) != 0($s6) then goto check_4

	lw	$t8, 4($t6)		# Loads the element from the 4th index
						# of the FifthBit Array
	lw	$t9, 4($s6)		# Loads the element at the 4th index of
						# the temp array
	bne	$t8, $t9, check_4	# If 4($t6) != 4($s6) then goto check_4

	lw	$t8, 8($t6)		# Loads the element from the 8th index
						# of the FifthBit Array
	lw	$t9, 8($s6)		# Loads the element at the 8th index of
						# the temp array	
	bne	$t8, $t9, check_4	# If 8($t6) != 8($s6) then goto check_4

	lw	$t6, 8($s7)		# Loads the word @ the 8th index of
						# the binary num array

	addi	$t8, $t2, -1	      # Adds -1 to count to start @ index 0
	mul	$t9, $t8, 4		# Offset
	add	$t9, $s4, $t9		# $t9 = Array($s4) + Offset
	sw	$t6, ($t9)		# Stores the current input into array
	j	dead_or_alive_loop	# Jump to dead_or_alive_loop
	
check_4:
	la	$t6, FourthBit		# Loads the addr of the FourthBit Array
	lw	$t8, 0($t6)		# Loads the element from the 0th index
						# of the FourthBit Array
	lw	$t9, 0($s6)		# Loads the element at the 0th index of
						# the temp array
	bne	$t8, $t9, check_5	# If 0($t6) != 0($s6) then goto check_5

	lw	$t8, 4($t6)		# Loads the element from the 4th index
						# of the FourthBit Array
	lw	$t9, 4($s6)		# Loads the element at the 4th index of
						# the temp array
	bne	$t8, $t9, check_5	# If 4($t6) != 4($s6) then goto check_5

	lw	$t8, 8($t6)		# Loads the element from the 8th index
						# of the FourthBit Array
	lw	$t9, 8($s6)		# Loads the element at the 8th index of
						# the temp array		
	bne	$t8, $t9, check_5	# If 8($t6) != 8($s6) then goto check_5

	lw	$t6, 12($s7)		# Loads the word @ the 12th index of
						# the binary num array

	addi	$t8, $t2, -1		# Adds -1 to count to start @ index 0
	mul	$t9, $t8, 4		# Offset
	add	$t9, $s4, $t9		# $t9 = Array($s4) + Offset
	sw	$t6, ($t9)		# Stores the current input into array
	j	dead_or_alive_loop	# Jump to dead_or_alive_loop
	
check_5:
	la	$t6, ThirdBit		# Loads the addr of the ThirdBit Array
	lw	$t8, 0($t6)		# Loads the element from the 0th index
						# of the ThirdBit Array
	lw	$t9, 0($s6)		# Loads the element at the 0th index of
						# the temp array
	bne	$t8, $t9, check_6	# If 0($t6) != 0($s6) then goto check_6

	lw	$t8, 4($t6)		# Loads the element from the 4th index
						# of the ThirdBit Array
	lw	$t9, 4($s6)		# Loads the element at the 4th index of
						# the temp array
	bne	$t8, $t9, check_6	# If 4($t6) != 4($s6) then goto check_6

	lw	$t8, 8($t6)		# Loads the element from the 8th index
						# of the ThirdBit Array
	lw	$t9, 8($s6)		# Loads the element at the 8th index of
						# the temp array		
	bne	$t8, $t9, check_6	# If 8($t6) != 8($s6) then goto check_6

	lw	$t6, 16($s7)		# Loads the word @ the 16th index of
						# the binary num array

	addi	$t8, $t2, -1		# Adds -1 to count to start @ index 0
	mul	$t9, $t8, 4		# Offset
	add	$t9, $s4, $t9		# $t9 = Array($s4) + Offset
	sw	$t6, ($t9)		# Stores the current input into array
	j	dead_or_alive_loop	# Jump to dead_or_alive_loop
	
check_6:	
	la	$t6, SecondBit		# Loads the addr of the SecondBit Array
	lw	$t8, 0($t6)		# Loads the element from the 0th index
						# of the SecondBit Array
	lw	$t9, 0($s6)		# Loads the element at the 0th index of
						# the temp array		
	bne	$t8, $t9, check_7	# If 0($t6) != 0($s6) then goto check_7

	lw	$t8, 4($t6)		# Loads the element from the 4th index
						# of the SecondBit Array
	lw	$t9, 4($s6)		# Loads the element at the 4th index of
						# the temp array
	bne	$t8, $t9, check_7	# If 4($t6) != 4($s6) then goto check_7

	lw	$t8, 8($t6)		# Loads the element from the 8th index
						# of the SecondBit Array
	lw	$t9, 8($s6)		# Loads the element at the 8th index of
						# the temp array	
	bne	$t8, $t9, check_7	# If 8($t6) != 8($s6) then goto check_7

	lw	$t6, 20($s7)		# Loads the word @ the 20th index of
						# the binary num array
				
	addi	$t8, $t2, -1		# Adds -1 to count to start @ index 0
	mul	$t9, $t8, 4		# Offset
	add	$t9, $s4, $t9		# $t9 = Array($s4) + Offset
	sw	$t6, ($t9)		# Stores the current input into array
	j	dead_or_alive_loop	# Jump to dead_or_alive_loop
	
check_7:
	la	$t6, FirstBit		# Loads the addr of the FirstBit Array
	lw	$t8, 0($t6)		# Loads the element from the 0th index
						# of the FirstBit Array
	lw	$t9, 0($s6)		# Loads the element at the 0th index of
						# the temp array
	bne	$t8, $t9, check_8	# If 0($t6) != 0($s6) then goto check_8

	lw	$t8, 4($t6)		# Loads the element from the 4th index
						# of the FirstBit Array
	lw	$t9, 4($s6)		# Loads the element at the 4th index of
						# the temp array
	bne	$t8, $t9, check_8	# If 4($t6) != 4($s6) then goto check_8

	lw	$t8, 8($t6)		# Loads the element from the 8th index
						# of the FirstBit Array
	lw	$t9, 8($s6)		# Loads the element at the 8th index of
						# the temp array		
	bne	$t8, $t9, check_8	# If 8($t6) != 8($s6) then goto check_8

	lw	$t6, 24($s7)		# Loads the word @ the 24th index of
						# the binary num array

	addi	$t8, $t2, -1		# Adds -1 to count to start @ index 0
	mul	$t9, $t8, 4		# Offset
	add	$t9, $s4, $t9		# $t9 = Array($s4) + Offset
	sw	$t6, ($t9)		# Stores the current input into array
	j	dead_or_alive_loop	# Jump to dead_or_alive_loop
	
check_8:
	la	$t6, ZeroBit		# Loads the addr of the ZeroBit Array
	lw	$t8, 0($t6)		# Loads the element from the 0th index
						# of the FirstBit Array
	lw	$t9, 0($s6)		# Loads the element at the 0th index of
						# the temp array
	bne	$t8, $t9, check_1	# If 0($t6) != 0($s6) then goto check_1

	lw	$t8, 4($t6)		# Loads the element from the 4th index
						# of the ZeroBit Array
	lw	$t9, 4($s6)		# Loads the element at the 4th index of
						# the temp array
	bne	$t8, $t9, check_1	# If 4($t6) != 4($s6) then goto check_1

	lw	$t8, 8($t6)		# Loads the element from the 8th index
						# of the ZeroBit Array
	lw	$t9, 8($s6)		# Loads the element at the 8th index of
						# the temp array		
	bne	$t8, $t9, check_1	# If 8($t6) != 8($s6) then goto check_1

	lw	$t6, 28($s7)		# Loads the word @ the 28th index of
						# the binary num array

	addi	$t8, $t2, -1		# Adds -1 to count to start @ index 0
	mul	$t9, $t8, 4		# Offset
	add	$t9, $s4, $t9		# $t9 = Array($s4) + Offset
	sw	$t6, ($t9)		# Stores the current input into array
	j	dead_or_alive_loop	# Jump to dead_or_alive_loop
	