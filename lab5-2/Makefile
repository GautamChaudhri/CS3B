TARGET = lab5-2.out
SRC_MAIN = driver5-2.s
SRC_FUNC1 = int2cstr.s
SRC_FUNC2 = putstring.s
SRC_FUNC3 = String_length.s
OBJ_MAIN = driver5-2.o
OBJ_FUNC1 = int2cstr.o
OBJ_FUNC2 = putstring.o
OBJ_FUNC3 = String_length.o

all: $(TARGET)

$(TARGET): $(OBJ_MAIN) $(OBJ_FUNC1) $(OBJ_FUNC2) $(OBJ_FUNC3)
	ld -o $(TARGET) $(OBJ_MAIN) $(OBJ_FUNC1) $(OBJ_FUNC2) $(OBJ_FUNC3)

$(OBJ_MAIN): $(SRC_MAIN)
	as -g -o $(OBJ_MAIN) $(SRC_MAIN)

$(OBJ_FUNC1): $(SRC_FUNC1)
	as -g -o $(OBJ_FUNC1) $(SRC_FUNC1)

$(OBJ_FUNC2): $(SRC_FUNC2)
	as -g -o $(OBJ_FUNC2) $(SRC_FUNC2)

$(OBJ_FUNC3): $(SRC_FUNC3)
	as -g -o $(OBJ_FUNC3) $(SRC_FUNC3)

clean:
	rm -f $(TARGET) $(OBJ)

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run