```bash
iverilog -o my_design  counter_tb.v counter.v
```

```bash
vvp my_design
```
Para finalizar simulación: `> finsih`

Al crear un archivo `./file_list.txt` puede crear el objeto de simulación como

```bash
iverilog -o my_design -c file_list.txt
vvp my_design
```
