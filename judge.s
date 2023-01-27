	.include	"common.h"
	.section	.text
	.global		judge
judge:
	push	{r0-r12, r14}

	ldr	r0,	=frame_buffer
	ldrb	r2,	[r0, #7]
	bl	read_switch		@r1

	ldr	r0,	=TIMER_BASE
	ldr	r3,	=100000
	ldr	r4,	[r0, #GPFSEL1]
	add	r5,	r4,	r3
	mov	r7,	#0
	
	cmp	r8,	#0
	bxne	r14

if1:	
	cmp	r1,	#1
	bne	if2
	tst	r2,	#224	@11100000
	bne	jumpclear
	b	jumpmiss

if2:
	cmp	r1,	#2
	bne	if3
	tst	r2,	#7	@00000111
	bne	jumpclear
	b	jumpmiss
	
if3:
	tst	r2,	#224
	beq	end
	tst	r2,	#7
	beq	end
	b	jumpmiss

jumpclear:
	bl	clear
	ldr	r6,	[r0, #GPFSEL1]
	cmp	r4,	r6
	addcc	r4,	r4,	r3
	addcc	r7,	r7,	#1
	blcc	led_on

	cmp	r5,	r6
	addcc	r5,	r5,	r3
	blcc	led_off
	cmp	r7,	#3
	bne 	jumpclear
	
	b	end
jumpmiss:
	bl	miss
	b	end

end:
	pop	{r0-r12, r14}
	bx	r14
	

	
	
