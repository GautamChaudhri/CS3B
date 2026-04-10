all: lab12-1.out

lab12-1.out: lab12-1.o
	ld -o lab12-1.out lab12-1.o

lab12-1.o:lab12-1.s
	as -g -o lab12-1.o lab12-1.s

clean:
	rm -f *.o *.out