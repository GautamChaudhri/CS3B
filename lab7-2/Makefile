TARGET     = lab7-2.out
SRC_MAIN   = driver7-2.s
SRC_FUNC1  = getline.s
SRC_MACROS = macros.s
OBJ_MAIN   = driver7-2.o
OBJ_FUNC1  = getline.o
LIB        = ../obj/lib.a

all: $(TARGET)

$(TARGET): $(OBJ_MAIN) $(OBJ_FUNC1) $(LIB)
	ld -o $(TARGET) $(OBJ_MAIN) $(OBJ_FUNC1) $(LIB)

$(OBJ_MAIN): $(SRC_MAIN) $(SRC_MACROS)
	as -g -o $(OBJ_MAIN) $(SRC_MAIN)

$(OBJ_FUNC1): $(SRC_FUNC1)
	as -g -o $(OBJ_FUNC1) $(SRC_FUNC1)

clean:
	rm -f *.o *.out
