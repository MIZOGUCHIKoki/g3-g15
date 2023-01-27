	.include	"common.h"
	.section	.text
	.global		judge
judge:
	push	{r0-r12, r14}

	ldr	r0,	=frame_buffer
	ldrb	r2,	[r0]
	bl	read_switch		@r1

	
	cmp	r8,	#0
	bne	jumpclear

if1:	
	cmp	r1,	#1
	bne	if2
	tst	r2,	#224
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
	cmp	r2,	#7
	bne	jumpclear
	b	jumpmiss

if4:	
	cmp	r1,	#0
	tst	r2,	#7
	beq	jumpclear
	b	jumpmiss

jumpclear:
	bl	clear
	b	end
jumpmiss:
	bl	miss
	b	end

end:
	pop	{r0-r12, r14}
	

	
	
