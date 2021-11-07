
.data 0x10000000  #first address to start from for convenience
Astr: .word 2000

.data 0x10001000 #first address to start from for convenience
Bstr: .word 2000
A: .asciiz "mat1.txt"         #name of the file
msgA: .asciiz "\nMATRIX_A\n"  #name of the matrix before printing
B: .asciiz "mat2.txt"         #name of the file
msgB: .asciiz "\nMATRIX_B\n"  #name of the matrix before printing

.data 0x10002000 #first address to start from for convenience
count: .word 4 

.data 0x10003000  #first address to start from for convenience
C: .asciiz "mat3.txt"  #name of the file we will create
msgC: .asciiz "\nMATRIX_C\n"  #name of the matrix before printing
words: .space 2000


.text

###############################################################
############################################################
#matrix A

#print the sring msgA
#print a message
li $v0,4
la $a0,msgA
syscall


#allocation memory for file mat1.txt
#and # space for 100 integers for matrix_A
li $t1,10
li $t2,10
mul $a0,$t1,$t2
sll $a0,$a0,2  #mult by 4
li $v0,9 # syscall 9 - allocate heap memory
syscall #if $v0!=0 than the alloction succeeded
move $s0,$v0 #move the adrress of tha allocation of $v0 to $s0 for matrix_A


#open file:
li $v0, 13  #open file syscall 13
la $a0, A   #get the file name of matrix_A
li $a1, 0   #read file
li $a2,0
syscall
move $a0 $v0 #save the file descriptor $a0= matrix_A 


#read from file:
li $v0 14    #read file syscall 14
la $a1 Astr  #the buffer that holds the string of the whole file
la $a2 400  #the length of the code 
syscall
move $t4,$v0 #file descriptor


#close the file
li $v0,16  #close the file syscall 16
move $a0,$s0 #file descriptor to close
syscall


#print whats in the file
li $v0,4
la $a0,Astr
syscall


#counters to #reset
move $t5,$zero #counter addres
move $t6,$zero #counter addres
move $t9,$zero
la $t5,($s0)


#loops that check if we finished read all the data in the file 
loopA2:
beq $t4,$t6,matrix_B  #if we finished the mat1 file we move to read mat2 file
lb $t8,Astr($t6)
addi $t6,$t6,1
beq  $t8,32,digit_in_num  #check how many digits in the number
beq  $t8,10,loopA2  
sb $t8,count($t9) 
addi $t9,$t9,4
j loopA2


#functions to check how many digits in the number 
digit_in_num:
move $t0,$zero
beq $t9,16,four_digitsA  #jump to 4 digits check
beq $t9,12,three_digitsA #jump to 3 digits check
beq $t9,8,two_digitsA    #jump to 2 digits check
j one_digitA             #jump to 1 digits check


four_digitsA:      #for 4 digits
lb $t1,count       #load 0(count) to t1
subi $t1,$t1,48    #char to int
mul $t1,$t1,1000  
lb $t2,count+4     #load 4(count) to t2
subi $t2,$t2,48    #char to int
mul $t2,$t2,100
lb $t3,count+8     #load 8(count) to t3
subi $t3,$t3,48    #char to int
mul $t3,$t3,10
lb $t0,count+12    #load 12(count) to t0
subi $t0,$t0,48    #char to int
mul $t0,$t0,1
add $t0,$t0,$t1    #add to t0 whats in t1 and t0
add $t0,$t0,$t3    #add to t0 whats in t3 and t0
add $t0,$t0,$t2    #add to t0 whats in t2 and t0
j loopA1


three_digitsA:     #for 3 digits
lb $t1,count       #load 0(count) to t1
subi $t1,$t1,48    #char to int
mul $t1,$t1,100
lb $t2,count+4     #load 4(count) to t2
subi $t2,$t2,48    #char to int
mul $t2,$t2,10
lb $t3,count+8     #load 8(count) to t3
subi $t3,$t3,48    #char to int
mul $t3,$t3,1
add $t0,$t2,$t1    #add to t0 whats in t1 and t2
add $t0,$t0,$t3    #add to t0 whats in t0 and t3
j loopA1


two_digitsA:
lb $t2,count       #load 0(count) to t2
subi $t2,$t2,48    #char to int
mul $t2,$t2,10
lb $t3,count+4     #load 4(count) to t3
subi $t3,$t3,48    #char to int
add $t0,$t3,$t2    #add to t0 whats in t3 and t2
j loopA1


one_digitA:
lb $t3,count       #load 12(count) to t3
subi $t3,$t3,48    #char to int
add $t0,$t0,$t3    #add to t0 whats in t0 and t3

#loop to store the numbers to place in memory for matrix_A 
#loop for matrix A
loopA1:
sw $t0,0($t5)  
addi $t5,$t5,4  #push the stack
addi $t9,$zero,0
j loopA2


##################################################################
#matrix B


matrix_B:
#allocation memory for file mat2.txt
#and # space for 100 integers for matrix_B
li $t1,10
li $t2,10
mul $a0,$t1,$t2
sll $a0,$a0,2  #mult by 4
li $v0,9 # syscall 9 - allocate heap memory
syscall #if $v0!=0 than the alloction succeeded
move $s1,$v0 #move the adrress of tha allocation of $v0 to $s0 for matrix_A


#print the sring msgA
#print a message
li $v0,4
la $a0,msgB
syscall


#open file:
li $v0, 13  #open file syscall 13
la $a0, B   #get the file name of matrix_A
li $a1, 0   #read file
li $a2, 0
syscall
move $a0 $v0 #save the file descriptor $s0= matrix_A 


#read from file:
li $v0 14    #read file syscall 14
la $a1 Bstr  #the buffer that holds the string of the whole file
la $a2 400  #the length of the code 
syscall
move $t4 $v0  #file descriptor


#print whats in the file
li $v0,4 
la $a0, Bstr
syscall


#close the file
li $v0,16  #close the file syscall 16
syscall


#counters to reset
move $t5,$zero 
move $t6,$zero 
move $t9,$zero
la $t5,($s1)


#loop that check if we finished read all the data in the file 
loopB2:
# if we finished the mat2 file we move to multipliction matrixA with matrixB
beq $t4,$t6,matrix_multipliction 
lb $t8,Bstr($t6)
addi $t6,$t6,1
beq  $t8,32,digit_in_numB  #check how many digits in the number
beq  $t8,10,loopB2  
sb $t8,count($t9) 
addi $t9,$t9,4
j loopB2


#functions to check how many digits in the number 
digit_in_numB:
move $t0,$zero
beq $t9,16,four_digitsB  #jump to 4 digits check
beq $t9,12,three_digitsB #jump to 3 digits check
beq $t9,8,two_digitsB    #jump to 2 digits check
j one_digitB             #jump to 1 digits check


four_digitsB:    #for 4 digits for matrix B
lb $t1,count     #load 0(count) to t1
subi $t1,$t1,48  #char to int
mul $t1,$t1,1000
lb $t2,count+4   #load 4(count) to t2
subi $t2,$t2,48  #char to int
mul $t2,$t2,100
lb $t3,count+8   #load 8(count) to t3
subi $t3,$t3,48  #char to int
mul $t3,$t3,10
lb $t0,count+12  #load 12(count) to t0
subi $t0,$t0,48  #char to int
mul $t0,$t0,1
add $t0,$t0,$t1  #add to t0 whats in t0 and t1
add $t0,$t0,$t3  #add to t0 whats in t0 and t3
add $t0,$t0,$t2  #add to t0 whats in t0 and t2
j loopB1


three_digitsB:   #for 3 digits for matrix B
lb $t1,count     #load 0(count) to t1
subi $t1,$t1,48  #char to int
mul $t1,$t1,100
lb $t2,count+4   #load 4(count) to t2
subi $t2,$t2,48  #char to int
mul $t2,$t2,10
lb $t3,count+8   #load 8(count) to t3
subi $t3,$t3,48  #char to int
mul $t3,$t3,1
add $t0,$t2,$t1  #add to t0 whats in t2 and t1
add $t0,$t0,$t3  #add to t0 whats in t0 and t3
j loopB1


two_digitsB:     #for 2 digits for matrix B
lb $t2,count     #load 0(count) to t2
subi $t2,$t2,48  #char to int
mul $t2,$t2,10
lb $t3,count+4   #load 4(count) to t3
subi $t3,$t3,48  #char to int
add $t0,$t3,$t2  #add to t0 whats in t3 and t2
j loopB1


one_digitB:      #for 1 digit for matrix B
lb $t3,count     #load 0(count) to t3
subi $t3,$t3,48  #char to int
add $t0,$t0,$t3  #add to t0 whats in t0 and t3


#loop to store the numbers to place in memory for matrix_B
#loop for matrix B
loopB1:
sw $t0,0($t5)  
addi $t5,$t5,4  #push the stack
addi $t9,$zero,0
j loopB2



#matrix C= (matrixA)*(matrixB)
matrix_multipliction:

#allocation memory for file mat1.txt
#and # space for 100 integers for matrix_A
li $t1,10
li $t2,10
mul $a0,$t1,$t2
sll $a0,$a0,2  #mult by 4
li $v0,9 # syscall 9 - allocate heap memory
syscall #if $v0!=0 than the alloction succeeded
move $s2,$v0 #move the adrress of tha allocation of $v0 to $s0 for matrix_A

#print the sring msgA
#print a message
li $v0,4
la $a0,msgC
syscall

#counters to #reset
move $t5,$zero
move $t8,$zero

la $t2,($s0)  #add the addres of matrix A from s0 to t2
la $t3,($s1)  #add the addres of matrix B from s0 to t3
la $t4,($s2)  #add the addres of matrix C from s0 to t4


loop: #this loop will multiplicte matrixA with matrixB
beq $t9,1000,int_to_str #if $t9=1000 is the end of the matrix
                        #(1000 times multipliction)
beq $t5,100,store_num1    #to know when i finishet on line
beq $t8,10,store_num2     #to know when i finished one cell
lw $t0,0($t2)           #load the first cell of matrix A
lw $t1,0($t3)           #load the first cell of matrix B
mul $t6,$t0,$t1         #multiplicte the cells 
add $t7,$t7,$t6        #add to t7 the multiplicte answer
addi $t9,$t9,1       #add 1 to t9 for the next check
addi $t8,$t8,1       #add 1 to t8 for the next check
addi $t5,$t5,1       #add 1 to t5 for the next check
addi $t2,$t2,4     #add 4 to t2 for nove to the next cell(the next cullom)
addi $t3,$t3,40    #down one line any time we do multipliction
j loop  


#################################3
#store numbers in memory
store_num2:
sw $t7,0($t4)   #store $t7 in the address of $t4+0
addi $t4,$t4,4  #push the stack
move $t8,$zero  #make t8 to zero for count the cells in the next cullom
move $t7,$zero  #t7=0 for new number in each multipliction
subi $t2,$t2,40    #back to the start for the next operation(move by culloms)
subi $t3,$t3,400   #back to the start for the next operation(move by lines)
addi $t3,$t3,4     #moe to the next cullom
j loop
sw 


store_num1:
sw $t7,0($t4) #store $t7 in the address of $t4+0
addi $t4,$t4,4  #push the stack
move $t5,$zero 
move $t7,$zero #t7=0 for new number in each multipliction
move $t8,$zero #make t8 to zero for count the cells in the next cullom
subi $t3,$t3,440   #we are at the last cell of the matrix and goes back to start
j loop
#######################################


#change int to str for 
int_to_str:
move $t0,$zero  #move zero to t0
move $t2,$zero #move zero to t2
la $t3,($s2)  #load to t3 the first address of s2(the new matrix)
move $t5,$zero #move zero to t5 
move $t6,$zero  #move zero to t6 
move $t8,$zero #move zero to t8 
addi $t9,$zero,10  #add 10 to t9 to reset

##############################################################
##############################################################

run_the_matrix_C:
beq $t5,100,end      #if $s5=100 then the matrix finished jump to the function end
beq $t6,10,new_line  #if $t6=10 then the line finished, jump to function new_line 
lw $t4,0($t3)        #load the first int
addi $t3,$t3,4       #push the stack
addi $t5,$t5,1       # add 1 to t5 for the next cell in the matrix
addi $t6,$t6,1       # add 1 to t6 for the next line un the matrix
j num_checking       #jump to function num_checking 


num_checking:
div $t4,$t9   #division between t4 and t9
mflo $t4     #return the answer of t4/t9
mfhi $s4   #return the answer of t4%t9
beq $t4,0,space  #when t4 =0 than we are in the last digits and we need space
addi $s4,$s4,48  #convet int to char
sb $s4,words($t8) # store in to the stack
addi $t8,$t8,1  #push stack with one cell of char
j num_checking


space:
addi $t4,$t4,32 #add space
addi $s4,$s4,48  #convet int to char
sb $s4,words($t8) # store t4 in to the stack
addi $t8,$t8,1  #push stack with one cell of char
sb $t4,words($t8) # store t4 in to the stack
addi $t8,$t8,1  #push stack with one cell of char
j run_the_matrix_C

 
new_line:
addi $t7,$zero,10   #10=\n in ascii
sb $t7,words($t8) # store t7 in to the stack
addi $t8,$t8,1 #push stack with one cell of char
move $t6,$zero   #make t6 to zero 
                 #for the next line count in run_the_matrix_C fuction
j run_the_matrix_C


end:
#open file:
li $v0, 13  #open file syscall 13
la $a0, C   #get the file name of matrix_A
li $a1, 1   #read file
li $a2, 0
syscall

move $a0,$v0 #save the file descriptor $a0= matrix_A 
li $v0, 15 #write file
la $a1,words
li $a2, 2000
syscall



li $v0,4 
la $a0, words
syscall

#close the file
li $v0,16  #close the file syscall 16
syscall


li $v0,10
syscall


