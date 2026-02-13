#!/usr/bin/env python3

from migen import Signal, Module, If
from board import backplane_v0 as board


# Design
# Create our platform (fpga interface)
# Create our module (fpga description)
class Blink(Module):
    def __init__(self, blink_freq, sys_clk_freq):
        # Interface
        self.led = led = Signal()
        # Internal definition
        counter = Signal(32)
        led_reg = Signal()
        # Funtional description
        # synchronous assignments
        self.sync += [
            counter.eq(counter + 1),
            If(
                counter == int((sys_clk_freq / blink_freq) / 2 - 1),
                counter.eq(0),
                led_reg.eq(~led_reg),
            ),
        ]
        # combinatorial assignements
        self.comb += [led.eq(led_reg)]


platform = board.Platform()
# clk33 = platform.request("clk33", 0)
led_pin = platform.request("user_led", 0)
my_blinker = Blink(blink_freq=8, sys_clk_freq=33.333e6)
my_blinker.comb += [led_pin.eq(my_blinker.led)]
# Build --------------------------------------------------------------------------------------------
platform.build(my_blinker, build_dir="build/gateware")
