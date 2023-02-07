# Subroutine & file
- `program.s`
	Main program file. Update target time.
- `bit.s`
	Dislpay radam bit strings on LED display row2.
- `shift.s`
	Shift row1 bit strings for below rows.
- `judge.s`
	Judge from switch and display status.
- `result.s`
	Flushing LED and operate LED gauge.(display row1)
- `gameover.s`
	Called when game over. Play sound and Accept reset button.
- `blMusic.s`
	sound.sで呼び出して「おどるポンポコリン」の演奏データ
- `clMusic.s`
	クリア時に流れるドラゴンクエストのレベルアップ音を演奏
## debug and display
- `common.h`
	- Definition collection.
- `settings.s`
	- Set I/O port.
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
- `display_row`
	- File included: `display_row.s`
	- import register: `{r4}`
		- `r4` is row variable.
	- import data    : `frame_buffer`
	- return register: `notiong`
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
	$ bash media.sh
	```
# Git
- Following files are ignored on git.
	- `temp_*`
