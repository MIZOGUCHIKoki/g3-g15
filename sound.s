.include "common.h"
.section .text
.global sound
sound:
	push  {r0-r12,r14}
	bl    settings

  ldr r0 , =TIMER_BASE  @変更しない
  ldr r12, =PWM_BASE    @変更しない
  ldr r1 , =time       @目標時刻いじる際に使用
  ldr r2 , [r0, #GPFSEL1]@現在時刻
  ldr r3 , =melody      @変更しない
  ldr r4 , =rhythm      @変更しない
  ldr r5 , =sound_data  @変更しない
  ldr r6 , =rhythm_data @変更しない
  ldr r7 , =count       @変更しない
@using register --r0,r1,r2,r3,r4,r5,r6,r7
@r8は目標時刻の更新に使用する
@r9鳴らしたい音を持つレジスタ
@r10鳴らしたいリズムを持つレジスタ
@r11countの数ldr,strする用

  ldr r8 , [r1]   @音を鳴らす目標時刻をldr
@音を鳴らす時刻かどうかを確認
  cmp r2 , r8     @r2のが大の時,音を鳴らす
	bcc		mute
  ldr r11 , [r7] 
  ldrb r9 , [r3, r11]  
  ldrb r10, [r4, r11]
  ldr r9 , [r5, r9 , lsl #2]
  ldr r10, [r6, r10, lsl #2]
	add r11, r11, #1  @count更新
	ldr	r4,	=melody
	ldrb	r5,	[r4, r11]
	@cmp	r5,	#30
	@moveq r11, #0
  str r11, [r7]     @count更新後データstr
    
  @音を鳴らす
  cmp	r9 , #0
	bne	play	 
	str	r9 , [r12, #PWM_DAT2]
	b		time_apData

play:	
	str r9 , [r12, #PWM_RNG2]
  lsr r9 , r9, #1   @デューティー比を1/2
  str r9 , [r12, #PWM_DAT2]
 @r0-r8,r10,r12は変更禁止 
time_apData:
	add r9 , r8, r10
  str r9 , [r1, #0]   @音符の長さ
  mov r10, r10, lsr #1@実際になっている時間 
  add r9 , r8, r10    
  str r9 , [r1, #4]   

mute:
 @r0-r7,r12
  ldr   r8 , [r1, #4]   @消す時刻かどうか
  ldr   r2 , [r0, #GPFSEL1]
  cmp   r2 , r8   @r2のが大きい時音を消す
  movcs r9 , #0
  strcs r9 , [r12, #PWM_DAT2]

  pop {r0-r12, r14}
	bx  r14

	
  .section .data
  .global count,time
count:
  @次に鳴らしたい音.(melodyの数字)
  @現在の鳴らしている音を外部から管理する用
  .word 0
time:
@音を鳴らす目標時刻,音を消す目標時刻
  .word 0x0, 0x0
