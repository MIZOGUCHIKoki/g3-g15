	.include	"common.h"
	.section	.text
	.global		judge
judge:
	push	{r0-r12, r14}

	ldr	r0,	=frame_buffer
	ldrb	r2,	[r0, #7]
	bl	read_switch		@r1

	ldr	r4,	=TIMER_BASE
	ldr	r5,	=100000	
	ldr	r6,	[r4, #GPFSEL1]	@start_time
	add	r7,	r6,	r5	@time1
	mov	r10,	#0

	
	cmp	r8,	#0
	bxne	r14

if1:	
	cmp	r1,	#1
	bne	if2
	tst	r2,	#224	@11100000
	bne	jumpclear
	b	jumpmiss

if2:
	cmp	r1,	#0
	bne	if3
	tst	r2,	#224
	beq	jumpclear
	b	jumpmiss

if3:
	cmp	r1,	#2
	bne	if4
	tst	r2,	#7	@00000111
	bne	jumpclear
	b	jumpmiss

if4:	
	cmp	r1,	#0
	bne	jumpmiss
	tst	r2,	#7
	beq	jumpclear
	b	jumpmiss

jumpclear:
	ldr	r9,	[r4, #GPFSEL1]
	cmp	r6,	r9
	blcc	led_on
	addcc	r6,	r6,	r5
	addcc	r10,	r10,	#1
	cmp	r7,	r9
	blcc	led_off
	addcc	r7,	r7,	r5
	cmp	r10,	#4
	bne	jumpclear
	b	end
jumpmiss:
	b	end

end:
	pop	{r0-r12, r14}
	bx	r14
	

	
	
