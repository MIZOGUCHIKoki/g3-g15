@ Free & Reserved Register
@ X {r0} : TIMER_BASE address.
@ O {r1} : read_switch で上書きされる
@ X {r2} : target_time header address.
@ X {r3} : frequency head address.
@ X {r4} : r4 行目を表示する(dpr 周期)
@ X {r5} : 更新目標時刻
@ O {r6} : Current time 呼び出しに使う[何入れてもOK]
@ X {r7} : 現在のスコアを管理(8 -> 0)
@ X {r8} : OK Flag
@ X {r9} : bit_bufferが何巡目か(0 <= r9 <= 8)
@ O {r10}: Free
@ O {r11}: Free
@ X {r12}: 
	.equ			dpr,		1000
	.include	"common.h"
	.section	.init
	.global		_start, frame_buffer, frequency, bit_buffer
_start:
	mov		sp,		#STACK
	bl		settings
	ldr		r0,		=TIMER_BASE
	ldr		r2,		=target_time	@ 目標時刻先頭アドレス
	ldr		r3,		=frequency		@ 周期先頭データ先頭データ
	mov		r4,		#0						@ display_row
	mov		r7,		#8						@ 現在スコア
	mov		r8,		#0						@ OK Flag
	mov		r9,		#0						@ bit_buffer進捗管理
	@	display_low 初期目標時刻設定
	ldr		r6,		[r0, #GPFSEL1]
	mov		r1,		#dpr
	add		r6,		r6,	r1
	str		r6,		[r2]
	@ 更新目標時刻
	ldr		r6,		[r0, #GPFSEL1]
	ldr		r1,		[r3]		@ from frequency
	add		r5,		r6,	r1	@ set target time
loop:
	bl		bit
	bl		shift
	disp:
		ldr		r6,		[r0, #GPFSEL1]	@ r6 current
		ldr		r1,		[r2]
		cmp		r6,		r1			@	Current, Target
		bcc		update				@ Currnet < Target
		mov		r10,	#dpr	
		add		r6,		r1,	r10	@ update target time
		str		r6,		[r2]		@ update target time
		add		r4,		r4,	#1
		cmp		r4,		#8
		moveq	r4,		#0
update:
		ldr		r6,		[r0, #GPFSEL1]	@ r6 current
		cmp		r6,		r5			@	Current, Target
		bcc		endp					@ Currnet < Target
		ldr		r10,	[r3]		@ from frequency
		add		r5,		r6,	r10	@ update target time
		add		r9,		r9,	#1  @ update bit_buffer 進捗管理
		cmp		r9,		#8
		moveq	r9,		#0
endp:
	
	bl		display_row
	b			loop

frequency:
	.word	1000*1000	@ 0.5sec
	.word 
	.section	.data
target_time:
	.word	0 @ display_low
frame_buffer:
	.byte	0xff, 0, 0, 0, 0, 0, 0, 0
	@ debug uzu data
	@.byte 0x1e, 0x21, 0x4c, 0x92, 0x49, 0x22,0x14, 0x08
bit_buffer:
	.byte	0x81, 0x2a, 0x0, 0x29, 0x77, 0x0, 0x19, 0x0
