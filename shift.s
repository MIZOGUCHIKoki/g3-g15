@ Free & Reserved Register
@ X {r0} : TIMER_BASE address.
@   {r1} : free.
@   {r2} : free.
@   {r3} : free.
@   {r4} : free.
@ X {r5} : target_time.
@ X {r6} : current_time. and frame_buffer address.
@   {r7} : free.
@   {r8} : free.
@   {r9} : free.
@   {r10}: free.
@   {r11}: free.
@ X {r12}: frame_buffer 'ldr or str'
	
	.include "common.h"
	.section .text
	.global shift
shift:
	@frame_buffer shift
	ldr	r6, =frame_buffer
	mov	r10, #6
frame_shift:
	@this frame_shift chage from B~G to C~H.
	ldrb	r12, [r6, r10]
	add	r11, r10, #1
	strb	r12, [r6, r11]
	sub	r10, r10, #1
	cmp	r10, #0
	bne	frame_shift
END:
	bx	r14
