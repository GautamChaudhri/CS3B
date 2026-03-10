TARGET     = lab6-1.out
SRC_MAIN   = getstring.s
OBJ_MAIN   = getstring.o
LIB        = ../../obj/lib.a

all: $(TARGET)

$(TARGET): $(OBJ_MAIN) $(LIB)
	ld -o $(TARGET) $(OBJ_MAIN) $(LIB)

$(OBJ_MAIN): $(SRC_MAIN)
	as -g -o $(OBJ_MAIN) $(SRC_MAIN)

clean:
	rm -f *.o *.out
