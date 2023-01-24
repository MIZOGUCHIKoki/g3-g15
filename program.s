@ Reserved Register : {r0, r2 - r4}
@	X {r0} : TIMER_BASE address.
@	O {r1} : read_switch で上書きされる
@	X {r2} : target_time header address.
@ X {r3} : pase head address.
@	X {r4} : r4 行目を表示する(pase 周期)
@ X {r5} : 更新周期を管理
@	O {r6} : Current time 呼び出しに使う[何入れてもOK]
@ X {r7} : 現在のスコアを管理(8 -> 0)
	.include	"common.h"
	.section	.init
	.global		_start, frame_buffer, frequency, bit_buffer
_start:
	mov		sp,		#STACK
	bl		settings
	ldr		r0,		=TIMER_BASE
	ldr		r2,		=target_time
	ldr		r3,		=frequency
endp:
	b			loop

	.section	.data
target_time:
	.word	0 @ off
frequency:
	.word	1000000
frame_buffer:
	.byte	0, 0, 0, 0, 0, 0, 0, 0
bit_buffer:
	.byte	1,2,3,4,5,6,7
