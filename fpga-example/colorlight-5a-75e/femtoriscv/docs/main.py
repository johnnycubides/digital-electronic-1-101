from machine import UART
from time import sleep

uart_fpga = None
uart_usb = None

def init():
    global uart_usb
    global uart_fpga
    # UART0: ahora libre
    uart_usb = UART(1, baudrate=115200, tx=1, rx=3)
    # UART2: FPGA
    uart_fpga = UART(2, baudrate=57600, tx=17, rx=16)

def bridge_uart():
    while True:
        if uart_fpga.any():
            uart_usb.write(uart_fpga.read())
        if uart_usb.any():
            uart_fpga.write(uart_usb.read())
        sleep(0.001)

def start():
    init()
    bridge_uart()

