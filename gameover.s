	.include	"common.h"
	.section	.text
	.global		gameover
gameover:
	push	{r0-r12, r14}
	
	bl	settings

	ldr	r0,	=TIMER_BASE
	
	ldr	r2,	=soundData_2
	ldr	r3,	=sound_longData_2
	ldr	r4,	=sound2_2
	ldr	r5,	=sound_long_2

	ldr	r7,	=count_2
	ldrb	r6, 	[r7]

	ldr	r12,	=PWM_BASE

ON:
	ldrb	r7,	[r4, r6]
	ldrb	r8,	[r5, r6]		
	ldr	r9,	[r2, r7, lsl #2]	@sound
	ldr	r10,	[r3, r8, lsl #2]	@sound_long

	cmp	r9, 	#0
	streq	r9,	[r12, #PWM_DAT2]

	strne	r9,	[r12, #PWM_RNG2]
	lsrne	r9,	r9, 	#1
	strne	r9,	[r12, #PWM_DAT2]

	ldr	r7,	=time_2
	ldr	r1,	[r7]
	ldr	r11,	[r0, #GPFSEL1]
	
	cmp	r1,	r11
	addcc	r1,	r1,	r10
	strcc	r1,	[r7]
	ldrcc	r1,	[r7, #4]
	movcc	r8,	#0
	strcc	r8,	[r12, #PWM_DAT2]

	cmp	r1,	r11
	addcc	r6,	r6,	#1
	addcc	r1,	r1,	r10
	strcc	r1,	[r7, #4]
	cmp	r6,	#31
	moveq	r6,	#0
	ldr	r7,	=count_2
	strb	r6,	[r7]

	pop	{r0-r12, r14}
	bx	r14
	
	


	.section	.data
	.global		soundData_2, sound_longData_2, time_2, sound2_2, sound_long_2, count_2
soundData_2:
	@シ4,ド5,レ5,ミ5,ファ5
	.word	19472, 18355, 16354, 14567, 13753,
sound_longData_2:
	.word	700000, 230000, 120000, 350000
time_2:
	.word 	0x00, 0x00

sound2_2:
	.byte	0,4,4,4,3,2,1
sound_long_2:
	.byte	0,0,3,0,0,3,3

count_2:
	.byte	0
	
@シ4,ファ5,ファ5,ファ5,ミ5,レ5,ド5
