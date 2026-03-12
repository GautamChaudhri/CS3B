

TARGET     = lab7-1.out
SRC_MAIN   = lab7-1.s
OBJ_MAIN   = lab7-1.o
LIB        = ../obj/lib.a

all: $(TARGET)

$(TARGET): $(OBJ_MAIN) $(LIB)
	ld -o $(TARGET) $(OBJ_MAIN) $(LIB)

$(OBJ_MAIN): $(SRC_MAIN)
	as -g -o $(OBJ_MAIN) $(SRC_MAIN)

clean:
	rm -f *.o *.out
