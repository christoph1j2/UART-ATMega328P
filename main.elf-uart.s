	.file	"uart.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
.global	__vector_18
	.type	__vector_18, @function
__vector_18:
	__gcc_isr 1
	push r30
	push r31
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 2...6 */
.L__stack_usage = 2 + __gcc_isr.n_pushed
	lds r24,198
	lds r30,rx_head
	ldi r31,0
	subi r30,lo8(-(rx_buffer))
	sbci r31,hi8(-(rx_buffer))
	st Z,r24
	lds r24,rx_head
	subi r24,lo8(-(1))
	sts rx_head,r24
	lds r24,rx_count
	subi r24,lo8(-(1))
	sts rx_count,r24
	lds r24,rx_head
	cpi r24,lo8(16)
	brne .L1
	lds r24,rx_head
	andi r24,lo8(15)
	sts rx_head,r24
.L1:
/* epilogue start */
	pop r31
	pop r30
	__gcc_isr 2
	reti
	__gcc_isr 0,r24
	.size	__vector_18, .-__vector_18
.global	__vector_19
	.type	__vector_19, @function
__vector_19:
	__gcc_isr 1
	push r30
	push r31
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 2...6 */
.L__stack_usage = 2 + __gcc_isr.n_pushed
	lds r30,tx_tail
	ldi r31,0
	subi r30,lo8(-(tx_buffer))
	sbci r31,hi8(-(tx_buffer))
	ld r24,Z
	sts 198,r24
	lds r24,tx_tail
	subi r24,lo8(-(1))
	sts tx_tail,r24
	lds r24,tx_count
	subi r24,lo8(-(-1))
	sts tx_count,r24
	lds r24,tx_tail
	cpi r24,lo8(16)
	brne .L4
	lds r24,tx_tail
	andi r24,lo8(15)
	sts tx_tail,r24
.L4:
	lds r24,tx_count
	cpse r24,__zero_reg__
	rjmp .L3
	lds r24,193
	andi r24,lo8(-33)
	sts 193,r24
.L3:
/* epilogue start */
	pop r31
	pop r30
	__gcc_isr 2
	reti
	__gcc_isr 0,r24
	.size	__vector_19, .-__vector_19
.global	uart_init
	.type	uart_init, @function
uart_init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts 197,__zero_reg__
	ldi r24,lo8(16)
	sts 196,r24
	ldi r30,lo8(-64)
	ldi r31,0
	ld r24,Z
	ori r24,lo8(2)
	st Z,r24
	ldi r30,lo8(-63)
	ld r24,Z
	ori r24,lo8(8)
	st Z,r24
	ld r24,Z
	ori r24,lo8(16)
	st Z,r24
	ld r24,Z
	ori r24,lo8(-128)
	st Z,r24
/* epilogue start */
	ret
	.size	uart_init, .-uart_init
.global	uart_transmit
	.type	uart_transmit, @function
uart_transmit:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
.L8:
	lds r25,tx_count
	cpi r25,lo8(16)
	breq .L8
	lds r30,tx_head
	ldi r31,0
	subi r30,lo8(-(tx_buffer))
	sbci r31,hi8(-(tx_buffer))
	st Z,r24
	lds r24,tx_head
	subi r24,lo8(-(1))
	sts tx_head,r24
	lds r24,tx_head
	cpi r24,lo8(16)
	brne .L9
	lds r24,tx_head
	andi r24,lo8(15)
	sts tx_head,r24
.L9:
/* #APP */
 ;  82 "uart.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r24,tx_count
	subi r24,lo8(-(1))
	sts tx_count,r24
/* #APP */
 ;  84 "uart.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	lds r24,193
	ori r24,lo8(32)
	sts 193,r24
/* epilogue start */
	ret
	.size	uart_transmit, .-uart_transmit
.global	uart_receive
	.type	uart_receive, @function
uart_receive:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r30,rx_tail
	ldi r31,0
	subi r30,lo8(-(rx_buffer))
	sbci r31,hi8(-(rx_buffer))
	ld r24,Z
	lds r25,rx_tail
	subi r25,lo8(-(1))
	sts rx_tail,r25
/* #APP */
 ;  95 "uart.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r25,rx_count
	subi r25,lo8(-(-1))
	sts rx_count,r25
/* #APP */
 ;  97 "uart.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	lds r25,rx_tail
	cpi r25,lo8(16)
	brne .L12
	lds r25,rx_tail
	andi r25,lo8(15)
	sts rx_tail,r25
.L12:
/* epilogue start */
	ret
	.size	uart_receive, .-uart_receive
.global	uart_has_data
	.type	uart_has_data, @function
uart_has_data:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,rx_count
/* epilogue start */
	ret
	.size	uart_has_data, .-uart_has_data
.global	uart_printf
	.type	uart_printf, @function
uart_printf:
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,10
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 10 */
/* stack size = 20 */
.L__stack_usage = 20
	movw r30,r28
	adiw r30,23
	ld r14,Z+
	ld r15,Z+
	mov r17,r30
	mov r16,r31
.L16:
	movw r30,r14
	ld r24,Z
	cpse r24,__zero_reg__
	rjmp .L22
/* epilogue start */
	adiw r28,10
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	ret
.L22:
	cpi r24,lo8(37)
	brne .L17
	movw r30,r14
	ldd r24,Z+1
	cpi r24,lo8(100)
	brne .L18
	mov r12,r17
	mov r13,r16
	ldi r20,lo8(10)
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	movw r30,r12
	ld r24,Z+
	ld r25,Z+
	movw r12,r30
	call __itoa_ncheck
	movw r16,r28
	subi r16,-1
	sbci r17,-1
	movw r10,r28
	ldi r31,11
	add r10,r31
	adc r11,__zero_reg__
.L20:
	movw r30,r16
	ld r24,Z
	cp r24, __zero_reg__
	breq .L19
	subi r16,-1
	sbci r17,-1
	call uart_transmit
	cp r16,r10
	cpc r17,r11
	brne .L20
.L19:
	mov r17,r12
	mov r16,r13
.L18:
	ldi r31,-1
	sub r14,r31
	sbc r15,r31
.L21:
	ldi r24,-1
	sub r14,r24
	sbc r15,r24
	rjmp .L16
.L17:
	call uart_transmit
	rjmp .L21
	.size	uart_printf, .-uart_printf
.global	tx_count
	.section .bss
	.type	tx_count, @object
	.size	tx_count, 1
tx_count:
	.zero	1
.global	tx_tail
	.type	tx_tail, @object
	.size	tx_tail, 1
tx_tail:
	.zero	1
.global	tx_head
	.type	tx_head, @object
	.size	tx_head, 1
tx_head:
	.zero	1
.global	tx_buffer
	.type	tx_buffer, @object
	.size	tx_buffer, 16
tx_buffer:
	.zero	16
.global	rx_count
	.type	rx_count, @object
	.size	rx_count, 1
rx_count:
	.zero	1
.global	rx_tail
	.type	rx_tail, @object
	.size	rx_tail, 1
rx_tail:
	.zero	1
.global	rx_head
	.type	rx_head, @object
	.size	rx_head, 1
rx_head:
	.zero	1
.global	rx_buffer
	.type	rx_buffer, @object
	.size	rx_buffer, 16
rx_buffer:
	.zero	16
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
