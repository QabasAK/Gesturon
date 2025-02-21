# Gesturon
The implementation of a gesture-controlled robotic vehicle powered by the PIC16F877A microcontroller with two control modes:
+ **Manual Bluetooth-Based Control**
  Enabling users to operate the vehicle via a smartphone connected to **HC-06** Bluetooth module.
+ **Gesture-Based Control**
  Gesture recognition is achieved through a **GY-61 DXL335** accelerometer sensor embedded in a   glove.
  
 <p align="center">
   <img src="https://github.com/user-attachments/assets/c8244c8c-2e13-49ef-935f-f20a21e2871d" alt="Gesturon" width=70%>
 </p>

The design allows for a robust motor control with **DC Motors** controlled with an **H-Bridge Circuit** through **PWM control** and Two-Wheel Drive System powered by **3.7V lithium-ion batteries**.

Furthermore, it uses **Infrared Sensors** and **Servo Motor** to automatically adjust the angles of the compartment. It also uses **Ultrasonic Sensors** to detect onstacles within a safe range and provides two different thresholds indicated using **LEDs** and a **Vibration Motor**. 

The system uses interrupts to efficiently handle time-sensitive events, such as sonar readings and servo motor control with **dual-positioning logic** controlled by flags. It also uses **Timer0-based** delays for task scheduling.

**Parallel/Autonomous** Mode uses the accelerometer for movement based on tilt detection (X and Y axis Value) via **ADC** and **Serial/Remote Control** Mode recieves commands ('F', 'B', 'R', 'L') via **Bluetooth**. 
The **switching** of the modes is handled by a **hardware interrupt** triggered by PORTD.
  
**Timer1** is used to calculate distance based on **echo pulse width** with a **40cm warning threshold** triggering LEDs and a **10cm critical threshold** triggering the vibration motor.

<p align="center">
<img src="https://github.com/user-attachments/assets/48de57ac-1350-48c9-9e45-d08298c6f062" alt="Design" width=80%>
</p>

The current system implements both serial and parallel modes for controlling movement and interaction with sensors. A promising future enhancement involves integrating both modes into a **unified, remote gesture-controlled system using two PIC microcontrollers and two Bluetooth modules**.


## Contributers 
+ Qabas Ahmad
+ Omar Hasan
+ Lujain Hamdan


