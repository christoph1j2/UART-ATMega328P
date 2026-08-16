MCU = atmega328p
F_CPU = 16000000UL
PORT = COM9
BAUD = 115200

CC = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

SRC = main.c uart.c

# prepinace pro kompilator:
## zapnuti varovani
## optimalizace velikosti (-Os)
## definice čipu
CFLAGS = -Wall -Os -DF_CPU=$(F_CPU) -mmcu=$(MCU)

all: main.hex

main.elf: $(SRC)
	$(CC) $(CFLAGS) -o main.elf $(SRC)

# prevod zkompilovaneho programu do .hex formatu, kteremu rozumi procesor
main.hex: main.elf
	$(OBJCOPY) -O ihex -R .eeprom main.elf main.hex

# nahrani do arduina
upload: main.hex
	$(AVRDUDE) -F -V -c arduino -p $(MCU) -P $(PORT) -b $(BAUD) -U flash:w:main.hex:i

# uklid
clean:
	del main.elf main.hex