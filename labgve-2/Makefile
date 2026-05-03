labgve-2.out: labgve-2.o llist.o dataLT.o
	ld -o labgve-2.out labgve-2.o llist.o dataLT.o ../obj/lib.a /usr/lib/aarch64-linux-gnu/libc.so -dynamic-linker /lib/ld-linux-aarch64.so.1

%.o: %.s
	as -g $< -o $@

clean:
	rm -f *.o *.out