#include <REGX51.H>

#define LCD P2        // LCD data lines on Port 2
sbit RS = P3^0;       // LCD RS pin
sbit EN = P3^1;       // LCD EN pin
sbit RAIN = P1^0;     // Rain sensor digital output
sbit LED = P1^1;      // LED output pin

/* ---------------- Delay Function ---------------- */
void delay(unsigned int ms) {
    unsigned int i, j;
    for(i = 0; i < ms; i++)
        for(j = 0; j < 1275; j++);
}

/* ---------------- LCD Functions ---------------- */
void lcd_cmd(unsigned char cmd) {
    LCD = cmd;
    RS = 0;
    EN = 1;
    delay(2);
    EN = 0;
}

void lcd_data(unsigned char dat) {
    LCD = dat;
    RS = 1;
    EN = 1;
    delay(2);
    EN = 0;
}

void lcd_string(char *s) {
    while(*s) lcd_data(*s++);
}

void lcd_init() {
    lcd_cmd(0x38);   // 8-bit, 2 line, 5x7 font
    lcd_cmd(0x0C);   // Display ON, cursor OFF
    lcd_cmd(0x06);   // Auto increment cursor
    lcd_cmd(0x01);   // Clear display
    delay(5);
}

/* ---------------- Main Program ---------------- */
void main() {
    lcd_init();
    lcd_string("Rain Sensor");
    delay(1000);
    lcd_cmd(0x01);   // Clear screen

    LED = 0;         // LED OFF initially

    while(1) {
        lcd_cmd(0x80);  // Move to first line

        if(RAIN == 0) {        // LOW means rain detected
            lcd_string("Rain Detected   ");
            LED = 1;           // Turn ON LED
        } else {
            lcd_string("No Rain Detected");
            LED = 0;           // Turn OFF LED
        }

        delay(500);
    }
}
