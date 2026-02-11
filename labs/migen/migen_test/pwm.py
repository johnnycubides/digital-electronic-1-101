#!/usr/bin/env python3

# Vim commands:
# :LspStart pyrefly

from migen import Signal, Module, ClockDomain, ResetSignal, If
from migen.build.generic_platform import verilog


class PWM(Module):
    def __init__(self):
        ## Interfaces
        self.set_freq = set_freq = Signal(bits_sign=24)
        self.set_duty = set_duty = Signal(bits_sign=24)
        self.pwm = pwm = Signal()

        ## Internal
        counter = Signal(bits_sign=24)

        ## Functional description
        self.comb += [If(counter <= set_duty, pwm.eq(1)).Else(pwm.eq(0))]
        self.sync += [
            If(counter < set_freq, counter.eq(counter + 1)).Else(counter.eq(0))
        ]


top = PWM()


# Definitions signals ports
ios = {top.set_freq, top.set_duty, top.pwm}

design = verilog.convert(fi=top, ios=ios)
design.write("top.v")
print(design)
