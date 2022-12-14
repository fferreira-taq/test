#include <avr/io.h>
int main(void)
{   
    DDRB = 0xFF;
    while(1)
    {
        PORTB++;
        int i; 
        for (i=0; i < 0x3FFF; i++)
        {;}
    }
}