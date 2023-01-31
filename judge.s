	.include	"common.h"
	.section	.text
	.global		judge
judge:
	push	{r0-r12, r14}

	ldr	r0,	=frame_buffer
	ldrb	r11,	[r0, #7]
	bl	read_switch		@r1

	cmp	r8,	#0
	bxne	r14

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
	bl	led_on
	b	end
jumpmiss:
	bl	miss
	b	end

end:
	pop	{r0-r12, r14}
	bx	r14
	

	
	
