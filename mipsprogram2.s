.data
	buffer: .space 1001
	str1: .asciiz "NaN"
	str2: .asciiz ","
	str3: .asciiz "too large"
.text
	
main:
	li $v0,8        #take in input
	la $a0,buffer   #load argument with byte space
	li $a1,1001        #allot byte space for string
	add $s0,$zero,$a0  #load user input into register
	syscall
	
	move $t3,$zero #initialize register with zero
	move $t5,$zero #initialize register with zero
	add $t3,$zero,$s0 #put value of string into register
loop:
	move $t4,$zero #clears contents of register $t4
	jal validate_substr #calls validate substring subprogram, returns substring
	add $t4,$v0,$zero #puts return value of validate_substr in a register
	beq $t4,$zero,loop #substring wasn't a number, jumps to check next substring
	beq $t4,24,loop #substring was too large, jumps to check next substring
	add $a0,$t4,$zero #put parameter for subprogram2 in argument register
    jal subprogram_2 #calls subprogram2
    lw $s2,4($sp) #read subprogram2 value from stack
    beq $s2,$zero,not_num #branches if string wasn't a number
	beq $t5,10,loop_exit #checks to see if it is the end of the string, exits if equal
	beq $zero,$t5,loop_exit #checks to see if it is the end of the string, exits if equal
call_prog3:
	sw $s2,0($sp) #load subprogram3 parameters using stack
	jal subprogram_3 #calls subprogram3
	j loop #loops to check next substring
not_num:
	beq $t5,44,loop #loops to check next substring if string wasn't valid
loop_exit:
		
end:
	li $v0,10                     #end program     
	syscall

invalid:
	la $a0,str2                  #load argument with invalid string
	li $v0,4                     #load with code to print a string
	syscall
	jr $ra	                     #jumps to return address
	
	
	
subprogram_1:
	move $t2,$zero #initializes register 2 to zero
	blt $t1,48,invalid #checks if character is less than 48, branches to invalid section if true
	blt $t1,58,check_num #goes to get value of char since it's valid
	blt $t1,65,invalid #checks if character is less than 65, branches to invalid section if true
	blt $t1,71,check_uppercase #goes to get value of char since it's valid
	blt $t1,97,invalid #checks if character is less than 97, branches to invalid section if true
	blt $t1,103,check_lowercase #goes to get value of char since it's valid
	j invalid
	
#converts character to its decimal value
check_num:
	addi $t2,$t1,-48  #convert 0-9 ascii to 0-9 hex
	jr $ra  #jumps to return address

check_uppercase:
	addi $t2,$t1,-55   #convert A-F ascii to 10-15 hex
	jr $ra  #jumps to return address

check_lowercase:
	addi $t2,$t1,-87     #convert a-f ascii to 10-15 hex
	jr $ra  #jumps to return address


#converts a hexadecimal string to a decimal integer by calling
#subprogram1 in a loop and adding it to a total sum
#still need to implement loop that calls subprogram1, terminating condition is a comma character or over 8 characters 
subprogram_2:
	add $t6,$v0,$zero             #copy parameter with substring into $t6
	move $t7,$zero                #initialize sum register
sum_loop:
	lb $s3,0($t2)                 #load first character into $s3
	move $a0,$zero                #initialize argument register
	add $a0,$zero,$s3             #put first character in argument register
	jal subprogram_1              #call subprogram_1
	add $t2,$v0,$zero             #reading return value from function
	
	#need to add a condition for checking if character was invalid
	sll $t7,$t7,4
	add $t7,$t7,$t2
	
	addi $t0,$t0,1                #increments $t0 by one to point to next element in the string
	addi $t8,$t8,-1               #decrement index by 1
	addi $t3,$t3,-4               #decrement shift amount by four
	jr $ra                        #jumps back to beginning of loop




#displays an unsigned decimal integer
subprogram_3:
#have condition that checks if output is 8 characters, if so does special output
#otherwise just prints unsigned integer and checks to see whether next character in the string is the last character











#this subprogram checks the validity of a substring returns substring if spacing is correct, otherwise jumps to invalid function
validate_substr:
	move $t9,$zero #initializes a new register with zero that will hold the substring
	move $s1,$zero #initializes a register with zero to act as a counter
	sw $ra,0($t0) #store the return address in a register
	
substr_loop:
	lb $t5,0($t3) #load first byte of string
	beq $t5,44,validate_exit #exits loop if character is a comma
	beq $t5,10,end #exits program if character is new line
	beq $t5,$zero,end #exits program if character is null
	beq $t5,32,ignore_space #if character is a leading space ignore it and branch to ignore space
	beq $t5,9,ignore_space #if character is a leading tab ignore it and branch to ignore space
    jal read_chars #calls read_chars subprogram

validate_exit:
	add $v0,$t9,$zero #put return string in return register
	move $ra,$zero #clear return address
	lw $ra,0($t0) #put correct return address in $ra
	jr $ra #return from function
	
ignore_space:
	addi $t3,$t3,1 #change current byte to next byte of string
	j substr_loop #jumps to beginning of loop	

read_chars:
	sw $ra,4($t0) #store return address in a register
read_loop:
	bge $s1,9,call_invalid_large #branches to call invalid subprogram instruction if substring greater than 8 characters
	beq $t5,32,check_rem #checks if remaining characters are tabs or spaces
	beq $t5,9,check_rem #checks if remaining characters are tabs or spaces
	beq $t5,44,read_loop_exit #exits loop if character is a comma
	sb $t5,0($t9) #adds character to the new substring
	addi $s1,$s1,1 #increments counter
    addi $t9,$t9,1 #changes current byte to next byte	
    addi $t3,$t3,1 #changes current byte of string to next byte
    lb $t5,0($t3) #loads the next byte into register $t5
    j read_loop #loops to check next byte
read_loop_exit:
	move $ra,$zero #clear return address
	lw $ra,4($t0) #load correct return address 
	jr $ra #jump return


check_rem:
	addi $t3,$t3,1 #change current byte
	lb $t5,0($t3) #load byte
	beq $t5,32,check_rem #checks if remaining characters are tabs or spaces
	beq $t5,9,check_rem #checks if remaining characters are tabs or spaces
	beq $t5,44,read_loop_exit #exits loop if character is a comma
	move $t9,$zero #clears substring
	move $a0,$zero #clears argument register
	add $a0,$t9,$zero #puts contents of $t9 in $a0
	jal invalid
	j read_loop_exit

call_invalid_large:
	move $t9,$zero #clear all contents of register
	addi $t9,$t9,24 #load with arbitrary number that will signify that string is too large
	jal invalid #calls invalid subprogram
ignore_rest:
	lb $t5,0($t3) #load byte in string
	beq $t5,44,validate_exit  #jumps to end of validate substring subprogram if character is a comma
	beq $t5,10,validate_exit  #jumps to end of validate substring subprogram if character is a new line
	beq $t5,$zero,validate_exit  #jumps to end of validate substring subprogram if character is null

	
	
	
	
	
	
	
	
