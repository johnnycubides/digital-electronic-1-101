# Projecto en FPGA Cyclone IV Edition

Configurar en top.qsf

```bash
set_global_assignment -name FAMILY "Cyclone IV E"
set_global_assignment -name DEVICE EP4CE10E22C8
set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY build
```

Configurar pines a usar en archivo top.qsf

```bash
## ASIGNACIÓN DE PINES
# INPUTS
set_location_assignment PIN_58 -to b
set_location_assignment PIN_59 -to a
set_location_assignment PIN_60 -to cin
# OUTPUTS
set_location_assignment PIN_72 -to cout
set_location_assignment PIN_73 -to s
```
