@ Free & Reserved Register
@ X {r0} : TIMER_BASE address.
@ X {r5} : 更新目標時刻
@ O {r6} : Current time 呼び出しに使う[何入れてもOK]
@ X {r9} : bit_bufferが何巡目か(0 <= r9 <= 8)
@ O {r10}: temp
@ X {r11}: bit_buffer header address.
@ X {r12}: bit_b
	.include	"common.h"
	.section	.text
	.global		bit, go_bit, st_bit
bit:
	ldr		r11,	=bit_buffer
	ldr		r12,	=frame_buffer
	ldrb	r6,	[r11, r9]
	strb	r6,	[r12, #1]
	bx		r14
go_bit:
	ldr		r11,	=frame_go
	ldr		r12,	=frame_buffer
	ldrb	r6,	[r11, r9]
	strb	r6,	[r12, #1]
	bx		r14
st_bit:
	ldr		r11,	=frame_st
	ldr		r12,	=frame_buffer
	ldrb	r6,	[r11, r9]
	strb	r6,	[r12, #1]
	bx		r14
