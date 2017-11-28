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
	addi $t4,$zero,10 #load newline value into a temporary register
	addi $t0,$t0,44 #load register with the ascii value of a comma

count_string_loop:
	lb $t5,0($t3) #load first byte of string
	beq $t4,$t5,count_string_exit   #checks to see if it is the end of the string
	beq $zero,$t5,count_string_exit  #checks to see if it is the end of the string
	addi $t6,$t6,1 #increment character counter and store it in register
	addi $t3,$t3,1 #change current byte, at the end of loop length of string is stored in $t6
	j count_string_loop
count_string_exit:
	
	move $t3,$zero #initialize register with zero
	move $t5,$zero #initialize register with zero
	add $t3,$zero,$s0 #put value of string into register
loop:
	jal validate_substr #calls validate substring subprogram, returns substring
	beq $t4,$t5,loop_exit #checks to see if it is the end of the string, exits if equal
	beq $zero,$t5,loop_exit #checks to see if it is the end of the string, exits if equal	
    beq $t5,44,call_prog3  #if character is a comma, it jumps to program3 call
    jal subprogram_2 #calls subprogram2 if character is not a comma
call_prog3:
	jal subprogram_3 #calls subprogram3



loop_exit:
	
	
end:
	li $v0,10                     #end program     
	syscall

invalid:
	la $a0,str2                  #load argument with invalid string
	li $v0,4                     #load with code to print a string
	syscall
	j end	
	
	
	
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
	j $ra  #jumps to return address

check_uppercase:
	addi $t2,$t1,-55   #convert A-F ascii to 10-15 hex
	j $ra  #jumps to return address

check_lowercase:
	addi $t2,$t1,-87     #convert a-f ascii to 10-15 hex
	j $ra  #jumps to return address


#converts a hexadecimal string to a decimal integer by calling
#subprogram1 in a loop and adding it to a total sum
#still need to implement loop that calls subprogram1, terminating condition is a comma character or over 8 characters 
subprogram_2:
	sll $t7,$t7,4
	add $t7,$t7,$t2
	
	addi $t0,$t0,1                #increments $t0 by one to point to next element in the string
	addi $t8,$t8,-1               #decrement index by 1
	addi $t3,$t3,-4               #decrement shift amount by four
	j subprogram2_end                        #jumps back to beginning of loop


#displays an unsigned decimal integer
subprogram_3:











#this subprogram checks the validity of a substring
validate_substr:
	move $t9,$zero #initializes a new register with zero that will hold the substring
	move $s1,$zero #initializes a register with zero to act as a counter
	
substr_loop:
	lb $t5,0($t3) #load first byte of string
	
	

	


	
