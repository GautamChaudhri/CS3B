TARGET     = lab5-3.out
SRC_MAIN   = driver5-3.s
SRC_FUNC1  = cstr2int.s
SRC_FUNC2  = int2cstr.s
SRC_FUNC3  = putstring.s
SRC_FUNC4  = String_length.s
OBJ_MAIN   = driver5-3.o
OBJ_FUNC1  = cstr2int.o
OBJ_FUNC2  = int2cstr.o
OBJ_FUNC3  = putstring.o
OBJ_FUNC4  = String_length.o

all: $(TARGET)

$(TARGET): $(OBJ_MAIN) $(OBJ_FUNC1) $(OBJ_FUNC2) $(OBJ_FUNC3) $(OBJ_FUNC4)
	ld -o $(TARGET) $(OBJ_MAIN) $(OBJ_FUNC1) $(OBJ_FUNC2) $(OBJ_FUNC3) $(OBJ_FUNC4)

$(OBJ_MAIN): $(SRC_MAIN)
	as -g -o $(OBJ_MAIN) $(SRC_MAIN)

$(OBJ_FUNC1): $(SRC_FUNC1)
	as -g -o $(OBJ_FUNC1) $(SRC_FUNC1)

$(OBJ_FUNC2): $(SRC_FUNC2)
	as -g -o $(OBJ_FUNC2) $(SRC_FUNC2)

$(OBJ_FUNC3): $(SRC_FUNC3)
	as -g -o $(OBJ_FUNC3) $(SRC_FUNC3)

$(OBJ_FUNC4): $(SRC_FUNC4)
	as -g -o $(OBJ_FUNC4) $(SRC_FUNC4)

clean:
	rm -f *.o *.out
