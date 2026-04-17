all: driver12-2.out

driver12-2.out: driver12-2.o cstr2dfp.o ../obj/lib.a
	gcc -o driver12-2.out driver12-2.o cstr2dfp.o ../obj/lib.a -no-pie

driver12-2.o: driver12-2.s
	as -g -o driver12-2.o driver12-2.s

cstr2dfp.o: cstr2dfp.s
	as -g -o cstr2dfp.o cstr2dfp.s

clean:
	rm -f *.o *.out