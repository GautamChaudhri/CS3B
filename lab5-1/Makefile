PROGRAM = lab5-1
SRC = $(PROGRAM).s
OBJ = $(PROGRAM).o
TARGET = $(PROGRAM).out

all: $(TARGET)

$(TARGET): $(SRC)
	as -g -o $(OBJ) $(SRC)
	ld -o $(TARGET) $(OBJ)

clean:
	rm -f $(TARGET) $(OBJ)

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run