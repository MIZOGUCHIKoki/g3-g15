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
	.global		bit
bit:
	ldr		r11,	=bit_buffer
	ldr		r12,	=frame_buffer
	ldrb	r10,	[r11, r9]
	mov		r6,		#1
	strb	r10,	[r12, r6]
endp:
	bx		r14
