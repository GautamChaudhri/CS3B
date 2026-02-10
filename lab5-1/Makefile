TARGET = lab5-1.out
SRC = lab5-1.s

all: $(TARGET)

$(TARGET): $(SRC)
	as -g -o $(TARGET).o $(SRC)
	ld -o $(TARGET) $(TARGET).o

clean:
	rm -f $(TARGET) $(TARGET).o

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run
