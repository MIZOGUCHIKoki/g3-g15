	.include	"common.h"
	.section	.text
	.global		settings, reset
settings:
	ldr	r0,	=GPIO_BASE
	ldr	r1, =GPFSEL_VEC0
	str	r1, [r0, #GPFSEL0 + 0]
	ldr	r1, =GPFSEL_VEC1
	str	r1, [r0, #GPFSEL0 + 4]
	ldr	r1, =GPFSEL_VEC2
	str	r1, [r0, #GPFSEL0 + 8]

	ldr	r0, =CM_BASE
	ldr	r1, =0x5a000021
	str	r1, [r0, #CM_PWMCTL]
1:
	ldr	r1, [r0, #CM_PWMCTL]
	tst	r1, #0x80
	bne	1b
	ldr	r1, =(0x5a000000 | (2 << 12))
	str	r1, [r0, #CM_PWMDIV]
	ldr	r1, =0x5a000211
	str 	r1, [r0, #CM_PWMCTL]
	
	@set PWM
	ldr	r0,	=PWM_BASE
	ldr	r1,	=(1 << PWM_PWEN2 | 1 << PWM_MSEN2)
	str	r1,	[r0, #PWM_CTL]
	
	bx	r14
reset:
  @ Reset sound
  ldr		r4,		=count
  mov		r7,		#0
  str		r7,		[r4]
	ldr		r4,		=time
	ldr		r7,		[r0, #GPFSEL1]
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
