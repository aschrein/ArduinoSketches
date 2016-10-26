avr-as -g -mmcu=atmega328p led.s -o led.o 
avr-ld -o led.elf led.o
avr-objcopy -O ihex -R .eeprom led.elf led.hex
avrdude -p atmega328p -P com4 -c arduino -C "C:\Program Files (x86)\Arduino\hardware\tools\avr/etc/avrdude.conf" -D -U flash:w:led.hex:i
