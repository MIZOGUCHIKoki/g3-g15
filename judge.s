@ Free & Reserved Register
@ X {r0} : TIMER_BASE
@ X {r1} : read_switch
@ X {r2} : target_time header address.
@ X {r3} : led_on_time control
@ X {r4} : led_off_time control
@ X {r5} : led_on times control
@ X {r6} : =count
@ X {r7} : 現在のスコアを管理
@ X {r8} : OK Flag
@ 0 {r9} : bit_buffer time
@ X {r10} : Miss Flag
@ 0 {r11} : Free
@ 0 {r12} : Free
	
	.include	"common.h"
	.section	.text
	.global		judge
judge:
	push	{r3-r6, r14}

	@8行目読み出し & read_switch
	ldr	r12,	=frame_buffer
	ldrb	r11,	[r12, #7]
	bl	read_switch
	
	@OK_flag test
	cmp	r8,	#0
	bne	clear_led

	cmp	r10,	#0
	bne	end

if1:	@switch1 test
	cmp	r1,	#1
	bne	if2
	tst	r11,	#224	@11100000
	bne	jumpclear
	b	jumpmiss

if2:	@switch2 test
	cmp	r1,	#2
	bne	if3
	tst	r11,	#7	@00000111
	bne	jumpclear
	b	jumpmiss
	
if3:	@no switch test
	tst	r11,	#224
	beq	end
	bne	jumpmiss
	tst	r11,	#7
	beq	end
	bne	jumpmiss
	@b	jumpmiss

@first success
jumpclear:
	bl	clear
	ldr	r12,	[r0, #GPFSEL1]
	ldr	r11,	=100000
	str	r12,	[r2, #4]
	add	r12,	r12,	r11
	str	r12,	[r2, #8]
	mov	r12,	#3
	ldr	r11,	=count
	str	r12,	[r11]
	
	b	end

@first miss
jumpmiss:
	bl	miss
	b	end

@led_on and off
clear_led:
	ldr	r6,	=count
	ldr	r5,	[r6]
	
	cmp	r5,	#0
	beq	end
	
	ldr	r11,	=200000	
	ldr	r12,	[r0, #GPFSEL1]		@current_time
	ldr	r3,	[r2, #4]		@led_on_time
	cmp	r3,	r12
	blcc	led_on
	addcc	r3,	r3,	r11
	strcc	r3,	[r2, #4]	

	ldr	r4,	[r2, #8]
	cmp	r4,	r12
	blcc	led_off
	addcc	r4,	r4,	r11
	strcc	r4,	[r2, #8]
	subcc	r5,	r5,	#1
	strcc	r5,	[r6]
	
	
end:
	pop	{r3-r6, r14}
	bx	r14

	
	.section	.data
count:	@led_on time control
	.word	0
	

	
	
