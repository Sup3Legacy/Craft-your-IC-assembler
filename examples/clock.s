.init
	loadi $58 %2 # Seconds.
	loadi $59 %3 # Minutes.
	loadi $12 %4 # Hours.
	loadi $1 %5
	loadi $59 %6
	loadi $23 %7
    add %0 %0 %9
.print_hour
	print %4 $2
.print_min
	print %3 $1
.print_sec
	print %2 $0
.sec
	add %5 %2 %2 # Add a second.
	xor %2 %1 %9 # Check if there is a roll over. # sub %6 %2 %0
	add %5 %9 %9
	add %6 %9 %0
	jneg min
	jmp print_sec # Update the screen and loop.
.min
	loadi $0 %2# Reset the seconds.
	add %5 %3 %3 # Add a minute.
	xor %3 %1 %9 # Check if there is a roll over. # sub %6 %2 %0
	add %5 %9 %9
	add %6 %9 %0
	jneg hour
	jmp print_min # Update the screen and loop.
.hour
	loadi $0 %3 # Reset the minutes.
	add %5 %4 %4 # Add an hour.
	xor %4 %1 %9 # Check if there is a roll over. # sub %7 %2 %0
	add %5 %9 %9
	add %7 %9 %0
	jneg halt
	jmp print_hour # Update the screen and loop.
.halt
	jmp halt
