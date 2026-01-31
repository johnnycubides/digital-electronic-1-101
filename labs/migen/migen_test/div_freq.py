#!/usr/bin/env python3

# Vim commands:
# :LspStart pyrefly

from migen import Signal, Module


class ClockDivider(Module):
    def __init__(self):
        # ClockDomain, self.cd_name -> name_clk and name_rst
        # Implicit self.cd_sys -> sys_clk and sys_rst
        # Others domains
        # Salida: señal de reloj dividida por 2
        self.clk_out = div = Signal()
        self.clk_out = clk_out = Signal()
        self.sync += div.eq(~div)
        self.comb += [clk_out.eq(~div)]
