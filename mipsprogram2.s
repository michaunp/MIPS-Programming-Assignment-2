.data
	buffer: .space 1001
	
.text
	
main:
	li $v0,8        #take in input
	la $a0,buffer   #load argument with byte space
	li $a1,9        #allot byte space for string
	add $s0,$zero,$a0  #load user input into register
	syscall