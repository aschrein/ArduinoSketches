#include <ESP8266WiFi.h>
WiFiServer server( 80 );
void setup()
{
    pinMode( 2 , OUTPUT );
    Serial.begin( 9600 );
    delay( 100 );
    Serial.println( "" );
    Serial.println( "esp8266 is in booting state" );
    char const *ssid = "telnet_node";
    char const *password = "kolbaska";
    WiFi.mode( WIFI_STA );
    WiFi.begin( ssid , password );
    int attempt_counter = 30;
    while( WiFi.status() != WL_CONNECTED && attempt_counter-- )
    {
        delay( 100 );
        Serial.println( "trying to connect to wifi point..." );
    }
    if( WiFi.status() != WL_CONNECTED )
    {
        Serial.println( "failed" );
        return;
    }
    Serial.println( "success!" );

    server.begin();
    Serial.print( "started an http server with ip:" );
    Serial.print( WiFi.localIP() );
    Serial.println( " :80" );
}
void loop()
{
    WiFiClient client = server.available();
    if( client )
    {
        Serial.println( "got a client!" );
        client.flush();
        client.print( "<br>hello from esp8266!</br>" );
    }
    digitalWrite( 2 , HIGH );
    delay( 100 );
    digitalWrite( 2 , LOW );
    delay( 100 );
}
