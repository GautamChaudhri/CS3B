TARGET     = lab6-1.out
SRC_MAIN   = driver6-1.s
SRC_FUNC1  = getstring.s
OBJ_MAIN   = driver6-1.o
OBJ_FUNC1  = getstring.o
LIB        = ../obj/lib.a

all: $(TARGET)

$(TARGET): $(OBJ_MAIN) $(OBJ_FUNC1) $(LIB)
	ld -o $(TARGET) $(OBJ_MAIN) $(OBJ_FUNC1) $(LIB)

$(OBJ_MAIN): $(SRC_MAIN)
	as -g -o $(OBJ_MAIN) $(SRC_MAIN)

$(OBJ_FUNC1): $(SRC_FUNC1)
	as -g -o $(OBJ_FUNC1) $(SRC_FUNC1)

clean:
	rm -f *.o *.out
