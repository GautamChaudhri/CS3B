labgve-1.out: labgve-1.o ../obj/lib.a
	ld -o labgve-1.out labgve-1.o ../obj/lib.a /usr/lib/aarch64-linux-gnu/libc.so -dynamic-linker /lib/ld-linux-aarch64.so.1
	# gcc -o labgve-1.out labgve-1.o ../obj/lib.a -nostartfiles

%.o : %.s
	as -g $< -o $@

clean:
	rm -f *.o *.out