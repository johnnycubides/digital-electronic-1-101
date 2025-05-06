.include "femtorv32.inc"

.text
.global _start
.type _start, @function

_start:
.option push
.option norelax
     li   gp,IO_BASE
     li   sp,IO_HW_CONFIG_RAM	
     call main
     tail exit


