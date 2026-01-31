#!/usr/bin/env python3

# Vim commands:
# :LspStart pyrefly

from migen import Signal, Module, ClockDomain, ResetSignal
from migen.build.generic_platform import verilog

from div_freq import ClockDivider


class Top(Module):
    def __init__(self):
        # ClockDomain, self.cd_name -> name_clk and name_rst
        # Implicit self.cd_sys -> sys_clk and sys_rst
        # Others domains
        # Below, cd_div es publico y expuesto en el port
        # self.cd_div = cd_div = ClockDomain()  # cd_name -> div_clk + div_rst
        # Below cd_div no publico, por tanto no se expone al puerto
        self.clock_domains.cd_div = cd_div = ClockDomain(
            reset_less=False
        )  # (reset_less = True)
        # Signals Definitions port
        self.a = a = Signal()
        self.b = b = Signal()
        self.c = c = Signal()
        self.d = d = Signal()
        # Others signals
        # Synchronous actions
        self.sync += [c.eq(a & b)]  # Implicit sys_clk
        self.sync.div += [d.eq(b)]  # Explicit div_clk
        # Submodules
        self.clk_divider = clk_divider = ClockDivider()
        self.submodules += [clk_divider]
        # ClockDomain connetcing
        self.comb += [
            cd_div.clk.eq(clk_divider.clk_out),
            cd_div.rst.eq(ResetSignal("sys")),  # Rst clock domains connect a reset sys
        ]


top = Top()


# Definitions signals ports
ios = {top.a, top.b, top.c, top.d}

design = verilog.convert(fi=top, ios=ios)
design.write("top.v")
print(design)
