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
@ 0 {r10} : frame_buffer
@ 0 {r11} : frame_bufferに書き込みに使用
@ 0 {r12} : Free
	.include "common.h"
	@成功したら(A)を点滅させる
	@失敗したら(A)の一つのLEDを消す
	.section .text
	.global clear, miss

clear:
	@Ok Flagを1にする
	mov 	r8,	#1
	
	bx	r14


miss:	
	mov		r10,	#1
	bx	r14
