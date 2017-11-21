.data
	buffer: .space 1001
	
.text
	
main:
	li $v0,8        #take in input
	la $a0,buffer   #load argument with byte space
	li $a1,9        #allot byte space for string
	add $s0,$zero,$a0  #load user input into register
	syscall
	count_string_loop:
	lb $t5,0($t3) #load first byte of string
	beq $t4,$t5,count_string_exit   #checks to see if it is the end of the string
	beq $zero,$t5,count_string_exit  #checks to see if it is the end of the string
	addi $t6,$t6,1 #increment character counter and store it in register
	addi $t3,$t3,1 #change current byte, at the end of loop length of string is stored in $t6
	j count_string_loop
count_string_exit:
	