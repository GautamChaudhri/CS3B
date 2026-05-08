labgve-3.out: labgve-3.o llist.o dataLT.o sensor.o cstr2dfp.o
	ld -o labgve-3.out labgve-3.o llist.o dataLT.o sensor.o cstr2dfp.o ../obj/lib.a /usr/lib/aarch64-linux-gnu/libc.so -dynamic-linker /lib/ld-linux-aarch64.so.1

%.o: %.s
	as -g $< -o $@

clean:
	rm -f *.o *.out