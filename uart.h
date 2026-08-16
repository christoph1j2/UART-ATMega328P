#ifndef UART_H
#define UART_H

void uart_init();
void uart_transmit(unsigned char data);
char uart_receive(void);
uint8_t uart_has_data();

void uart_printf(const char *format, ...);

#endif