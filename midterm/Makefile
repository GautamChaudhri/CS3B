all:midterm.out

midterm.out: driverMidterm.o fputstring.o 
	ld -o midterm.out driverMidterm.o fputstring.o

driverMidterm.o: driverMidterm.s
	as -g -o driverMidterm.o driverMidterm.s

fputstring.o: fputstring.s
	as -g -o fputstring.o fputstring.s

clean: 
	rm -f *.o *.out