# Compute F_13.
.main
	loadi $12 %2
	loadi $0 %3
	loadi $1 %4
.next
	add %0 %2 %0
	jz print
	add %3 %4 %5
	mv %4 %3
	mv %5 %4
	add %1 %2 %2
	jmp next
.print
	print %4 $0
	halt
