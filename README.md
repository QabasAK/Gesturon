# Gesturon
The implementation of a gesture-controlled robotic vehicle powered by the PIC16F877A microcontroller with two control modes:
+ **Manual Bluetooth-Based Control**
  Enabling users to operate the vehicle via a smartphone connected to **HC-06** Bluetooth module.
+ **Gesture-Based Control**
  Gesture recognition is achieved through a **GY-61 DXL335** accelerometer sensor embedded in a   glove.
 
![Untitledvideo-MadewithClipchamp2-ezgif com-speed](https://github.com/user-attachments/assets/c8244c8c-2e13-49ef-935f-f20a21e2871d)

The design allows for a robust motor control with **DC Motors** controlled with an **H-Bridge Circuit** through **PWM control** and Two-Wheel Drive System powered by **3.7V lithium-ion batteries**.

Furthermore, it uses **Infrared Sensors** and **Servo Motor** to automatically adjust the angles of the compartment. It also uses **Ultrasonic Sensors** to detect onstacles within a safe range and provides two different thresholds indicated using **LEDs** and a **Vibration Motor**. 

![Gesturon-Gesturon drawio](https://github.com/user-attachments/assets/887f59c9-d977-420c-b466-afc50dce49fe)

The system uses interrupts to efficiently handle time-sensitive events, such as sonar readings and servo motor control with **dual-positioning logic** controlled by flags. It also uses **Timer0-based** delays for task scheduling.

**Parallel/Autonomous** Mode uses the accelerometer for movement based on tilt detection (X and Y axis Value) via **ADC** and **Serial/Remote Control** Mode recieves commands ('F', 'B', 'R', 'L') via **Bluetooth**. 
The **switching** of the modes is handled by a **hardware interrupt** triggered by PORTD.
  
**Timer1** is used to calculate distance based on **echo pulse width** with a **40cm warning threshold** triggering LEDs and a **10cm critical threshold** triggering the vibration motor.

![Gesturon-Flowchart drawio](https://github.com/user-attachments/assets/dd70be47-938c-4a60-9d80-9c048338766e)

The current system implements both serial and parallel modes for controlling movement and interaction with sensors. A promising future enhancement involves integrating both modes into a unified, remote gesture-controlled system using two PIC microcontrollers and two Bluetooth modules.

![31488434953](https://github.com/user-attachments/assets/e90e1be3-aa57-4267-bbd0-cef71e599c8d)

## Contributers 
Qabas Ahmad @ [Email](qab20210786@std.psut.edu.jo)
Omar Hasan @ [Email](oma20210744@std.psut.edu.jo)
Lujain Hamdan @ [Email](loj20210576@std.psut.edu.jo)



