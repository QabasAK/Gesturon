//variables for the servo motor
unsigned int angle;
unsigned char HL;

//variables for the ultrasonic sensor
unsigned long T1counts;
unsigned long T1time;
unsigned long Distance;

//flags
int a, ss;

//direction variables
int RR, FF, BB, LL;

//mode selection between serial or parallel
int mode;
//delay tick
unsigned char tick;

//accelerometer values
int xVal, yVal;
//bluetooth values
unsigned char received_data;

//initialization functions
void initialization();
void bluetooth_init();
void init_sonar(void);
void ADC_Init();
void CCPPWM_init();

//functions for input
unsigned int ATD_read(unsigned char port);
void read_sonar(void);
void Speed(int p);

//DC motors functions
void moveForward();
void moveBackward();
void moveLeft();
void moveRight();
void Stop();

void myDelay_ms(unsigned int);
void myDelay_us(unsigned int);

//accelerometer threshold values
const int neutralLow = 330;
const int neutralHigh = 340;
const int forwardThreshold = 305;
const int backwardThreshold = 335;
const int leftThreshold = 335;
const int rightThreshold = 305;

void interrupt(void){
    if(INTCON & 0x02){
        if(PORTD & 0x10){
            mode = 1;
        }
        else{
            mode = 0;
        }
        INTCON = INTCON & 0xFD;
    }
    else if(INTCON & 0x04){
        TMR0 = 248;
        tick++;
    }
    INTCON = INTCON & 0xFB;

    if(PIR1 & 0x04){
        if(a==1){
            if(HL){
                CCPR1H = angle >> 8;
                CCPR1L = angle;
                HL = 0;
                CCP1CON = 0x09;
                TMR1H = 0;
                TMR1L = 0;
            }
            else{
                CCPR1H = (40000 - angle) >> 8;
                CCPR1L = (40000 - angle);
                CCP1CON = 0x08;
                HL = 1;
                TMR1H = 0;
                TMR1L = 0;
            }
            PIR1 &= 0xFB;
        }
        PIR1 &= 0xFB;
    }
}

void main(){
    initialization();
    ADC_Init();
    CCPPWM_init();

    OPTION_REG = 0x87;
    TMR0 = 0;

    TMR1H = 0;
    TMR1L = 0;

    init_sonar();
    HL = 1;
    CCP1CON = 0x08;

    T1CON = 0x01;
    INTCON = 0xE0;
    PIE1 |= 0x04;

    CCPR1H = 2000 >> 8;
    CCPR1L = 2000;
    ss = 0;

    myDelay_ms(1000);
    while(1){
        while(mode){
            xVal = ATD_read(0);  // Read x-axis
            yVal = ATD_read(1);  // Read y-axis

            if(xVal < rightThreshold){
                RR = 305 - xVal;
                RR = RR * 2;
                RR = RR + 90;
            }
            if(xVal > leftThreshold){
                LL = 335 - xVal;
                LL = LL * 6 * (-1);
                LL = LL + 90;
                }
            if(yVal < forwardThreshold){
                FF = 305 - yVal;
                FF = FF * 2;
                FF = FF + 90;
            }
            if(yVal > backwardThreshold){
                BB = 335 - yVal;
                BB = BB * 6 * (-1);
                BB = BB + 90;
            }

            //moving
            if (xVal <= rightThreshold) {
                Stop();
                moveRight();
                Speed(RR);
            }
            else if (xVal >= leftThreshold) {
                Stop();
                moveLeft();
                Speed(LL);
            }
            else if ( yVal >= backwardThreshold) {
                Stop();
                moveBackward();
                Speed(BB);
            }
            else if (yVal <= forwardThreshold) {
                Stop();
                moveForward();
                Speed(FF);
            }
            else {
                Stop();
                Speed( 0);
            }

            if(PORTB & 0x01){
                if(ss == 0){
                    a = 1;
                    angle = 2800;
                    myDelay_ms(200);
                    a = 0;
                    ss = 1;
                }
                else {
                    ss = ss;
                }
            }
            else {
                if(ss){
                    a = 1;
                    angle = 1000;
                    myDelay_ms(200);
                    a = 0;
                    ss = 0;
                }
                else {
                    ss = ss;
                }
            }

            read_sonar();
            myDelay_ms(100);
            if(Distance < 40){
                PORTB |= 0b01000000;
                if(Distance < 10){
                    PORTB |= 0b00100000;
                }
            }
            else {
                PORTB &= 0b10011111;
            }
        }

        while(!mode){
            speed(200);
            stop();
            if(UART1_Data_Ready()){
                received_data = UART1_Read();
                switch (received_data)
                {
                case 'F':
                    moveForward();
                    break;
                case 'B':
                    moveBackward();
                    break;
                case 'R':
                    moveRight();
                    break;
                case 'L':
                    moveLeft();
                    break;
                default:
                    Stop();
                    break;
                }

                if(PORTB & 0x01){
                    if(ss == 0){
                        a = 1;
                        angle = 2800;
                        myDelay_ms(200);
                        a = 0;
                        ss = 1;
                    }
                    else {
                        ss = ss;
                    }
                }
                else {
                    if(ss){
                        a = 1;
                        angle = 1000;
                        myDelay_ms(200);
                        a = 0;
                        ss = 0;
                    }
                    else {
                        ss = ss;
                    }
                }

                read_sonar();
                myDelay_ms(100);
                if(Distance < 40){
                    PORTB |= 0b01000000;
                    if(Distance < 10){
                        PORTB |= 0b00100000;
                    }
                }
                else {
                    PORTB &= 0b10011111;
                }
            }
        }
    }
}

void initialization(){
    TRISC = 0b10100000;
    PORTC = 0x00;

    TRISD = 0x30;
    PORTD = 0x00;

    TRISB = 0x03;
    PORTB = 0x00;

    UART1_Init(9600);
    Delay_ms(100);
}

void CCPPWM_init(){
    T2CON = 0x07;
    CCP2CON = 0x0C;
    PR2 = 250;
    CCPR2L = 125;
}

//PWM from RC1/CCP2
void Speed(int p){
    CCPR2L = p;
}

//calculating the distance via ultrasonic
void read_sonar(void) {
    T1CON=0x10;
    T1counts = 0;
    T1time = 0;

    Distance = 0;

    TMR1H = 0;
    TMR1L = 0;

    PORTC =PORTC | 0x10;
    myDelay_us(10);
    PORTC =PORTC & !0X10;

    while (!(PORTC & 0x20));
    T1CON = 0x19;

    while (PORTC & 0x20);
    T1CON = 0x18;
    T1counts = ((TMR1H << 8) | TMR1L);
    T1time = T1counts;

    Distance = (T1time * 34) / (1000 * 2);
    if (Distance > 400) {
        Distance = 0;
    }

    T1CON = 0x01;
}

//TMR1 is OFF, Fosc/4 1:2 prescaler
void init_sonar(void) {
    T1counts = 0;
    T1time = 0;
    Distance = 0;
    TMR1H = 0;
    TMR1L = 0;
    T1CON = 0x10;
}

//ADC right justified, Vref = Vdd, PORTA input = 0
void ADC_Init() {
    ADCON1 = 0x80;
    ADCON0 = 0x41;
    TRISA = 0xFF;
    PORTA = 0x00;
}

//reading analog values from two ports
unsigned int ATD_read(unsigned char port) {
    ADCON0 = (ADCON0 & 0xC7) | (port << 3);
    Delay_us(10);
    ADCON0 |= 0x04;
    while (ADCON0 & 0x04);
    return ((ADRESH << 8) | ADRESL);
}

//delay functions
void myDelay_ms(unsigned int ms) {
    tick=0;
    while(tick<ms);
}
void myDelay_us(unsigned int us){
    while(us--);
}

//DC motors directions
void moveForward() {
    PORTD = PORTD | 0x05;
}

void moveBackward() {
    PORTD = PORTD | 0x0A;
}

void moveRight() {
    PORTD= PORTD | 0x06;
}

void moveLeft() {
    PORTD = PORTD | 0x09;
}

void Stop() {
    PORTD = PORTD & 0x00;
}
