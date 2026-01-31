#!/usr/bin/env python3

# Vim commands:
# :LspStart pyrefly

from migen import Signal, Module
from migen.build.generic_platform import verilog


# Make module
class Top(Module):
    def __init__(self):
        self.a = a = Signal()
        self.b = b = Signal()
        self.c = c = Signal()
        self.comb += c.eq(a & b)


top = Top()

# Inputs and outputs for top module
ios = {top.a, top.b, top.c}

# Make verilog module
design = verilog.convert(fi=top, ios=ios)
# Export verilog to file
design.write("top.v")
print(design)
