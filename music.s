	.include	"common.h"
	.section	.init
	.global		_start
_start:
	mov 	sp,	#STACK

	bl	settings

	ldr	r0,	=TIMER_BASE
	ldr	r1,	[r0, #GPFSEL1]
	ldr	r2,	=soundData
	ldr	r3,	=sound_longData
	ldr	r4,	=sound
	ldr	r5,	=sound_long

	mov	r6,	#0

	ldr	r12,	=PWM_BASE

loop0:
	ldrb	r7,	[r4, r6]
	ldrb	r8,	[r5, r6]		
	ldr	r9,	[r2, r7, lsl #2]	@sound
	ldr	r10,	[r3, r8, lsl #2]	@sound_long
	add	r1,	r1,	r10

	cmp	r9, 	#0
	streq	r9,	[r12, #PWM_DAT2]

	strne	r9,	[r12, #PWM_RNG2]
	lsrne	r9,	r9, 	#1
	strne	r9,	[r12, #PWM_DAT2]

loop1:
	ldr	r7,	=100000
	ldr	r11,	[r0, #GPFSEL1]
	add	r8,	r1,	r7
	cmp	r1,	r11

	movcc	r7,	#0
	strcc	r7,	[r12, #PWM_DAT2]

	cmp	r8,	r11
	bcs	loop1

	ldr	r8,	=sound
	add	r6,	r6,	#1
	ldrb	r7,	[r8, r6]
	cmp	r7,	#30
	moveq	r6,	#0
	b	loop0

loop:	b	loop
	
	


	.section	.data
soundData:
	.word 27428, 25945, 24489, 23132, 21818, 200600, 19472	@ふぁ ふぁ＃ ソ ソ＃ ラ ラ＃ シ
	.word 18355, 17328, 16354, 15434, 14567, 13753, 12972	@ド ド＃ レ レ＃ ミ ファ ファ＃
	.word 12260, 11566, 10909, 10300, 9726, 9177, 8664	@ソ ソ＃ ラ ラ＃ シ ド ド＃
	.word 8177, 7717, 7283, 0				@レ レ＃ ミ 休

sound_longData:
	.word	380000, 190000, 570000, 760000, 950000, 1710000, 1520000, 90000

sound:
	.byte	7,4,2,7,4,2		@1
	.byte	24,11,9,7,7,9		@2
	.byte	7,4,2,7,4,2		@3
	.byte	24,11,9,7,7,9		@4
	.byte	7,4,2,7,4,14		@5
	.byte	14,16,11,9,9		@6
	.byte	7,9,11,12,14,12,11,9	@7
	.byte	7,11,14,11,14,14	@8
	.byte	2,2,2,2,2,2,2,2		@9
	.byte	4,6,4,24,4		@10
	.byte	4,4,4,4,4,7		@11
	.byte	6,4,2			@12
	.byte	2,2,2,2,2,2,2,2		@13
	.byte	4,6,4,24,4		@14
	.byte	4,4,4,4,4,4,7		@15
	.byte	6,6,9,24,7		@16
	.byte	7,7,4,7,24		@17
	.byte	7,7,7,9,7,7		@18
	.byte	7,7,4,7,24		@19
	.byte	7,7,7,9,7		@20
	.byte	24,4,6,7,9		@21
	.byte	7,6,7,9			@22
					@23
	.byte	24,11,24,9,11,14,11,9	@24
	.byte	7,4,2,7,4,2		@25
	.byte	24,11,9,7,7,9		@26
	.byte	7,4,2,7,4,2		@27
	.byte	24,11,9,7,7,9		@28
	.byte	7,4,2,7,4,2		@29
	.byte	24,12,12,11,9,7,11	@30
	.byte	9			@31
	.byte	24,11,24,9,11,14,11,9	@32
	.byte	7,4,2,7,4,2		@33
	.byte	24,11,9,7,7,9		@34
	.byte	7,4,2,7,4,2		@35
	.byte	24,11,11,9,7,7,9	@36
	.byte	7,4,2,7,4,14		@37
	.byte	14,14,16,11,9,9		@38
	.byte	7			@39
	.byte	30			@final
	
sound_long:
	.byte	0,1,1,0,1,1		@1
	.byte	1,0,1,1,1,0		@2
	.byte	0,1,1,0,1,1		@3
	.byte	1,0,1,1,1,0		@4
	.byte	0,1,1,0,1,0		@5
	.byte	0,1,0,1,1		@6
	.byte	1,1,1,1,1,1,1,1		@7
	.byte	1,1,1,1,0,0		@8
	.byte	1,1,1,1,1,1,1,1		@9
	.byte	1,0,2,1,0		@10
	.byte	1,1,1,1,0,1		@11
	.byte	1,0,4			@12
	.byte	1,1,1,1,1,1,1,1		@13
	.byte	1,0,2,1,0		@14
	.byte	1,1,1,1,1,1,1		@15
	.byte	1,0,2,1,0		@16
	.byte	1,1,1,0,0		@17
	.byte	1,1,1,0,0,0		@18
	.byte	1,1,1,0,0		@19
	.byte	1,1,1,0,2		@20
	.byte	0,0,1,0,2		@21
	.byte	0,1,0,5			@22
					@23
	.byte	1,1,1,1,1,1,1,1		@24
	.byte	0,1,1,0,1,1		@25
	.byte	1,0,1,1,1,0		@26
	.byte	0,1,1,0,1,1		@27
	.byte	1,0,1,1,1,0		@28
	.byte	0,1,1,0,1,1		@29
	.byte	1,0,1,1,1,1,1		@30
	.byte	6			@31
	.byte	1,1,1,1,1,1,1,1		@32
	.byte	0,1,1,0,1,1		@33
	.byte	1,0,1,1,1,0		@34
	.byte	0,1,1,0,1,1		@35
	.byte	1,1,1,1,1,1,0		@36
	.byte	0,1,1,0,1,0		@37
	.byte	1,1,1,0,1,1		@38
	.byte	6			@39
	
	
