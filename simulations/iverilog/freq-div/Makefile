help: help-sim
clean: clean-sim
# top: nombre del módulo top del diseño
# top?=top
# DESIGN: Archivos verilog (.v) del diseño, deberá agregar todos los requeridos
DESIGN+=top.v
DESIGN+=./clock_gating.v
DESIGN+=./clock_good.v
DESIGN+=./freqDiv2.v
DESIGN+=./freqDiv4.v
DESIGN+=./div_by_counter.v
DESIGN+=./freqDivAny.v
DESIGN+=./freqDivEnable.v
DESIGN+=./freqDivPlusCounter.v
DESIGN+=./counter.v
# MACROS_SIM: Reglas condicionales en el proceso de presimulación
MACROS_SIM?=
# MACROS_RTL: Reglas condicionales en el proceso ed pre sintesis del RTL
MACROS_RTL?=
# Z: Nombre base del archivo .zip en el que se empaquetará el projecto
Z?=freq-div
# tb: Archivo verilog que contiene el testbench
tb?=$(top)_tb.v

MK_SIM=../../../makefiles/sim.mk
include $(MK_SIM)
