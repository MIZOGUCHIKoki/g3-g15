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
@ X {r10}: Miss Flag
@ O {r11}: Free
@ O {r12}: Free
  .equ			dpr,		1000
  .include	"common.h"
  .section	.init
  .global		_start, frame_buffer, frequency, bit_buffer, frame_go, frame_st
_start:
  mov		sp,		#STACK
  bl		settings
  ldr		r0,		=TIMER_BASE
  ldr		r2,		=target_time	@ 目標時刻先頭アドレス
  ldr		r3,		=frequency		@ 周期先頭データ先頭データ
	mov		r4,		#0
  mov		r9,		#0						@ bit_buffer進捗管理
	str		r4,		[r2, #12]			@ update target time
reset:
@ --- Start_display ---
start_dsiplay:
  ldr		r11,		=frame_st
  ldr		r12,		=frame_buffer
  ldr		r6,		[r12]
  str		r6,		[r11]
  ldr		r6,		[r12, #4]
  str		r6,		[r11, #4]
	ldr		r6,		[r0, #GPFSEL1]
	ldr		r11,	=2000000
	add		r12,	r11,	r6
	str		r12,	[r2, #12]			@ update target time

	mov		r11,	#28						@ set frequency (pointer)
	mov		r9,		#0
	str		r11,	[r3, #20]
sloop:
	bl		led_on
	bl		st_bit
	bl		shift
	bl		disp
	ldr		r6,		[r0, #GPFSEL1]
	ldr		r12,	[r2, #12]
	cmp		r6,		r12
	bcc		sloop
	bl		led_off
@ Reset sound
  ldr		r4,		[r0, #GPFSEL1]
  ldr		r7,		=time
  str		r4,		[r7]
  ldr		r4,		=count
  mov		r7,		#0
  str		r7,		[r4]
	ldr		r4,		=time
	ldr		r7,		[r0, #GPFSEL1]
	str		r7,		[r4]
	ldr		r4,		=count_2
	mov		r7,		#0
	str		r7,		[r4]
@ Reset frequency
	mov		r4,		#0
	str		r4,		[r3, #20]
@ Reset display
  ldr		r4,		=frame_init
  ldr		r8,		=frame_buffer
  ldr		r7,		[r4]
  str		r7,		[r8]
  ldr		r7,		[r4, #4]
  str		r7,		[r8, #4]
@ Stop sound
  ldr		r4,		=PWM_BASE
  mov		r7,		#0
  str		r7,		[r4, #PWM_DAT2]

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

main:
  @ judge game_over
  cmp		r7,		#0
  beq		game_over

	@ frequency set
	bl		read_switch
	cmp		r1,		#8
	bne		blp
	ldr		r6,		[r3, #16]	@ test flag
	cmp		r6,		#1
	beq		blp
	mov		r6,		#1
	str		r6,		[r3, #16]	@ update flag
	ldr		r6,		[r3, #20]	@ load opinter
	add		r6,		r6,		#4
	cmp		r6,		#16
	moveq	r6,		#0
	str		r6,		[r3, #20]	@ update opinter

blp:
  bl 		sound
  bl		judge
  bl		shift
  bl		bit
endp:
	bl		disp
  bl		display_row
  b			main

game_over:
	ldr r6, =GPIO_BASE
	ldr	r1, =(1 << ROW1_PORT | 1 << ROW2_PORT | 1 << ROW3_PORT | 1 << ROW4_PORT | 1 << ROW5_PORT | 1 << ROW6_PORT | 1 << ROW7_PORT | 1 << ROW8_PORT)
	str	r1, [r6, #GPSET0]
	ldr		r11,		=frame_go
	ldr		r12,		=frame_buffer
	ldr		r6,		[r12]
	str		r6,		[r11]
	ldr		r6,		[r12, #4]
	str		r6,		[r11, #4]

	ldr		r6,		[r0, #GPFSEL1]
	ldr		r12,	=time_2
	str		r6,		[r12]

	bl		led_on
	mov		r9,		#0
	mov		r12,	#24
	str		r12,	[r3, #20]
gloop:
  bl		read_switch
  cmp		r1,		#4			@ SW3 == 1
  beq		reset
	bl		gameover
	bl		go_bit
	bl		shift
	bl		disp
	bl		display_row
  b			gloop


disp:
  ldr		r6,		[r0, #GPFSEL1]	@ r6 current
  ldr		r1,		[r2]		@ load target time
  cmp		r6,		r1			@	Current, Target
  bxcc	r14						@ Currnet < Target
  mov		r11,	#dpr	
  add		r6,		r1,	r11	@ update target time
  str		r6,		[r2]		@ update target time
  add		r4,		r4,	#1
  cmp		r4,		#8
  moveq	r4,		#0
	bx		r14

  .section	.data
frequency:
  .word	1500*1000	@ 1.50 sec	#0
  .word	1000*1000	@	1.00 sec	#4
  .word	500*1000	@ 0.50 sec	#8
  .word	200*1000	@ 0.20 sec	#12
	.word	0					@ flag			#16
	.word	0					@ pointer		#20
	.word 100*1000	@ 0.10 sec	#24
	.word 50*1000		@ 0.05 sec	#28
target_time:
  .word	0 @ display_low
  .word	0 @ led_flash_on
  .word	0 @ led_flash_off
	.word 0 @ start
frame_buffer:
  .byte	0xff, 0, 0, 0, 0, 0, 0, 0
bit_buffer:
  .byte 0x28, 0x00, 0x0c, 0x48, 0x0a, 0x90, 0x0c, 0x38
  .byte 0x0a, 0x00, 0x14, 0x38, 0x0a, 0x15, 0x00, 0x00
  .byte 0x0c, 0x1b, 0x38, 0x14, 0x00, 0x90, 0x0c, 0x68
  .byte 0x00, 0x15, 0x00, 0x38, 0x00, 0x0a, 0x00, 0x48
  .byte 0x38, 0x19, 0x98, 0x14, 0x0c, 0x15, 0x48, 0x00
  .byte 0x0e, 0xd0, 0x00, 0x15, 0x0a, 0x90, 0x00, 0x28
  .byte 0x38, 0x00, 0x98, 0x14, 0x0c, 0x15, 0x48, 0x0c
frame_go:
  .byte 0x28, 0x48, 0x14, 0x00, 0xb0, 0x90, 0x68, 0x14
  .byte 0x18, 0x24, 0x2c, 0x20, 0x24, 0x18, 0x00, 0x00
  .byte 0x24, 0x24, 0x3c, 0x24, 0x24, 0x18, 0x00, 0x00
  .byte 0x44, 0x44, 0x44, 0x54, 0x6c, 0x44, 0x00, 0x00
  .byte 0x3c, 0x20, 0x20, 0x38, 0x20, 0x3c, 0x00, 0x00
  .byte 0x18, 0x24, 0x24, 0x24, 0x24, 0x18, 0x00, 0x00
  .byte	0x18, 0x24, 0x24, 0x24, 0x24, 0x24, 0x00, 0x00
  .byte 0x3c, 0x20, 0x20, 0x38, 0x20, 0x3c, 0x00, 0x00
  .byte 0x24, 0x20, 0x38, 0x24, 0x24, 0x38, 0x00, 0x00
frame_init:
  .byte	0xff, 0, 0, 0, 0, 0, 0, 0
frame_st:
	@1,2,4,8,10,20,40,80
	.byte	0xfe, 0xfd, 0xfb, 0xf7, 0xef, 0xdf, 0xbf, 0x7f
