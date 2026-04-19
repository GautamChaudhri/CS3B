all: lab12-2.out

lab12-2.out: driver12-2.o cstr2dfp.o
	gcc -o lab12-2.out driver12-2.o cstr2dfp.o

driver12-2.o: driver12-2.s
	as -g -o driver12-2.o driver12-2.s

cstr2dfp.o: cstr2dfp.s
	as -g -o cstr2dfp.o cstr2dfp.s

clean:
	rm -f *.o *.out