```bash
set_global_assignment -name FAMILY "Cyclone IV E"
set_global_assignment -name DEVICE EP4CE10E22C8
set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY build
```
```bash
set_location_assignment PIN_23 -to clk
set_location_assignment PIN_74 -to led
```

