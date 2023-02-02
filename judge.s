@ Free & Reserved Register
@ 0 {r0} : Free
@ 0 {r1} : Free
@ 0 {r2} : Free
@ 0 {r3} : Free
@ 0 {r4} : Free
@ 0 {r5} : Free
@ 0 {r6} : Free
@ X {r7} : 現在のスコアを管理
@ X {r8} : OK Flag
@ 0 {r9} : Free
@ 0 {r10} : Miss Flag
@ 0 {r11} : 八行目読み出し
@ 0 {r12} : =frame_buffer
	
	.include	"common.h"
	.section	.text
	.global		judge
judge:
	push	{r0-r7, r14}

	ldr	r12,	=frame_buffer
	ldrb	r11,	[r12, #7]
	bl	read_switch		@r1

	cmp	r8,	#0
	bne	clear_led

if1:	
	cmp	r1,	#1
	bne	if2
	tst	r11,	#224	@11100000
	bne	jumpclear
	b	jumpmiss

if2:
	cmp	r1,	#2
	bne	if3
	tst	r11,	#7	@00000111
	bne	jumpclear
	b	jumpmiss
	
if3:
	tst	r11,	#224
	beq	end
	tst	r11,	#7
	beq	end
	b	jumpmiss

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
jumpmiss:
	cmp	r10,	#0
	bleq	miss
	b	end

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
	@addcc	r5,	r5,	#1
	@strcc	r5,	[r6]	

	ldr	r4,	[r2, #8]
	cmp	r4,	r12
	blcc	led_off
	addcc	r4,	r4,	r11
	strcc	r4,	[r2, #8]
	subcc	r5,	r5,	#1
	strcc	r5,	[r6]
	
	
end:
	pop	{r0-r7, r14}
	bx	r14

	
	.section	.data
count:
	.word	0
	

	
	
