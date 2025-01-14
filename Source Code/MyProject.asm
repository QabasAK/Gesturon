
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,56 :: 		void interrupt(void){
;MyProject.c,57 :: 		if(INTCON & 0x02){
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt0
;MyProject.c,58 :: 		if(PORTD & 0x10){
	BTFSS      PORTD+0, 4
	GOTO       L_interrupt1
;MyProject.c,59 :: 		mode = 1;
	MOVLW      1
	MOVWF      _mode+0
	MOVLW      0
	MOVWF      _mode+1
;MyProject.c,60 :: 		}
	GOTO       L_interrupt2
L_interrupt1:
;MyProject.c,62 :: 		mode = 0;
	CLRF       _mode+0
	CLRF       _mode+1
;MyProject.c,63 :: 		}
L_interrupt2:
;MyProject.c,64 :: 		INTCON = INTCON & 0xFD;
	MOVLW      253
	ANDWF      INTCON+0, 1
;MyProject.c,65 :: 		}
	GOTO       L_interrupt3
L_interrupt0:
;MyProject.c,66 :: 		else if(INTCON & 0x04){
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt4
;MyProject.c,67 :: 		TMR0 = 248;
	MOVLW      248
	MOVWF      TMR0+0
;MyProject.c,68 :: 		tick++;
	INCF       _tick+0, 1
;MyProject.c,69 :: 		}
L_interrupt4:
L_interrupt3:
;MyProject.c,70 :: 		INTCON = INTCON & 0xFB;
	MOVLW      251
	ANDWF      INTCON+0, 1
;MyProject.c,72 :: 		if(PIR1 & 0x04){
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt5
;MyProject.c,73 :: 		if(a==1){
	MOVLW      0
	XORWF      _a+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt68
	MOVLW      1
	XORWF      _a+0, 0
L__interrupt68:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt6
;MyProject.c,74 :: 		if(HL){
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
;MyProject.c,75 :: 		CCPR1H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;MyProject.c,76 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;MyProject.c,77 :: 		HL = 0;
	CLRF       _HL+0
;MyProject.c,78 :: 		CCP1CON = 0x09;
	MOVLW      9
	MOVWF      CCP1CON+0
;MyProject.c,79 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;MyProject.c,80 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;MyProject.c,81 :: 		}
	GOTO       L_interrupt8
L_interrupt7:
;MyProject.c,83 :: 		CCPR1H = (40000 - angle) >> 8;
	MOVF       _angle+0, 0
	SUBLW      64
	MOVWF      R3+0
	MOVF       _angle+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      156
	MOVWF      R3+1
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;MyProject.c,84 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;MyProject.c,85 :: 		CCP1CON = 0x08;
	MOVLW      8
	MOVWF      CCP1CON+0
;MyProject.c,86 :: 		HL = 1;
	MOVLW      1
	MOVWF      _HL+0
;MyProject.c,87 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;MyProject.c,88 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;MyProject.c,89 :: 		}
L_interrupt8:
;MyProject.c,90 :: 		PIR1 &= 0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;MyProject.c,91 :: 		}
L_interrupt6:
;MyProject.c,92 :: 		PIR1 &= 0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;MyProject.c,93 :: 		}
L_interrupt5:
;MyProject.c,94 :: 		}
L_end_interrupt:
L__interrupt67:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;MyProject.c,96 :: 		void main(){
;MyProject.c,97 :: 		initialization();
	CALL       _initialization+0
;MyProject.c,98 :: 		ADC_Init();
	CALL       _ADC_Init+0
;MyProject.c,99 :: 		CCPPWM_init();
	CALL       _CCPPWM_init+0
;MyProject.c,101 :: 		OPTION_REG = 0x87;
	MOVLW      135
	MOVWF      OPTION_REG+0
;MyProject.c,102 :: 		TMR0 = 0;
	CLRF       TMR0+0
;MyProject.c,104 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;MyProject.c,105 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;MyProject.c,107 :: 		init_sonar();
	CALL       _init_sonar+0
;MyProject.c,108 :: 		HL = 1;
	MOVLW      1
	MOVWF      _HL+0
;MyProject.c,109 :: 		CCP1CON = 0x08;
	MOVLW      8
	MOVWF      CCP1CON+0
;MyProject.c,111 :: 		T1CON = 0x01;
	MOVLW      1
	MOVWF      T1CON+0
;MyProject.c,112 :: 		INTCON = 0xE0;
	MOVLW      224
	MOVWF      INTCON+0
;MyProject.c,113 :: 		PIE1 |= 0x04;
	BSF        PIE1+0, 2
;MyProject.c,115 :: 		CCPR1H = 2000 >> 8;
	MOVLW      7
	MOVWF      CCPR1H+0
;MyProject.c,116 :: 		CCPR1L = 2000;
	MOVLW      208
	MOVWF      CCPR1L+0
;MyProject.c,117 :: 		ss = 0;
	CLRF       _ss+0
	CLRF       _ss+1
;MyProject.c,119 :: 		myDelay_ms(1000);
	MOVLW      232
	MOVWF      FARG_myDelay_ms+0
	MOVLW      3
	MOVWF      FARG_myDelay_ms+1
	CALL       _myDelay_ms+0
;MyProject.c,120 :: 		while(1){
L_main9:
;MyProject.c,121 :: 		while(mode){
L_main11:
	MOVF       _mode+0, 0
	IORWF      _mode+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main12
;MyProject.c,122 :: 		xVal = ATD_read(0);  // Read x-axis
	CLRF       FARG_ATD_read_port+0
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _xVal+0
	MOVF       R0+1, 0
	MOVWF      _xVal+1
;MyProject.c,123 :: 		yVal = ATD_read(1);  // Read y-axis
	MOVLW      1
	MOVWF      FARG_ATD_read_port+0
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _yVal+0
	MOVF       R0+1, 0
	MOVWF      _yVal+1
;MyProject.c,125 :: 		if(xVal < rightThreshold){
	MOVLW      128
	XORWF      _xVal+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      1
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main70
	MOVLW      49
	SUBWF      _xVal+0, 0
L__main70:
	BTFSC      STATUS+0, 0
	GOTO       L_main13
;MyProject.c,126 :: 		RR = 305 - xVal;
	MOVF       _xVal+0, 0
	SUBLW      49
	MOVWF      _RR+0
	MOVF       _xVal+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      1
	MOVWF      _RR+1
;MyProject.c,127 :: 		RR = RR * 2;
	RLF        _RR+0, 1
	RLF        _RR+1, 1
	BCF        _RR+0, 0
;MyProject.c,128 :: 		RR = RR + 90;
	MOVLW      90
	ADDWF      _RR+0, 1
	BTFSC      STATUS+0, 0
	INCF       _RR+1, 1
;MyProject.c,129 :: 		}
L_main13:
;MyProject.c,130 :: 		if(xVal > leftThreshold){
	MOVLW      128
	XORLW      1
	MOVWF      R0+0
	MOVLW      128
	XORWF      _xVal+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main71
	MOVF       _xVal+0, 0
	SUBLW      79
L__main71:
	BTFSC      STATUS+0, 0
	GOTO       L_main14
;MyProject.c,131 :: 		LL = 335 - xVal;
	MOVF       _xVal+0, 0
	SUBLW      79
	MOVWF      R0+0
	MOVF       _xVal+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _LL+0
	MOVF       R0+1, 0
	MOVWF      _LL+1
;MyProject.c,132 :: 		LL = LL * 6 * (-1);
	MOVLW      6
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      255
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _LL+0
	MOVF       R0+1, 0
	MOVWF      _LL+1
;MyProject.c,133 :: 		LL = LL + 90;
	MOVLW      90
	ADDWF      R0+0, 0
	MOVWF      _LL+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      _LL+1
;MyProject.c,134 :: 		}
L_main14:
;MyProject.c,135 :: 		if(yVal < forwardThreshold){
	MOVLW      128
	XORWF      _yVal+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      1
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main72
	MOVLW      49
	SUBWF      _yVal+0, 0
L__main72:
	BTFSC      STATUS+0, 0
	GOTO       L_main15
;MyProject.c,136 :: 		FF = 305 - yVal;
	MOVF       _yVal+0, 0
	SUBLW      49
	MOVWF      _FF+0
	MOVF       _yVal+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      1
	MOVWF      _FF+1
;MyProject.c,137 :: 		FF = FF * 2;
	RLF        _FF+0, 1
	RLF        _FF+1, 1
	BCF        _FF+0, 0
;MyProject.c,138 :: 		FF = FF + 90;
	MOVLW      90
	ADDWF      _FF+0, 1
	BTFSC      STATUS+0, 0
	INCF       _FF+1, 1
;MyProject.c,139 :: 		}
L_main15:
;MyProject.c,140 :: 		if(yVal > backwardThreshold){
	MOVLW      128
	XORLW      1
	MOVWF      R0+0
	MOVLW      128
	XORWF      _yVal+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVF       _yVal+0, 0
	SUBLW      79
L__main73:
	BTFSC      STATUS+0, 0
	GOTO       L_main16
;MyProject.c,141 :: 		BB = 335 - yVal;
	MOVF       _yVal+0, 0
	SUBLW      79
	MOVWF      R0+0
	MOVF       _yVal+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _BB+0
	MOVF       R0+1, 0
	MOVWF      _BB+1
;MyProject.c,142 :: 		BB = BB * 6 * (-1);
	MOVLW      6
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      255
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _BB+0
	MOVF       R0+1, 0
	MOVWF      _BB+1
;MyProject.c,143 :: 		BB = BB + 90;
	MOVLW      90
	ADDWF      R0+0, 0
	MOVWF      _BB+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      _BB+1
;MyProject.c,144 :: 		}
L_main16:
;MyProject.c,147 :: 		if (xVal <= rightThreshold) {
	MOVLW      128
	XORLW      1
	MOVWF      R0+0
	MOVLW      128
	XORWF      _xVal+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVF       _xVal+0, 0
	SUBLW      49
L__main74:
	BTFSS      STATUS+0, 0
	GOTO       L_main17
;MyProject.c,148 :: 		Stop();
	CALL       _Stop+0
;MyProject.c,149 :: 		moveRight();
	CALL       _moveRight+0
;MyProject.c,150 :: 		Speed(RR);
	MOVF       _RR+0, 0
	MOVWF      FARG_Speed_p+0
	MOVF       _RR+1, 0
	MOVWF      FARG_Speed_p+1
	CALL       _Speed+0
;MyProject.c,151 :: 		}
	GOTO       L_main18
L_main17:
;MyProject.c,152 :: 		else if (xVal >= leftThreshold) {
	MOVLW      128
	XORWF      _xVal+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      1
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main75
	MOVLW      79
	SUBWF      _xVal+0, 0
L__main75:
	BTFSS      STATUS+0, 0
	GOTO       L_main19
;MyProject.c,153 :: 		Stop();
	CALL       _Stop+0
;MyProject.c,154 :: 		moveLeft();
	CALL       _moveLeft+0
;MyProject.c,155 :: 		Speed(LL);
	MOVF       _LL+0, 0
	MOVWF      FARG_Speed_p+0
	MOVF       _LL+1, 0
	MOVWF      FARG_Speed_p+1
	CALL       _Speed+0
;MyProject.c,156 :: 		}
	GOTO       L_main20
L_main19:
;MyProject.c,157 :: 		else if ( yVal >= backwardThreshold) {
	MOVLW      128
	XORWF      _yVal+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      1
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main76
	MOVLW      79
	SUBWF      _yVal+0, 0
L__main76:
	BTFSS      STATUS+0, 0
	GOTO       L_main21
;MyProject.c,158 :: 		Stop();
	CALL       _Stop+0
;MyProject.c,159 :: 		moveBackward();
	CALL       _moveBackward+0
;MyProject.c,160 :: 		Speed(BB);
	MOVF       _BB+0, 0
	MOVWF      FARG_Speed_p+0
	MOVF       _BB+1, 0
	MOVWF      FARG_Speed_p+1
	CALL       _Speed+0
;MyProject.c,161 :: 		}
	GOTO       L_main22
L_main21:
;MyProject.c,162 :: 		else if (yVal <= forwardThreshold) {
	MOVLW      128
	XORLW      1
	MOVWF      R0+0
	MOVLW      128
	XORWF      _yVal+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _yVal+0, 0
	SUBLW      49
L__main77:
	BTFSS      STATUS+0, 0
	GOTO       L_main23
;MyProject.c,163 :: 		Stop();
	CALL       _Stop+0
;MyProject.c,164 :: 		moveForward();
	CALL       _moveForward+0
;MyProject.c,165 :: 		Speed(FF);
	MOVF       _FF+0, 0
	MOVWF      FARG_Speed_p+0
	MOVF       _FF+1, 0
	MOVWF      FARG_Speed_p+1
	CALL       _Speed+0
;MyProject.c,166 :: 		}
	GOTO       L_main24
L_main23:
;MyProject.c,168 :: 		Stop();
	CALL       _Stop+0
;MyProject.c,169 :: 		Speed( 0);
	CLRF       FARG_Speed_p+0
	CLRF       FARG_Speed_p+1
	CALL       _Speed+0
;MyProject.c,170 :: 		}
L_main24:
L_main22:
L_main20:
L_main18:
;MyProject.c,172 :: 		if(PORTB & 0x01){
	BTFSS      PORTB+0, 0
	GOTO       L_main25
;MyProject.c,173 :: 		if(ss == 0){
	MOVLW      0
	XORWF      _ss+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVLW      0
	XORWF      _ss+0, 0
L__main78:
	BTFSS      STATUS+0, 2
	GOTO       L_main26
;MyProject.c,174 :: 		a = 1;
	MOVLW      1
	MOVWF      _a+0
	MOVLW      0
	MOVWF      _a+1
;MyProject.c,175 :: 		angle = 2800;
	MOVLW      240
	MOVWF      _angle+0
	MOVLW      10
	MOVWF      _angle+1
;MyProject.c,176 :: 		myDelay_ms(200);
	MOVLW      200
	MOVWF      FARG_myDelay_ms+0
	CLRF       FARG_myDelay_ms+1
	CALL       _myDelay_ms+0
;MyProject.c,177 :: 		a = 0;
	CLRF       _a+0
	CLRF       _a+1
;MyProject.c,178 :: 		ss = 1;
	MOVLW      1
	MOVWF      _ss+0
	MOVLW      0
	MOVWF      _ss+1
;MyProject.c,179 :: 		}
	GOTO       L_main27
L_main26:
;MyProject.c,181 :: 		ss = ss;
;MyProject.c,182 :: 		}
L_main27:
;MyProject.c,183 :: 		}
	GOTO       L_main28
L_main25:
;MyProject.c,185 :: 		if(ss){
	MOVF       _ss+0, 0
	IORWF      _ss+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main29
;MyProject.c,186 :: 		a = 1;
	MOVLW      1
	MOVWF      _a+0
	MOVLW      0
	MOVWF      _a+1
;MyProject.c,187 :: 		angle = 1000;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;MyProject.c,188 :: 		myDelay_ms(200);
	MOVLW      200
	MOVWF      FARG_myDelay_ms+0
	CLRF       FARG_myDelay_ms+1
	CALL       _myDelay_ms+0
;MyProject.c,189 :: 		a = 0;
	CLRF       _a+0
	CLRF       _a+1
;MyProject.c,190 :: 		ss = 0;
	CLRF       _ss+0
	CLRF       _ss+1
;MyProject.c,191 :: 		}
	GOTO       L_main30
L_main29:
;MyProject.c,193 :: 		ss = ss;
;MyProject.c,194 :: 		}
L_main30:
;MyProject.c,195 :: 		}
L_main28:
;MyProject.c,197 :: 		read_sonar();
	CALL       _read_sonar+0
;MyProject.c,198 :: 		myDelay_ms(100);
	MOVLW      100
	MOVWF      FARG_myDelay_ms+0
	MOVLW      0
	MOVWF      FARG_myDelay_ms+1
	CALL       _myDelay_ms+0
;MyProject.c,199 :: 		if(Distance < 40){
	MOVLW      0
	SUBWF      _Distance+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main79
	MOVLW      0
	SUBWF      _Distance+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main79
	MOVLW      0
	SUBWF      _Distance+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main79
	MOVLW      40
	SUBWF      _Distance+0, 0
L__main79:
	BTFSC      STATUS+0, 0
	GOTO       L_main31
;MyProject.c,200 :: 		PORTB |= 0b01000000;
	BSF        PORTB+0, 6
;MyProject.c,201 :: 		if(Distance < 10){
	MOVLW      0
	SUBWF      _Distance+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVLW      0
	SUBWF      _Distance+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVLW      0
	SUBWF      _Distance+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVLW      10
	SUBWF      _Distance+0, 0
L__main80:
	BTFSC      STATUS+0, 0
	GOTO       L_main32
;MyProject.c,202 :: 		PORTB |= 0b00100000;
	BSF        PORTB+0, 5
;MyProject.c,203 :: 		}
L_main32:
;MyProject.c,204 :: 		}
	GOTO       L_main33
L_main31:
;MyProject.c,206 :: 		PORTB &= 0b10011111;
	MOVLW      159
	ANDWF      PORTB+0, 1
;MyProject.c,207 :: 		}
L_main33:
;MyProject.c,208 :: 		}
	GOTO       L_main11
L_main12:
;MyProject.c,210 :: 		while(!mode){
L_main34:
	MOVF       _mode+0, 0
	IORWF      _mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main35
;MyProject.c,211 :: 		speed(200);
	MOVLW      200
	MOVWF      FARG_Speed_p+0
	CLRF       FARG_Speed_p+1
	CALL       _Speed+0
;MyProject.c,212 :: 		stop();
	CALL       _Stop+0
;MyProject.c,213 :: 		if(UART1_Data_Ready()){
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main36
;MyProject.c,214 :: 		received_data = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _received_data+0
;MyProject.c,215 :: 		switch (received_data)
	GOTO       L_main37
;MyProject.c,217 :: 		case 'F':
L_main39:
;MyProject.c,218 :: 		moveForward();
	CALL       _moveForward+0
;MyProject.c,219 :: 		break;
	GOTO       L_main38
;MyProject.c,220 :: 		case 'B':
L_main40:
;MyProject.c,221 :: 		moveBackward();
	CALL       _moveBackward+0
;MyProject.c,222 :: 		break;
	GOTO       L_main38
;MyProject.c,223 :: 		case 'R':
L_main41:
;MyProject.c,224 :: 		moveRight();
	CALL       _moveRight+0
;MyProject.c,225 :: 		break;
	GOTO       L_main38
;MyProject.c,226 :: 		case 'L':
L_main42:
;MyProject.c,227 :: 		moveLeft();
	CALL       _moveLeft+0
;MyProject.c,228 :: 		break;
	GOTO       L_main38
;MyProject.c,229 :: 		default:
L_main43:
;MyProject.c,230 :: 		Stop();
	CALL       _Stop+0
;MyProject.c,231 :: 		break;
	GOTO       L_main38
;MyProject.c,232 :: 		}
L_main37:
	MOVF       _received_data+0, 0
	XORLW      70
	BTFSC      STATUS+0, 2
	GOTO       L_main39
	MOVF       _received_data+0, 0
	XORLW      66
	BTFSC      STATUS+0, 2
	GOTO       L_main40
	MOVF       _received_data+0, 0
	XORLW      82
	BTFSC      STATUS+0, 2
	GOTO       L_main41
	MOVF       _received_data+0, 0
	XORLW      76
	BTFSC      STATUS+0, 2
	GOTO       L_main42
	GOTO       L_main43
L_main38:
;MyProject.c,234 :: 		if(PORTB & 0x01){
	BTFSS      PORTB+0, 0
	GOTO       L_main44
;MyProject.c,235 :: 		if(ss == 0){
	MOVLW      0
	XORWF      _ss+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main81
	MOVLW      0
	XORWF      _ss+0, 0
L__main81:
	BTFSS      STATUS+0, 2
	GOTO       L_main45
;MyProject.c,236 :: 		a = 1;
	MOVLW      1
	MOVWF      _a+0
	MOVLW      0
	MOVWF      _a+1
;MyProject.c,237 :: 		angle = 2800;
	MOVLW      240
	MOVWF      _angle+0
	MOVLW      10
	MOVWF      _angle+1
;MyProject.c,238 :: 		myDelay_ms(200);
	MOVLW      200
	MOVWF      FARG_myDelay_ms+0
	CLRF       FARG_myDelay_ms+1
	CALL       _myDelay_ms+0
;MyProject.c,239 :: 		a = 0;
	CLRF       _a+0
	CLRF       _a+1
;MyProject.c,240 :: 		ss = 1;
	MOVLW      1
	MOVWF      _ss+0
	MOVLW      0
	MOVWF      _ss+1
;MyProject.c,241 :: 		}
	GOTO       L_main46
L_main45:
;MyProject.c,243 :: 		ss = ss;
;MyProject.c,244 :: 		}
L_main46:
;MyProject.c,245 :: 		}
	GOTO       L_main47
L_main44:
;MyProject.c,247 :: 		if(ss){
	MOVF       _ss+0, 0
	IORWF      _ss+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main48
;MyProject.c,248 :: 		a = 1;
	MOVLW      1
	MOVWF      _a+0
	MOVLW      0
	MOVWF      _a+1
;MyProject.c,249 :: 		angle = 1000;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;MyProject.c,250 :: 		myDelay_ms(200);
	MOVLW      200
	MOVWF      FARG_myDelay_ms+0
	CLRF       FARG_myDelay_ms+1
	CALL       _myDelay_ms+0
;MyProject.c,251 :: 		a = 0;
	CLRF       _a+0
	CLRF       _a+1
;MyProject.c,252 :: 		ss = 0;
	CLRF       _ss+0
	CLRF       _ss+1
;MyProject.c,253 :: 		}
	GOTO       L_main49
L_main48:
;MyProject.c,255 :: 		ss = ss;
;MyProject.c,256 :: 		}
L_main49:
;MyProject.c,257 :: 		}
L_main47:
;MyProject.c,259 :: 		read_sonar();
	CALL       _read_sonar+0
;MyProject.c,260 :: 		myDelay_ms(100);
	MOVLW      100
	MOVWF      FARG_myDelay_ms+0
	MOVLW      0
	MOVWF      FARG_myDelay_ms+1
	CALL       _myDelay_ms+0
;MyProject.c,261 :: 		if(Distance < 40){
	MOVLW      0
	SUBWF      _Distance+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main82
	MOVLW      0
	SUBWF      _Distance+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main82
	MOVLW      0
	SUBWF      _Distance+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main82
	MOVLW      40
	SUBWF      _Distance+0, 0
L__main82:
	BTFSC      STATUS+0, 0
	GOTO       L_main50
;MyProject.c,262 :: 		PORTB |= 0b01000000;
	BSF        PORTB+0, 6
;MyProject.c,263 :: 		if(Distance < 10){
	MOVLW      0
	SUBWF      _Distance+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main83
	MOVLW      0
	SUBWF      _Distance+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main83
	MOVLW      0
	SUBWF      _Distance+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main83
	MOVLW      10
	SUBWF      _Distance+0, 0
L__main83:
	BTFSC      STATUS+0, 0
	GOTO       L_main51
;MyProject.c,264 :: 		PORTB |= 0b00100000;
	BSF        PORTB+0, 5
;MyProject.c,265 :: 		}
L_main51:
;MyProject.c,266 :: 		}
	GOTO       L_main52
L_main50:
;MyProject.c,268 :: 		PORTB &= 0b10011111;
	MOVLW      159
	ANDWF      PORTB+0, 1
;MyProject.c,269 :: 		}
L_main52:
;MyProject.c,270 :: 		}
L_main36:
;MyProject.c,271 :: 		}
	GOTO       L_main34
L_main35:
;MyProject.c,272 :: 		}
	GOTO       L_main9
;MyProject.c,273 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_initialization:

;MyProject.c,275 :: 		void initialization(){
;MyProject.c,276 :: 		TRISC = 0b10100000;
	MOVLW      160
	MOVWF      TRISC+0
;MyProject.c,277 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;MyProject.c,279 :: 		TRISD = 0x30;
	MOVLW      48
	MOVWF      TRISD+0
;MyProject.c,280 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;MyProject.c,282 :: 		TRISB = 0x03;
	MOVLW      3
	MOVWF      TRISB+0
;MyProject.c,283 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;MyProject.c,285 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;MyProject.c,286 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_initialization53:
	DECFSZ     R13+0, 1
	GOTO       L_initialization53
	DECFSZ     R12+0, 1
	GOTO       L_initialization53
	DECFSZ     R11+0, 1
	GOTO       L_initialization53
	NOP
;MyProject.c,287 :: 		}
L_end_initialization:
	RETURN
; end of _initialization

_CCPPWM_init:

;MyProject.c,289 :: 		void CCPPWM_init(){
;MyProject.c,290 :: 		T2CON = 0x07;
	MOVLW      7
	MOVWF      T2CON+0
;MyProject.c,291 :: 		CCP2CON = 0x0C;
	MOVLW      12
	MOVWF      CCP2CON+0
;MyProject.c,292 :: 		PR2 = 250;
	MOVLW      250
	MOVWF      PR2+0
;MyProject.c,293 :: 		CCPR2L = 125;
	MOVLW      125
	MOVWF      CCPR2L+0
;MyProject.c,294 :: 		}
L_end_CCPPWM_init:
	RETURN
; end of _CCPPWM_init

_Speed:

;MyProject.c,297 :: 		void Speed(int p){
;MyProject.c,298 :: 		CCPR2L = p;
	MOVF       FARG_Speed_p+0, 0
	MOVWF      CCPR2L+0
;MyProject.c,299 :: 		}
L_end_Speed:
	RETURN
; end of _Speed

_read_sonar:

;MyProject.c,302 :: 		void read_sonar(void) {
;MyProject.c,303 :: 		T1CON=0x10;
	MOVLW      16
	MOVWF      T1CON+0
;MyProject.c,304 :: 		T1counts = 0;
	CLRF       _T1counts+0
	CLRF       _T1counts+1
	CLRF       _T1counts+2
	CLRF       _T1counts+3
;MyProject.c,305 :: 		T1time = 0;
	CLRF       _T1time+0
	CLRF       _T1time+1
	CLRF       _T1time+2
	CLRF       _T1time+3
;MyProject.c,307 :: 		Distance = 0;
	CLRF       _Distance+0
	CLRF       _Distance+1
	CLRF       _Distance+2
	CLRF       _Distance+3
;MyProject.c,309 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;MyProject.c,310 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;MyProject.c,312 :: 		PORTC =PORTC | 0x10;
	BSF        PORTC+0, 4
;MyProject.c,313 :: 		myDelay_us(10);
	MOVLW      10
	MOVWF      FARG_myDelay_us+0
	MOVLW      0
	MOVWF      FARG_myDelay_us+1
	CALL       _myDelay_us+0
;MyProject.c,314 :: 		PORTC =PORTC & !0X10;
	MOVLW      0
	ANDWF      PORTC+0, 1
;MyProject.c,316 :: 		while (!(PORTC & 0x20));
L_read_sonar54:
	BTFSC      PORTC+0, 5
	GOTO       L_read_sonar55
	GOTO       L_read_sonar54
L_read_sonar55:
;MyProject.c,317 :: 		T1CON = 0x19;
	MOVLW      25
	MOVWF      T1CON+0
;MyProject.c,319 :: 		while (PORTC & 0x20);
L_read_sonar56:
	BTFSS      PORTC+0, 5
	GOTO       L_read_sonar57
	GOTO       L_read_sonar56
L_read_sonar57:
;MyProject.c,320 :: 		T1CON = 0x18;
	MOVLW      24
	MOVWF      T1CON+0
;MyProject.c,321 :: 		T1counts = ((TMR1H << 8) | TMR1L);
	CLRF       _T1counts+3
	MOVF       TMR1H+1, 0
	MOVWF      _T1counts+2
	MOVF       TMR1H+0, 0
	MOVWF      _T1counts+1
	CLRF       _T1counts+0
	MOVF       TMR1L+0, 0
	IORWF      _T1counts+0, 1
	MOVLW      0
	IORWF      _T1counts+1, 1
	MOVLW      0
	MOVWF      _T1counts+2
	MOVWF      _T1counts+3
;MyProject.c,322 :: 		T1time = T1counts;
	MOVF       _T1counts+0, 0
	MOVWF      _T1time+0
	MOVF       _T1counts+1, 0
	MOVWF      _T1time+1
	MOVF       _T1counts+2, 0
	MOVWF      _T1time+2
	MOVF       _T1counts+3, 0
	MOVWF      _T1time+3
;MyProject.c,324 :: 		Distance = (T1time * 34) / (1000 * 2);
	MOVF       _T1counts+0, 0
	MOVWF      R0+0
	MOVF       _T1counts+1, 0
	MOVWF      R0+1
	MOVF       _T1counts+2, 0
	MOVWF      R0+2
	MOVF       _T1counts+3, 0
	MOVWF      R0+3
	MOVLW      34
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      208
	MOVWF      R4+0
	MOVLW      7
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _Distance+0
	MOVF       R0+1, 0
	MOVWF      _Distance+1
	MOVF       R0+2, 0
	MOVWF      _Distance+2
	MOVF       R0+3, 0
	MOVWF      _Distance+3
;MyProject.c,325 :: 		if (Distance > 400) {
	MOVF       R0+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__read_sonar88
	MOVF       R0+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__read_sonar88
	MOVF       R0+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__read_sonar88
	MOVF       R0+0, 0
	SUBLW      144
L__read_sonar88:
	BTFSC      STATUS+0, 0
	GOTO       L_read_sonar58
;MyProject.c,326 :: 		Distance = 0;
	CLRF       _Distance+0
	CLRF       _Distance+1
	CLRF       _Distance+2
	CLRF       _Distance+3
;MyProject.c,327 :: 		}
L_read_sonar58:
;MyProject.c,329 :: 		T1CON = 0x01;
	MOVLW      1
	MOVWF      T1CON+0
;MyProject.c,330 :: 		}
L_end_read_sonar:
	RETURN
; end of _read_sonar

_init_sonar:

;MyProject.c,333 :: 		void init_sonar(void) {
;MyProject.c,334 :: 		T1counts = 0;
	CLRF       _T1counts+0
	CLRF       _T1counts+1
	CLRF       _T1counts+2
	CLRF       _T1counts+3
;MyProject.c,335 :: 		T1time = 0;
	CLRF       _T1time+0
	CLRF       _T1time+1
	CLRF       _T1time+2
	CLRF       _T1time+3
;MyProject.c,336 :: 		Distance = 0;
	CLRF       _Distance+0
	CLRF       _Distance+1
	CLRF       _Distance+2
	CLRF       _Distance+3
;MyProject.c,337 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;MyProject.c,338 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;MyProject.c,339 :: 		T1CON = 0x10;
	MOVLW      16
	MOVWF      T1CON+0
;MyProject.c,340 :: 		}
L_end_init_sonar:
	RETURN
; end of _init_sonar

_ADC_Init:

;MyProject.c,343 :: 		void ADC_Init() {
;MyProject.c,344 :: 		ADCON1 = 0x80;
	MOVLW      128
	MOVWF      ADCON1+0
;MyProject.c,345 :: 		ADCON0 = 0x41;
	MOVLW      65
	MOVWF      ADCON0+0
;MyProject.c,346 :: 		TRISA = 0xFF;
	MOVLW      255
	MOVWF      TRISA+0
;MyProject.c,347 :: 		PORTA = 0x00;
	CLRF       PORTA+0
;MyProject.c,348 :: 		}
L_end_ADC_Init:
	RETURN
; end of _ADC_Init

_ATD_read:

;MyProject.c,351 :: 		unsigned int ATD_read(unsigned char port) {
;MyProject.c,352 :: 		ADCON0 = (ADCON0 & 0xC7) | (port << 3);
	MOVLW      199
	ANDWF      ADCON0+0, 0
	MOVWF      R2+0
	MOVF       FARG_ATD_read_port+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      R2+0, 0
	MOVWF      ADCON0+0
;MyProject.c,353 :: 		Delay_us(10);
	MOVLW      6
	MOVWF      R13+0
L_ATD_read59:
	DECFSZ     R13+0, 1
	GOTO       L_ATD_read59
	NOP
;MyProject.c,354 :: 		ADCON0 |= 0x04;
	BSF        ADCON0+0, 2
;MyProject.c,355 :: 		while (ADCON0 & 0x04);
L_ATD_read60:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read61
	GOTO       L_ATD_read60
L_ATD_read61:
;MyProject.c,356 :: 		return ((ADRESH << 8) | ADRESL);
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;MyProject.c,357 :: 		}
L_end_ATD_read:
	RETURN
; end of _ATD_read

_myDelay_ms:

;MyProject.c,360 :: 		void myDelay_ms(unsigned int ms) {
;MyProject.c,361 :: 		tick=0;
	CLRF       _tick+0
;MyProject.c,362 :: 		while(tick<ms);
L_myDelay_ms62:
	MOVF       FARG_myDelay_ms_ms+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__myDelay_ms93
	MOVF       FARG_myDelay_ms_ms+0, 0
	SUBWF      _tick+0, 0
L__myDelay_ms93:
	BTFSC      STATUS+0, 0
	GOTO       L_myDelay_ms63
	GOTO       L_myDelay_ms62
L_myDelay_ms63:
;MyProject.c,363 :: 		}
L_end_myDelay_ms:
	RETURN
; end of _myDelay_ms

_myDelay_us:

;MyProject.c,364 :: 		void myDelay_us(unsigned int us){
;MyProject.c,365 :: 		while(us--);
L_myDelay_us64:
	MOVF       FARG_myDelay_us_us+0, 0
	MOVWF      R0+0
	MOVF       FARG_myDelay_us_us+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      FARG_myDelay_us_us+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_myDelay_us_us+1, 1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_myDelay_us65
	GOTO       L_myDelay_us64
L_myDelay_us65:
;MyProject.c,366 :: 		}
L_end_myDelay_us:
	RETURN
; end of _myDelay_us

_moveForward:

;MyProject.c,369 :: 		void moveForward() {
;MyProject.c,370 :: 		PORTD = PORTD | 0x05;
	MOVLW      5
	IORWF      PORTD+0, 1
;MyProject.c,371 :: 		}
L_end_moveForward:
	RETURN
; end of _moveForward

_moveBackward:

;MyProject.c,373 :: 		void moveBackward() {
;MyProject.c,374 :: 		PORTD = PORTD | 0x0A;
	MOVLW      10
	IORWF      PORTD+0, 1
;MyProject.c,375 :: 		}
L_end_moveBackward:
	RETURN
; end of _moveBackward

_moveRight:

;MyProject.c,377 :: 		void moveRight() {
;MyProject.c,378 :: 		PORTD= PORTD | 0x06;
	MOVLW      6
	IORWF      PORTD+0, 1
;MyProject.c,379 :: 		}
L_end_moveRight:
	RETURN
; end of _moveRight

_moveLeft:

;MyProject.c,381 :: 		void moveLeft() {
;MyProject.c,382 :: 		PORTD = PORTD | 0x09;
	MOVLW      9
	IORWF      PORTD+0, 1
;MyProject.c,383 :: 		}
L_end_moveLeft:
	RETURN
; end of _moveLeft

_Stop:

;MyProject.c,385 :: 		void Stop() {
;MyProject.c,386 :: 		PORTD = PORTD & 0x00;
	MOVLW      0
	ANDWF      PORTD+0, 1
;MyProject.c,387 :: 		}
L_end_Stop:
	RETURN
; end of _Stop
