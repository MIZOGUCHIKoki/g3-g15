# Builder
- `Makefile`
	- Run the following command to build `program.img`
	```Bash
		$ make program.img
	```
	- Run following command to Remove some useless files. (`*.o`, `*.img`, `*.elf`)
	```Bash
		$ make clean
	```
- `media.sh`
	- Run following command to transfer to microSD `program.img`
	```Bash
		$ bash media.sh program
	```

# Subroutine
- `read_switch.s`
	- File inlcuded: `read_swtich.s`
	- import register: `nothing`
	- return register: `{r1}`

