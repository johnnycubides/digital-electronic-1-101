#!/usr/bin/env python3

# Vim commands:
# :LspStart pyrefly

from migen import Signal, Module
from migen.build.generic_platform import verilog
from migen.fhdl.structure import DummyReg


# Make module
class Top(Module):
    def __init__(self):
        ## Interfaces
        self.a = a = Signal()
        self.b = b = Signal()
        self.c = c = Signal()

        ## Internal definitions

        ## Functional description
        self.comb += c.eq(a & b)


top = Top()

# Inputs and outputs for top module
ios = {top.a, top.b, top.c}

# Make verilog module
design = verilog.convert(fi=top, ios=ios)
# Export verilog to file
DummyReg.disable = True
design.write("top.v")
print(design)
