// Definujeme frekvenci krystalu pro funkce zpoždění (16 MHz)
#define F_CPU 16000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <avr/sleep.h>

#include "uart.h"

int main(void)
{
    uart_init();
    set_sleep_mode(SLEEP_MODE_IDLE); // zapnutí IDLE režimu
    sei();                           // zapnutí hlavního jističe přerušení

    while (1)
    {
        cli(); // vypnutí přerušení, aby nedošlo k race condition při čtení rx_count
        if (uart_has_data() > 0)
        {
            sei(); // zapnutí přerušení, aby mohlo dojít k přerušení při čtení dat
            uart_transmit(uart_receive());
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