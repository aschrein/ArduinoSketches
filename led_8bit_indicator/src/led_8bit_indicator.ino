#include <Arduino.h>

#define ForEachPin for( int i = 0; i < 8; i++ )
#define PIN_OFFSET 6
void setup()
{
    ForEachPin
    {
        pinMode( i + PIN_OFFSET , OUTPUT );
    }
}
unsigned short timer = 0;
unsigned char led_timer = 0;
unsigned short flash_timer = 0;
unsigned char led_selector = 1;
unsigned char led_mask = 1;
void blink()
{
    ForEachPin
    {

        if( led_mask & ( 1 << i ) )
        {
            digitalWrite( i + PIN_OFFSET , HIGH );
        } else
        {
            digitalWrite( i + PIN_OFFSET , LOW );
        }
    }
}
void loop()
{
    if( flash_timer == 0x20 )
    {
        if( led_selector & led_timer )
        {
            led_mask = led_selector;
        }
        flash_timer = 0;
        //register unsigned char led_selector0 = led_selector;
        led_selector = led_selector << 1;
        led_selector = led_selector ? led_selector : 1;
        //asm volatile( "mov r16 , %0\n rol %0\n mov %0 , r16" : "+r" ( led_selector) : "0" ( led_selector) : "r16" );
        //led_selector = led_selector0;
    }
    if( timer == 0x500 )
    {
        led_timer++;
        timer = 0;
    }
    blink();
    timer++;
    flash_timer++;
}
