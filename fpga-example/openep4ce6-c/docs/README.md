# OpenEP4CE-C documentación

[Oficial web](https://www.waveshare.com/wiki/OpenEP4CE6-C)

[Pdf version](./OpenEP4CE6-C-UserManual-Waveshare-Wiki.pdf)

## Overview

OpenEP4CE6-C is an FPGA development board that consists of the mother board
DVK601 and the FPGA core board CoreEP4CE6.

OpenEP4CE6-C supports further expansion with various optional accessory boards
for specific application. The modular and open design makes it the ideal for
starting application development with ALTERA Cyclone IV series FPGA devices.
OpenEP4CE6-C enables you to start your design with the Nios II processor easily
and quickly.penEP4CE6-C is an FPGA development board that consists of the
mother board DVK601 and the FPGA core board CoreEP4CE6.

OpenEP4CE6-C supports further expansion with various optional accessory boards
for specific application. The modular and open design makes it the ideal for
starting application development with ALTERA Cyclone IV series FPGA devices.
OpenEP4CE6-C enables you to start your design with the Nios II processor easily
and quickly.

## What's on the CoreEP4CE6

[Core](./CoreEP4CE6-intro.png)

1. EP4CE6E22C8N:the ALTERA Cyclone IV FPGA device which features:
  * Operating Frequency: 50MHz
  * Operating Voltage: 1.15V - 3.465V
  * Package: QFP144
  * I/Os: 80
  * LEs: 6K
  * RAM: 270kb
  * PLLs: 2
  * Debugging/Programming: supports JTAG
2. AMS1117-3.3, 3.3V voltage regulator
3. AMS1117-2.5, 2.5V voltage regulator
4. AMS1117-1.2, 1.2V voltage regulator
5. EPCS16, onboard serial FLASH memory, for storing code
6. Power indicator
7. LEDs
8. Reset button
9. nCONFIG button: for re-configuring the FPGA chip, the equivalent of power reseting
10. Power switch
11. 50M active crystal oscillator
12. 5V DC jack
13. JTAG interface: for debugging/programming
14. FPGA pins expander, VCC, GND and all the I/O ports are accessible on expansion connectors for further expansion
15. LED jumpers

## What's on the mother board

[mother-board](./DVK601-intro.png)

1. FPGA CPLD core board connector: for easily connecting core boards which integrate an FPGA CPLD chip onboard
2. 8I/Os_1 interface, for connecting accessory boards/modules
3. 8I/Os_2 interface, for connecting accessory boards/modules
4. 8I/Os_3 interface, for connecting accessory boards/modules
5. 8I/Os_4 interface, for connecting accessory boards/modules
6. 16I/Os_1 interface, for connecting accessory boards/modules
7. 16I/Os_2 interface, for connecting accessory boards/modules
8. 32I/Os_1 interface, for connecting accessory boards/modules
9. 32I/Os_2 interface, for connecting accessory boards/modules
10. FPGA expansion connectors
  - FPGA pins are accessible on expansion connectors
  - for connecting SDRAM accessory board
11. LCD interface, for connecting LCD22, LCD12864, LCD1602
12. ONE-WIRE interface: easily connects to ONE-WIRE devices (TO-92 package), such as temperature sensor (DS18B20), electronic registration number (DS2401), etc.
13. Buzzer
14. Joystick: five positions
15. Potentiometer: for LCD22 backlight adjustment, or LCD12864, LCD1602 contrast adjustment
16. Buzzer jumper
17. Joystick jumper
18. ONE-WIRE jumper

> All the I/O interfaces above:
> * Capable of being simulated as USART, I2C, SPI, PS/2, etc.
> * Capable of driving devices such as FRAM, FLASH, USB, Ethernet, etc.

> For jumpers 16-18:
>   * short the jumper to connect to I/Os used in example code
>   * open the jumper to connect to other custom pins via jumper wires

> The DVK601 supports a wide range of different core boards, therefore, some of
> the interfaces may be Not-Connected and useless while connecting to certain
> core board. For instance, while connecting to Core3S250E, the '5 8I/Os_3' and
> '4 8I/Os_4' are Not-Connected.
