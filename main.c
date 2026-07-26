// Definujeme frekvenci krystalu pro funkce zpoždění (16 MHz)
#define F_CPU 16000000UL
#define BUFFER_SIZE 10

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <avr/sleep.h>

#include "uart.h"

char rx_buffer[BUFFER_SIZE];
volatile uint8_t write_index = 0;
volatile uint8_t read_index = 0;
volatile uint8_t count = 0;

ISR(USART_RX_vect)
{
    rx_buffer[write_index] = UDR0; // ulozime znak do bufferu
    write_index++;                 // inkrementujeme head pointer
    count++;                       // inkrementujeme count

    if (write_index == BUFFER_SIZE)
    {
        write_index %= BUFFER_SIZE; // pokud se write index ocitne za hranici bufferu, vynulujeme jej
    }
}

int main(void)
{
    uart_init();
    set_sleep_mode(SLEEP_MODE_IDLE); // zapnutí IDLE režimu
    sei();                           // zapnutí hlavního jističe přerušení

    while (1)
    {
        cli(); // vypnutí přerušení, aby nedošlo k race condition při čtení count
        if (count > 0)
        {
            sei(); // zapnutí přerušení, aby mohlo dojít k přerušení při čtení dat

            uart_transmit(rx_buffer[read_index]);
            read_index++; // inkrementujeme tail pointer

            cli();   // vypnutí interruptů, aby nedošlo k race condition
            count--; // dekrementujeme count
            sei();   // zapnutí interruptů

            if (read_index == BUFFER_SIZE)
            {
                read_index %= BUFFER_SIZE;
            }
        }
        else
        {
            sleep_enable();  // povolíme spánek
            sei();           // zapnutí přerušení
            sleep_cpu();     // přejdeme do režimu spánku
            sleep_disable(); // po probuzení zakážeme spánek
        }
    }
    return 0;
}