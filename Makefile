AS = arm-none-eabi-as 
LD = arm-none-eabi-ld
OBJ = arm-none-eabi-objcopy
LDFRAGS = -m armelf
OBJFLAGS = -O binary

program.img:program.elf
	$(OBJ) $< $(OBJFLAGS) $@
	rm *.o *.elf 
%.elf: program.o read_switch.o display_row.o debug.o settings.o
	$(LD) $(LDFRAGS) $+ -o $@
%.elf: %.o 
	$(LD) $(LDFRAGS) $< -o $@
%.o: %.s 
	$(AS) $< -o $@
%: %.s

.PHONY: clean
clean:
	rm -f  *.img
	reset
