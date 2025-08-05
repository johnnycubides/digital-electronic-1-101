#!/usr/bin/env python3

# Vim commands:
# :LspStart pyrefly

import sys
from migen import Signal, Module, ClockDomain
from migen.build.generic_platform import verilog


class Top(Module):
    def __init__(self):
        # ClockDomain, self.cd_name -> name_clk and name_rst
        # Implicit self.cd_sys -> sys_clk and sys_rst
        # Others domains
        self.cd_div = cd_div = ClockDomain()  # cd_name -> div_clk + div_rst
        # Signals Definitions port
        self.a = a = Signal()
        self.b = b = Signal()
        self.c = c = Signal()
        self.d = d = Signal()
        # Others signals
        # ClockDomain connecing
        # Synchronous actions
        self.sync += [c.eq(a & b)]  # Implicit sys_clk
        self.sync.div += [d.eq(b)]  # Explicit div_clk


def generate(filename="top.v"):
    top = Top()
    # Definitions signals ports
    ios = {top.a, top.b, top.c, top.d}
    design = verilog.convert(fi=top, ios=ios)
    design.write(filename)
    print(design)


if len(sys.argv) > 1:
    if sys.argv[1] == "--generate" or sys.argv[1] == "-g":
        if len(sys.argv) > 2:
            generate(filename=sys.argv[2])
        else:
            generate()
    if sys.argv[1] == "--help" or sys.argv[1] == "-h":
        print(f"{sys.argv[0]} -g filename.top")
