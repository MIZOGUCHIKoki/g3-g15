@
@ {r0} :
@ {r1} :
@ {r2} :
@ {r3} :
@ {r4} :
@ {r5} :
@ {r6} :
@ {r7} :
@ {r8} :
@ {r9} :
@ {r10} :
@ {r11} :
@ {r12} :
	.include "common.h"
	@成功したら(A)を点滅させる
	@失敗したら(A)の一つのLEDを消す
	.equ	TIMER_HZ,   100000    
	.section .text
	.global clear, miss

clear:
	push	{r2 - r4}
	ldr	r6, =TIMER_HZ
	ldr	r10, [r0, #GPFSEL1]		@点灯タスク目標時刻 (現在時刻)
	add	r11, r10, r6			@消灯タスク目標時刻
	mov	r1,  #(1 << LED_PORT)	@条件を満たした場合行う
	
	@Ok Flagを1にする
	mov 	r8,	#1
	ldr	r2,	=GPIO_BASE
	ldr	r3,	#2
	@LEDを0.1秒周期で点滅三回させる
loop:	
	ldr	r10, [r0, #GPFSEL1]	@(TIMER_BASE + CLO)番地から読み出し
	tst	r12, #(1 << 16)
	strne	r1, [r2, #GPSET0]	@1であれば点灯
	subne	r3, r3,#1
	streq	r1, [r2, #GPCLR0]	@0であれば消灯
	cmp	r3,	#0
	popeq	{r2 - r4}
	bxeq	r14
	b	loop



miss:
	@条件を満たさなかった場合行う
	@r7のスコアから１引く
	sub	r7,r7,#1

	@(A)の体力ゲージを左から一つ減らす（frame_bufferに書き込む）
	ldr	r10,=frame_buffer
	ldr	r11,[r10]
	sub	r11,r11,#1
	str	r11,[r10]

	bx	r14
