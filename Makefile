# what is the final binary called
PROGRAM = test1

MCU=atmega168
CLOCK=16000000

PRGM=arduino
PORT=COM3
BAUD=115200
AVRDUDE = avrdude -c $(PRGM) -p $(MCU) -P $(PORT) -b $(BAUD)
AVRDUDE_F = avrdude -F -c $(PRGM) -p $(MCU) -P $(PORT) -b $(BAUD)
CC=avr-gcc

# flags to pass to the C compiler
# -mmcu should be set to the CPU type
# -DF_CPU should be the clock speed in Hz
# you can add additional -D statements which work just like #define in the code
CFLAGS = -std=c99 -Wall -I. -g -Os -mmcu=$(MCU) -DF_CPU=$(CLOCK)

SRC=src
INC=inc
OBJ=obj
BIN=bin

# Any other files that aren't C source, that trigger a rebuild
DEPS = $(wildcard $(INC)/*.h)

# These are the object files that gcc will create, from your .c files
# you need one for each of your C source files
SRCS=$(wildcard $(SRC)/*.c)
OBJS=$(patsubst $(SRC)/%.c, $(OBJ)/%.o, $(SRCS))


all: compile test flash

#CLEANER
clean:
	rm $(BIN)/*.hex
	rm $(BIN)/*.elf
	rm $(OBJ)/*.o

#COMPILER
compile:$(BIN)/$(PROGRAM).hex

#CONVERTER
# this turns the .elf binary into .hex for avrdude
$(BIN)/$(PROGRAM).hex: $(BIN)/$(PROGRAM).elf
	avr-objcopy -j .text -j .data -O ihex $< $@

#LINKER
$(BIN)/$(PROGRAM).elf: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $<

#BUILDER
$(OBJ)/%.o: $(SRC)/%.c $(DEPS)
	$(CC) $(CFLAGS) -o $@ -c $<

# test programmer connectivity
test:
	$(AVRDUDE_F) -v

# this calls the first macro we defined to create a .hex file
# then it runs avrdude to burn it to your Arduino

flash:   $(BIN)/$(PROGRAM).hex
	$(AVRDUDE_F) -U flash:w:$(BIN)/$(PROGRAM).hex

