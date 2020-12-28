.main
	loadi $9 %2
	loadi $7 %3
	loadi $0 %5
	loadi $1 %6
	# Swap %2 and %3 if %3 < %2.
	mv %2 %4
	mv %3 %2
	mv %4 %3
	# Create a counter.
	sub %0 %2 %4
	# Check if the counter is negative.
	jneg add
.print1
	print %5 $0
	halt
.add
	# Add %3 to %5.
	add %3 %5 %5
	# Decrease the counter.
	add %6 %4 %4
	jneq add
.print2
	print %5 $0
	halt
