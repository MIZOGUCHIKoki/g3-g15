# Subroutine & files
- `common.h`
	- Definition collection.
- `settings.s`
	
- `read_switch`
	- File inlcuded: `read_swtich.s`
	- import register: `nothing`
	- return register: `{r1}`
		- If SW1, SW2 are pressed, `0011` is stored `r1`.
		- If SW1, SW3 are pressed, `0101` is stored `r1`.
- `led_on`, `led_off`
	- File included: `debug.s`
	- import register: `nothing`
	- return register: `nothing`
	- `led_on`
		- Turn LED on.
	- `led_off`
		- Turn LED off.
# Builder
- `Makefile`
	- To build `program.img`, Run the following command.
	```Bash
	$ make
	```
	- To remove some useless files (`*.o`, `*.img`, `*.elf`), run following command.
	```Bash
	$ make clean
	```
- `media.sh`
	- To transfer to microSD, run following command.
	```Bash
	$ bash media.sh program
	```
# Git
- Ignored files
	- `temp_*`

