.init
	loadi $0 %2 # Seconds.
	loadi $0 %3 # Minutes.
	loadi $0 %4 # Hours.
	loadi $1 %5
	loadi $59 %6
	loadi $23 %7
.print_hour
	print %2 $0
.print_min
	print %3 $1
.print_sec
	print %4 $2
.sec
	# Add a second.
	add %5 %2 %2
	# Check if there is a roll over.
	sub %6 %2 %0
	jneg min
	# Update the screen and loop.
	jmp print_sec
.min
	# Reset the seconds.
	loadi $0 %2
	# Add a minute.
	add %5 %3 %3
	# Check if there is a roll over.
	sub %6 %2 %0
	jneg hour
	# Update the screen and loop.
	jmp print_min
.hour
	# Reset the minutes.
	loadi $0 %3
	# Add an hour.
	add %5 %4 %4
	# Check if there is a roll over.
	sub %7 %2 %0
	jneg halt
	# Update the screen and loop.
	jmp print_hour
.halt
	halt
