all: driver12-2.out

driver12-2.out: driver12-2.o cstr2dfp.o cstr2int.o ../obj/lib.a
	gcc -o driver12-2.out driver12-2.o cstr2dfp.o cstr2int.o ../obj/lib.a

driver12-2.o: driver12-2.s
	as -g -o driver12-2.o driver12-2.s

cstr2dfp.o: cstr2dfp.s
	as -g -o cstr2dfp.o cstr2dfp.s

cstr2int.o: cstr2int.s
	as -g -o cstr2int.o cstr2int.s

clean:
	rm -f *.o *.out