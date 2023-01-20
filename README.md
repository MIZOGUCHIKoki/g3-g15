# Builder
- `Makefile`
	- To build `program.img`, Run the following command.
	```Bash
	$ make program.img
	```
	- To remove some useless files (`*.o`, `*.img`, `*.elf`), run following command.
	```Bash
	$ make clean
	```
- `media.sh`
	-To transfer to microSD, run following command.
	```Bash
	$ bash media.sh program
	```

# Subroutine
- `read_switch.s`
	- File inlcuded: `read_swtich.s`
	- import register: `nothing`
	- return register: `{r1}`

