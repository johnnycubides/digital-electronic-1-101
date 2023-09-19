# Ejemplo de compuerta OR

![RTL compuerta OR](./top.png)

1. Síntesis
```bash
make syn
```
2. Configuración
```bash
make config
```

## Obtener RTL

* Ver el RTL del TOP:
```bash
make rtl
```

* Ver el RTL del diseño TOP y exportar a PNG:
```bash
make rtl rtl2png
```

* Ver el RTL del módulo `./gate_or.v` y exportar a PNG:
```bash
make rtl rtl2png TOP=gate_or
```
