.data
	displayAddress: .word 0x10008000
	
.text
main:
	lw $t0, displayAddress # loading the bitmap display adress
	li $t4, 0xffffff # white
	
	li $t5, 0
	
	jal fillWhite
	lw $t0, displayAddress
	li $v0, 1       # Set syscall code for printing integer (1)
    	li $a0, 2       # Load the integer value 1 into register $a0
    	syscall         # Execute the syscall	
    	lw $t0, displayAddress
    	jal fillGrid
    	li $v0, 1       # Set syscall code for printing integer (1)
    	li $a0, 3       # Load the integer value 1 into register $a0
    	syscall         # Execute the syscall	
    	li $t2, 0x31    # ASCII value for '1' in hex
    	li $t3, 0x32    # ASCII value for '2' in hex
    	li $t4, 0x33
    	li $t5, 0x34
    	li $t6, 0x35
    	li $t7, 0x36
    	li $s0, 0x37
    	li $s1, 0x38
    	li $s2, 0x39
 gameLoop:   	
    	jal waitForKey
    	
    	move $t1, $v0
    	
    	
    	
    	
    	# Check if the value in $t1 matches any of the numbers
    	beq $t1, $t2, handle_num7
    	beq $t1, $t3, handle_num8
    	beq $t1, $t4, handle_num9
    	beq $t1, $t5, handle_num4
    	beq $t1, $t6, handle_num5
    	beq $t1, $t7, handle_num6
    	beq $t1, $s0, handle_num1
    	beq $t1, $s1, handle_num2
    	beq $t1, $s2, handle_num3
    	
	j Exit
	
	
handle_num1:
	lw $s7, displayAddress
	li $t8, 0
	addi $a0, $zero, 656
	jal drawX
	j gameLoop
	
handle_num2:
	lw $s7, displayAddress
	li $t8, 0
	addi $a0, $0, 572
	jal drawO
	j gameLoop
handle_num3:
	lw $s7, displayAddress
	li $t8, 0
	sw $t8, 616($s7)
	j gameLoop
handle_num4:
	lw $s7, displayAddress
	li $t8, 0
	sw $t8, 1936($s7)
	j gameLoop	
handle_num5:
	lw $s7, displayAddress
	li $t8, 0
	sw $t8, 1980($s7)
	j gameLoop
handle_num6:
	lw $s7, displayAddress
	li $t8, 0
	sw $t8, 2024($s7)
	j gameLoop
handle_num7:
	lw $s7, displayAddress
	li $t8, 0
	sw $t8, 3344($s7)
	j gameLoop	
handle_num8:
	lw $s7, displayAddress
	li $t8, 0
	sw $t8, 3388($s7)
	j gameLoop
handle_num9:
	lw $s7, displayAddress
	li $t8, 0
	sw $t8, 3432($s7)
	j gameLoop
fillWhite:
    # Save registers to the stack
    addiu $sp, $sp, -24 # Allocate space on the stack
    sw $ra, 20($sp)     # Save return address
    sw $t0, 16($sp)     # Save $t0
    sw $t2, 12($sp)     # Save $t2
    sw $t4, 8($sp)      # Save $t4
    sw $t5, 4($sp)      # Save $t5

    sw $t4, 0($t0)
    addiu $t0, $t0, 4
    addiu $t2, $t2, 1
    li $t5, 1024
    blt $t2, $t5, fillWhite

    # Restore registers from the stack
    lw $t5, 4($sp)      # Restore $t5
    lw $t4, 8($sp)      # Restore $t4
    lw $t2, 12($sp)     # Restore $t2
    lw $t0, 16($sp)     # Restore $t0
    lw $ra, 20($sp)     # Restore return address
    addiu $sp, $sp, 24  # Deallocate space on the stack

    jr $ra

	
fillGrid:
    # Save registers to the stack
    
    addi $sp, $sp, -24   # Allocate space on the stack
    sw $ra, 20($sp)      # Save return address
    sw $t0, 16($sp)      # Save $t0
    sw $t2, 12($sp)      # Save $t2
    sw $t3, 8($sp)       # Save $t3
    sw $t7, 4($sp)       # Save $t7
    

    move $t3, $zero
    addi $t0, $t0, 1280
    

    jal fillRows
    li $v0, 1           # Set syscall code for printing integer (1)
    li $a0, 4           # Load the integer value 1 into register $a0
    syscall             # Execute the syscall
    
    move $t2, $zero
    
    li $t2, 0
    
    #sw $fp, 20($sp)
    jal fillColumns 
    #lw $fp, 20($sp)
	
    # Restore registers from the stack
    lw $t7, 4($sp)      # Restore $t7
    lw $t3, 8($sp)      # Restore $t3
    lw $t2, 12($sp)     # Restore $t2
    lw $t0, 16($sp)     # Restore $t0
    lw $ra, 20($sp)     # Restore return address
    addi $sp, $sp, 24   # Deallocate space on the stack
    li $v0, 1           # Set syscall code for printing integer (1)
    li $a0, 5           # Load the integer value 1 into register $a0
    syscall             # Execute the syscall
	
    jr $ra
    
drawX:
	addi $sp, $sp, -12
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $t0, 8($sp)
	
	
	
	lw $t1, displayAddress
	li $t8, 0x2ba2ca
	add $t1, $a0, $t1
	subi $t1, $t1, 396
	
	addi $t0, $0, 6
	
firstDiag:
	sw $t8, 0($t1)
	sw $t8, 4($t1)
	subi $t0, $t0, 1
	addi $t1, $t1, 132
	bnez $t0 firstDiag

	addi $t0, $0, 6
	subi $t1, $t1 768
secondDiag:
	sw $t8, 0($t1)
	sw $t8, -4($t1)
	subi $t0, $t0, 1
	addi $t1, $t1, 124
	bnez $t0 secondDiag
	
	lw $t0, 8($sp)
	lw $t2, 4($sp)
	lw $t1, 0($sp)
	addi $sp, $sp, 12
	jr $ra
	
drawO:
	addi $sp, $sp, -12
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $t0, 8($sp)
	
	lw $t1, displayAddress
	li $t8, 0x880808
	add $t1, $a0, $t1
	subi $t1, $t1, 252
	sw $t8, 0($t1)
	sw $t8, -4($t1)
	sw $t8, -8($t1)
	sw $t8, 116($t1)
	sw $t8, 244($t1)
	sw $t8, 372($t1)
	sw $t8, 500($t1)
	sw $t8, 632($t1)
	sw $t8, 636($t1)
	sw $t8, 640($t1)
	sw $t8, 516($t1)
	sw $t8, 388($t1)
	sw $t8, 260($t1)
	sw $t8, 132($t1)
	
	lw $t0, 8($sp)
	lw $t2, 4($sp)
	lw $t1, 0($sp)
	addi $sp, $sp, 12
	jr $ra
waitForKey:


    lw $t0, 0xffff0000        # Load Receiver Control register into $t0
    andi $t0, $t0, 0x1        # Isolate Ready bit (bit 0)
    beq $t0, $zero, waitForKey # If Ready bit is 0, keep waiting

    lw $v0, 0xffff0004        # Load Receiver Data register into $v0 (new keystroke)



    jr $ra
	
fillRows:
    # Save registers to the stack
    addi $sp, $sp, -20  # Allocate space on the stack
    sw $ra, 0($sp)      # Save return address
    sw $t0, 4($sp)      # Save $t0
    sw $t3, 8($sp)      # Save $t3
    sw $t5, 12($sp)       # Save $t5
    sw $t6, 16($sp)       # Save $t6
firstRow:
    sw $t5, 0($t0)
    addiu $t0, $t0, 4
    addiu $t3, $t3, 1
    li $t6, 32
    blt $t3, $t6, firstRow
    move $t3, $zero
    addi $t0, $t0, 1280
secondRowLoop:
    sw $t5, 0($t0)
    addiu $t0, $t0, 4
    addiu $t3, $t3, 1
    blt $t3, $t6, secondRowLoop

    # Restore registers from the stack
    lw $t6, 16($sp)       # Restore $t6
    lw $t5, 12($sp)       # Restore $t5
    lw $t3, 8($sp)      # Restore $t3
    lw $t0, 4($sp)      # Restore $t0
    lw $ra, 0($sp)      # Restore return address
    addi $sp, $sp, 20   # Deallocate space on the stack

    jr $ra

fillColumns:
    # Save registers to the stack
    lw $t0, displayAddress
    addiu $sp, $sp, -24  # Allocate space on the stack
    sw $ra, 20($sp)      # Save return address
    sw $t0, 16($sp)      # Save $t0
    sw $t3, 12($sp)      # Save $t3
    sw $t5, 8($sp)       # Save $t5
    sw $t6, 4($sp)       # Save $t6

    # First horizontal line
    addi $t0, $t0, 40
    move $t3, $zero
    addi $t6, $zero, 32 
    
  
firstCol:
	sw $t5, 0($t0)
	addi $t3, $t3, 1
	addi $t0, $t0, 128
	blt $t3, $t6, firstCol
	lw $t0, displayAddress
	addi $t0, $t0, 80
	move $t3, $zero
secondCol:
	sw $t5, 0($t0)
	addi $t3, $t3, 1
	addi $t0, $t0, 128
	blt $t3, $t6, secondCol
	


    # Restore registers from the stack
    lw $t6, 4($sp)       # Restore $t6
    lw $t5, 8($sp)       # Restore $t5
    lw $t3, 12($sp)      # Restore $t3
    lw $t0, 16($sp)      # Restore $t0
    lw $ra, 20($sp)      # Restore return address
    addiu $sp, $sp, 24   # Deallocate space on the stack

    jr $ra
    




# exit the program	
Exit: 
	li $v0, 10
	syscall
