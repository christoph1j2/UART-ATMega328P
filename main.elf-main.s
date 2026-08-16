	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Aktualni teplota je %d stupnu\r\n"
	.section	.text.startup,"ax",@progbits
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call uart_init
	in r24,0x33
	andi r24,lo8(-15)
	out 0x33,r24
/* #APP */
 ;  15 "main.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	push __zero_reg__
	ldi r24,lo8(25)
	push r24
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	push r25
	push r24
	call uart_printf
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
.L2:
/* #APP */
 ;  23 "main.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	call uart_has_data
	cp r24, __zero_reg__
	breq .L3
/* #APP */
 ;  26 "main.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	call uart_receive
	call uart_transmit
	rjmp .L2
.L3:
	in r24,0x33
	ori r24,lo8(1)
	out 0x33,r24
/* #APP */
 ;  32 "main.c" 1
	sei
 ;  0 "" 2
 ;  33 "main.c" 1
	sleep
	
 ;  0 "" 2
/* #NOAPP */
	in r24,0x33
	andi r24,lo8(-2)
	out 0x33,r24
	rjmp .L2
	.size	main, .-main
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
