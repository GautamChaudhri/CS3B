all: lab7-3.out

lab7-3.out: lab7-3.o bubblesort.o ../obj/lib.a
	ld -o lab7-3.out lab7-3.o bubblesort.o ../obj/lib.a

lab7-3.o: lab7-3.s macros.s
	as -g -o lab7-3.o lab7-3.s

bubblesort.o: bubblesort.s
	as -g -o bubblesort.o bubblesort.s

clean:
	rm -f *.o *.out
