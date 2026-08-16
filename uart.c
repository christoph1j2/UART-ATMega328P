#define BUFFER_SIZE 16U

#include <avr/io.h>
#include <avr/interrupt.h>

#include <stdarg.h>
#include <stdlib.h>

#include "uart.h"

volatile char rx_buffer[BUFFER_SIZE];
volatile uint8_t rx_head = 0;
volatile uint8_t rx_tail = 0;
volatile uint8_t rx_count = 0;

volatile char tx_buffer[BUFFER_SIZE];
volatile uint8_t tx_head = 0;
volatile uint8_t tx_tail = 0;
volatile uint8_t tx_count = 0;

ISR(USART_RX_vect)
{
    char c = UDR0; // UDR0 musí být přečten vždy, i když zahodíme data
    if (rx_count < BUFFER_SIZE)
    {
        rx_buffer[rx_head] = c; // ulozime znak do bufferu
        rx_head++;              // inkrementujeme head pointer
        if (rx_head == BUFFER_SIZE)
        {
            rx_head %= BUFFER_SIZE; // pokud se write index ocitne za hranici bufferu, vynulujeme jej
        }
        rx_count++; // inkrementujeme rx_count
    }
}

ISR(USART_UDRE_vect)
{
    UDR0 = tx_buffer[tx_tail];
    tx_tail++;
    tx_count--;

    if (tx_tail == BUFFER_SIZE)
    {
        tx_tail %= BUFFER_SIZE;
    }

    if (tx_count == 0)
    {
        UCSR0B &= ~(1 << UDRIE0); // vypnuti preruseni pro prazdny data registr
    }
}

void uart_init(void)
{
    // Nastaveni baud rate na 115200 (pro F_CPU 16MHz a U2X0 = 1)
    UBRR0H = 0;
    UBRR0L = 16;

    // Aktivace rezium dvojnasobne rychlosti pro vyssi presnost
    UCSR0A |= (1 << U2X0);

    // Zapnuti vysilace a prijimace
    UCSR0B |= (1 << TXEN0);
    UCSR0B |= (1 << RXEN0);
    UCSR0B |= (1 << RXCIE0); // povoleni preruseni pro prijem dat

    // (pocet bitu a parity nechavame na vychozich 8-N-1)
}

void uart_transmit(unsigned char data)
{
    while (1)
    {
        cli();
        if (tx_count < BUFFER_SIZE)
            break;
        sei();
    }

    tx_buffer[tx_head] = data; // ulozime znak do bufferu
    tx_head++;                 // inkrementujeme head pointer
    if (tx_head == BUFFER_SIZE)
    {
        tx_head %= BUFFER_SIZE; // pokud se write index ocitne za hranici bufferu, vynulujeme jej
    }
    tx_count++;
    UCSR0B |= (1 << UDRIE0);

    sei();
}

char uart_receive(void)
{
    if (rx_count == 0)
        return '\3';

    char data = rx_buffer[rx_tail]; // precteni znaku z rx bufferu
    rx_tail++;                      // inkrementujeme tail pointer

    // atomicke snizeni countu, aby nedoslo k race condition
    cli();
    rx_count--;
    sei();

    // pripadne vynulovani tail pointeru, aby nepretekl
    if (rx_tail == BUFFER_SIZE)
    {
        rx_tail %= BUFFER_SIZE;
    }

    return data;
}

uint8_t uart_has_data()
{
    return rx_count;
}

void uart_printf(const char *format, ...)
{
    va_list args;
    va_start(args, format);

    while (*format != '\0')
    {
        if (*format == '%')
        {
            switch (*(format + 1))
            {
            case 'd':
            {
                int num = va_arg(args, int);
                char num_txt[10];
                itoa(num, num_txt, 10);

                for (int i = 0; i < 10; i++)
                {
                    if (num_txt[i] != '\0')
                    {
                        uart_transmit(num_txt[i]);
                    }
                    else
                    {
                        break;
                    }
                }

                break;
            }
            default:
            {
                break;
            }
            }

            format++;
        }
        else
        {
            uart_transmit(*format);
        }
        format++;
    }

    va_end(args);
}