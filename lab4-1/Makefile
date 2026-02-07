lab4-1.out:
	as -g -o String_length.o String_length.s
	as -g -o putstring.o putstring.s
	as -g -o driver4-1.o driver4-1.s
	ld -o lab4-1.out driver4-1.o String_length.o putstring.o

clean:
	rm -f *.o lab4-1.out