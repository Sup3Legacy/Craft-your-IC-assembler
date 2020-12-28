.main
	mv %1 %5
	mv %0 %6
	loadi $1 %7
.rand
	add %0 %5 %0
	jz print
	add %1 %5 %5
	mv %15 %2
	mv %15 %3
.euclide
	sub %2 %3 %0
	jz proba
	sub %2 %3 %0
	jneg case2
	sub %2 %3 %2
	jmp euclide
.case2
	sub %3 %2 %3
	jmp euclide
.proba
	add %1 %3 %0
	jz relatively_prime
	jmp rand
.relatively_prime
	add %7 %6 %6
	jmp rand
.print
	print %6 $0
	halt
