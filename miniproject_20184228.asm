#MINIPROJECT 10
.data 
	Message: 	.asciiz "Enter integer number : " #Store the string in Data segment and add null terminator
	Message1:	.asciiz "The input integer number is :"
	Message2:	.asciiz "Input data cannot be correctly parsed or No data had been input into field! "
	result: 	.asciiz "i \t Power(2,i) \t Square(i) \t Hexadecimal(i)\n"
	asn:		.asciiz " \t "
	asn2:		.asciiz " \t \t "
	over:		.asciiz "overflowed result"
	asn3:		.asciiz	"1/"
	
.text
main:
	jal	get_integer				# input
	nop
	jal	skip					# bao lai so vua nhap 
	nop
	jal	power					# tinh power roi luu vao $s1
	nop
	jal	square					# tinh square roi luu vao $s2
	nop
	jal	done					# output
	nop
	li	$v0,10			# service 10 is exit
	syscall
	
get_integer:
	li 	$v0,51					# service 51 is Input Dialog Int
	la 	$a0,Message				# set $a0 to contents of Message 
	syscall						# execute 
							# $a1 contains status value : 0 : ok 
	move	$t0,$a0					# set $t0 to content $a0  $t0 = $a0 (a0 = input)
	bne	$a1,0,Error_message			# if $a1 !=0 => Error_message
	jr	$ra  			#call back
	nop

skip:	
	li	$v0,56					# service 56 is Message Dialog Int
	la	$a0,Message1				# set $a0 to contents of Message1
	move	$a1,$t0					# set $a1 to content $t0  $a1 = $t0 (t0 = input)
	syscall						# execute 
	jr	$ra  					#call back
	nop

power: 	
	slti 	$t1,$t0,31				# if $t0 < 31 => $t1= 1 else $t1 = 0 
	beq	$t1,0,ov_power				# if $t1 = 0 => goto square
	slt	$t1,$t0,$0				# if $t0 < 0 => $slt
	beq	$t1,1,m_abs
	add	$t4,$0,$t0
p_cnt:
	#s0 = i , #s1 = power 
	addi	$s1,$0,1		#power = 1
	addi	$s0,$0,0		#i = 0
for_power:
	beq	$s0,$t4,end_power	# if i= t0 Thoat khoi vong lap 
	mul	$s1,$s1,2		#power = power * 2
	addi  	$s0, $s0, 1		# i = i + 1
	j	for_power		# jump to fow_power
	nop
end_power:
	jr	$ra			# call back ve main
	nop
m_abs:
	sub	$t4,$0,$t0		# put -(t0) in $v0
	slti 	$t1,$t4,31		# if $t4 < 31 => $t1= 1 else $t1 = 0 
	beq	$t1,$0,ov_power		# if $t1 = 0 => goto ov_power
	j	p_cnt
ov_power:
	add	$s1,$0,0		# s1 = 0 
	jr	$ra			# call back ve main
	nop
square:
	#s2 = square
	add	$t6,$0,46341
	slt	$t1,$t0,$t6		# if $t0 < 46341 => $t1 = 1 else $t1 = 0
	beq	$t1,0,ov_square		# if $t1 = 0 => go to ov_square
	mul	$s2,$t0,$t0		# $s2 = $t0 * $t0
ctn_square:	
	jr 	$ra  			#call back ve main
	nop
ov_square:
	add	$s2,$0,-1		# $s2 = -1
	j	ctn_square
check_positive_integer:
	slt	$t1,$t0,$0	 	#$t1 = 1 if $t0 < 0
	beq	$t1,1,Error_message	# if $t1 = 1 (input < 0 ) error
	beq	$t1,0,skip		# if $t1 = 0 (input >= 0 ) go to skip
done:	
	li 	$v0, 4			# service 4 is print string
	la 	$a0, result 		# the string to be printed is result
	syscall				# execure
	
	li 	$v0, 1			# serve 1 is print decimal integer
	move 	$a0 ,$t0		# set $a0 to content $t0  $a0 = $t0 , the decimal integer to be printed is St0
	syscall				# execure
	
	li 	$v0, 4			# service 4 is print string
	la 	$a0, asn 			# the string to be printed is " \t "
	syscall				# execure
	
	beq	$s1,0,over_power
	slt	$t1,$t0,$0		# if $t0 < 0 => $t1=1
	beq	$t1,1,print_power2	# if $t1 =1 => print_power2
	li 	$v0, 1			# serve 1 is print decimal integer
	move 	$a0 ,$s1		# set $a0 to content $s1  $a0 = $s1 , the decimal integer to be printed is Ss1 (power)
	syscall				# execure
	j	print_square
	
over_power:
	li 	$v0, 4			# service 4 is print string
	la 	$a0, over 		# the string to be printed is " over "
	syscall				# execure
	j	print_square

print_power2:
	li 	$v0, 4			# service 4 is print string
	la 	$a0, asn3		# the string to be printed is "1\"
	syscall				# execure
	li 	$v0, 1			# serve 1 is print decimal integer
	move 	$a0 ,$s1		# set $a0 to content $s1  $a0 = $s1 , the decimal integer to be printed is Ss1 (power)
	syscall				# execure
	j	print_square

print_square:
	li 	$v0, 4			# service 4 is print string
	la 	$a0, asn2 		# the string to be printed is " \t \t "
	syscall				# execure
	
	slt	$t1,$s2,$0		# if $s2 < 0 => $t1 =1  
	beq	$t1,1,over_square	# if $s1 =1 => over_square
continue:	
	li 	$v0, 1			# serve 1 is print decimal integer
	move 	$a0, $s2		# set $a0 to content $s2  $a0 = $s2 , the decimal integer to be printed is Ss2 (square)
	syscall				# execure
	j	print_hexa
	
over_square:
	li 	$v0, 4			# service 4 is print string
	la 	$a0, over 		# the string to be printed is " over "
	syscall		
	j	print_hexa
	
print_hexa:					
	li	$v0, 4			# service 4 is print string
	la	$a0, asn2		# the string to be printed is " \t \t "
	syscall				# execure
	
	li	$v0,34			# service print integer in hexadecimal
	move	$a0,$t0
	syscall
	
	j	exit			# jump to exit
	
Error_message:
	li	$v0,55			# service 55 is Message Dialog
	la	$a0,Message2		# the contents of message dialog is contents of Message2
	syscall				# execure
	 
	j	exit			# jump to exit
	
	
exit:
	jr 	$ra
# EXIT