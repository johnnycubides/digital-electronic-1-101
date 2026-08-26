# Digital Logic Design

Instala y activa las herramientas externas utilizadas para diseño de lógica
digital. El script mantiene las aplicaciones bajo
`~/gitPackages/digital-logic-design-tools`. La activación del toolchain no
modifica permanentemente el entorno. La instalación de Lite XL agrega su
enlace ejecutable, configuración de usuario y entrada de escritorio.

Herramientas instaladas:

- OSS CAD Suite 2026-07-24, con Yosys, Icarus Verilog, GTKWave, Surfer,
  nextpnr, IceStorm, openFPGALoader y Verilator;
- Verible v0.0-4084-gf3e4d98b;
- Netlist2SVG v1.2.1, para generar diagramas SVG desde netlists de Yosys;
- Digital v0.31, simulador de lógica de Helmut Neemann;
- Qucs-S v26.1.1, simulador de circuitos con ngspice;
- Lite XL v2.1.8, editor configurado para Verilog y SystemVerilog;
- LiteX 2026.04, framework para construir sistemas SoC sobre FPGA, con
  configuración `standard` o `full`.

## Qué incluye OSS CAD Suite

OSS CAD Suite es una distribución autocontenida para diseño y verificación de
lógica digital. La release instalada contiene alrededor de 165 ejecutables y
scripts auxiliares. La siguiente tabla resume las familias principales, no
pretende enumerar cada comando interno:

| Área | Herramientas principales | Uso |
|---|---|---|
| Síntesis RTL | Yosys, ABC, GHDL y Slang | Sintetizar Verilog, integrar VHDL y analizar SystemVerilog. |
| HDL en Python | Amaranth y Migen | Describir y generar hardware mediante Python. |
| Simulación | Icarus Verilog, VVP, Verilator, GHDL y cocotb | Simular Verilog, SystemVerilog y VHDL, incluidos testbenches en Python. |
| Formas de onda | GTKWave, Surfer y Surver | Examinar VCD, FST y otros formatos, localmente o mediante el modo servidor de Surfer. |
| Verificación formal | SBY, SBY GUI, MCY, EQY, AIGER, Avy y Pono | Verificar propiedades, equivalencia y cobertura por mutación. |
| Solvers formales | Boolector, Bitwuzla, Yices, Z3, cvc5 y rIC3 | Resolver los problemas SAT y SMT generados por los flujos formales. |
| Place and route | nextpnr para iCE40, ECP5, Nexus, MachXO2, Himbaechel y arquitecturas genéricas | Implementar el netlist sintetizado sobre la FPGA seleccionada. |
| Bitstreams Lattice | Project IceStorm, Project Trellis y Project Oxide | Empaquetar, desempaquetar y analizar bitstreams iCE40, ECP5 y Nexus. |
| Bitstreams Gowin | Project Apicula, incluidos `gowin_pack` y `gowin_unpack` | Generar y analizar bitstreams para familias Gowin compatibles. |
| Programación y depuración | openFPGALoader, OpenOCD, dfu-util, ecpprog, ecpdap, fujprog, tinyprog y programadores iCE40 | Cargar bitstreams, escribir memorias flash y acceder a interfaces JTAG o DFU. |

La suite también proporciona sus propias bibliotecas, bases de datos de
dispositivos y entorno Python. No todos los proyectos usan todas estas
herramientas. Para un flujo típico:

```text
Verilog/SystemVerilog -> Yosys -> nextpnr -> packer -> openFPGALoader
                              |
                              +-> SBY + solver, para verificación formal

Testbench -> Icarus Verilog o Verilator -> VCD/FST -> Surfer o GTKWave
```

Las versiones exactas quedan fijadas por la release de OSS CAD Suite indicada
arriba. Esto evita mezclar componentes de distintas fechas dentro de un mismo
flujo.

No se instala ni se requiere Conda. Las herramientas que antes estaban en el
entorno Conda se obtienen desde OSS CAD Suite, APT, npm o sus releases
oficiales.

El comando `dependencies` instala además Picocom, PulseView, el firmware sigrok
para analizadores FX2, ngspice y el compilador bare-metal
`riscv64-unknown-elf-gcc`. Node.js y npm se instalan por APT solamente cuando
el comando `node` no existe.

## Requisitos

En Debian:

```bash
sudo apt update
sudo apt install \
  build-essential \
  coreutils \
  curl \
  default-jre \
  desktop-file-utils \
  gcc \
  gcc-riscv64-unknown-elf \
  git \
  ngspice \
  picocom \
  pulseview \
  python3-venv \
  shared-mime-info \
  sigrok-firmware-fx2lafw \
  tar \
  unzip \
  wget
```

Netlist2SVG requiere Node.js y npm.
`./digital-logic-design.sh dependencies` conserva una instalación existente de
Node.js, por ejemplo una administrada mediante nvm.
Si `node` no está disponible, instala `nodejs` y `npm` desde APT. Si encuentra
`node` pero no encuentra `npm`, se detiene para evitar mezclar instalaciones y
muestra cómo corregirlo.

## Instalar

Desde este directorio:

```bash
./digital-logic-design.sh dependencies
./digital-logic-design.sh install
```

La primera ejecución instala los paquetes APT, descarga los releases y extrae
las herramientas. Los artefactos descargados directamente se verifican con
SHA256. Netlist2SVG se instala desde npm con una versión fija. Las
ejecuciones siguientes reutilizan las instalaciones existentes.

También se puede instalar una sola herramienta:

```bash
digital-logic-design oss_cad_suite
digital-logic-design verible
digital-logic-design netlist2svg
digital-logic-design digital
digital-logic-design qucs_s
digital-logic-design lite_xl
digital-logic-design litex standard
```

## Acceso desde cualquier directorio

El instalador crea un enlace simbólico portable dentro de `~/.local/bin`:

```text
~/.local/bin/digital-logic-design
```

También se puede crear o comprobar explícitamente con:

```bash
./digital-logic-design.sh launcher
```

Si `~/.local/bin` está en `PATH`, los comandos de instalación quedan
disponibles desde cualquier directorio:

```bash
digital-logic-design help
digital-logic-design litex standard
digital-logic-design oss_cad_suite
```

La activación también puede localizar el script mediante `PATH`:

```bash
source digital-logic-design activate
source digital-logic-design deactivate
```

El nombre anterior `digital-logic-design.sh` puede conservarse como alias para
compatibilidad, pero la documentación y las nuevas instalaciones usan
`digital-logic-design` como comando principal.

LiteX se instala de forma predeterminada con la configuración `standard`, que
incluye Migen, LiteX, LiteX Boards y los cores de uso común. Para instalar el
conjunto completo de cores y CPU compatibles:

```bash
digital-logic-design litex full
```

La instalación usa la release fija 2026.04 y un entorno virtual privado dentro
de su propio directorio. Las herramientas de construcción Python que necesita
el entorno, incluidas Meson, Setuptools y Wheel, también usan versiones fijas.
No modifica el Python del sistema ni usa Conda. El comando `install`, y por
extensión `all`, usa `standard` de forma predeterminada. Se puede seleccionar
`full` para estos comandos mediante:

```bash
export LITEX_CONFIG=full
source digital-logic-design all
```

Durante la instalación de Lite XL, el editor se abre para crear su
configuración. Se debe cerrar para que continúe la instalación de plugins.

## Activar

La activación debe hacerse con `source` para modificar el entorno de la
terminal actual:

```bash
source digital-logic-design activate
```

Para instalar y activar con un solo comando:

```bash
source digital-logic-design all
```

## Comprobar

```bash
command -v yosys
command -v nextpnr-ice40
command -v iverilog
command -v openFPGALoader
command -v iceprog
command -v verilator
command -v gtkwave
command -v surfer
command -v surver
command -v verible-verilog-lint
command -v verible-verilog-format
command -v verible-verilog-ls
command -v netlist2svg
command -v digital
command -v qucs-s
command -v qucs
command -v lite-xl
command -v litex_sim
command -v litex_server
command -v litex_term
command -v litex_cli
command -v riscv64-unknown-elf-gcc
command -v dot
command -v ngspice
command -v picocom
command -v pulseview
java -version
python3 --version
python3 -c 'import litex, migen, litedram, liteeth'
```

## Netlist2SVG

Netlist2SVG recibe un netlist JSON generado por Yosys:

```bash
yosys -p 'prep -top top; write_json netlist.json' design.v
netlist2svg netlist.json -o netlist.svg
```

Para expandir un nivel de jerarquía con cualquier diseño, usa la configuración
general incluida en este directorio:

```bash
netlist2svg netlist.json \
  --config netlist2svg-hierarchy-level-1.json \
  -o netlist-hierarchy-level-1.svg
```

La selección automática del módulo superior permanece activa. No es necesario
editar la configuración para indicar el nombre del módulo principal.

Para abrir Digital:

```bash
digital
```

También se puede abrir directamente un circuito:

```bash
digital ruta/al/circuito.dig
```

Para abrir Lite XL:

```bash
lite-xl
```

Para abrir Qucs-S:

```bash
qucs-s
```

## Surfer

Surfer es un visor moderno de formas de onda escrito en Rust. Ofrece una
interfaz rápida, búsqueda difusa, cursores, recarga de archivos, selección de
señales, formatos numéricos configurables y soporte para VCD, FST y GHW. Su
interfaz nativa funciona en Linux con Wayland y X11. También existe una versión
web y un modo cliente-servidor mediante `surver`.

No se instala una copia separada: OSS CAD Suite ya incluye una compilación
nativa compatible con el resto del toolchain. Después de activar el entorno:

```bash
surfer ruta/a/formas-de-onda.vcd
surfer ruta/a/formas-de-onda.fst
surfer ruta/a/formas-de-onda.ghw
```

Para servir una forma de onda y abrirla desde otro equipo:

```bash
surver ruta/a/formas-de-onda.vcd
```

GTKWave permanece disponible. Surfer es una alternativa más moderna y rápida,
pero GTKWave sigue siendo útil para formatos heredados y flujos que dependen de
su comportamiento específico.

## Analizador lógico

El comando `digital-logic-design dependencies` instala PulseView y el firmware
`sigrok-firmware-fx2lafw` para analizadores basados en Cypress FX2, incluidos
los clones de 8 y 16 canales. El paquete libsigrok de Debian instala también
las reglas udev necesarias.

Después de conectar el analizador, se puede comprobar su detección desde
PulseView. Si se instalaron o actualizaron reglas con el dispositivo ya
conectado, se debe desconectar y volver a conectar antes de probar.

## Desactivar

```bash
source digital-logic-design deactivate
```

El comando restaura el `PATH` existente antes de la activación, incluyendo las
rutas agregadas para Verible, Netlist2SVG, Digital, Qucs-S y LiteX.
El comando `deactivate` proporcionado por OSS CAD Suite también permanece
disponible mientras el entorno está activo.

## Ubicaciones

Instalaciones predeterminadas:

```text
~/gitPackages/digital-logic-design-tools/
├── oss-cad-suite-2026-07-24/
├── verible-v0.0-4084-gf3e4d98b/
├── netlist2svg-1.2.1/
├── digital-v0.31/
├── qucs-s-26.1.1/
├── lite-xl/
├── lite-xl-terminal/
└── litex-2026.04/
    ├── venv/
    ├── litex/
    ├── litex-boards/
    ├── litedram/
    ├── liteeth/
    └── ...
```

## LiteX y toolchains de fabricante

La instalación de LiteX incluye el framework abierto, sus placas y sus cores.
No instala toolchains propietarios. Para construir proyectos Efinix Trion o
Titanium todavía se debe instalar Efinity por separado y definir la ruta
correspondiente, por ejemplo:

```bash
export LITEX_ENV_EFINITY=/ruta/a/efinity/2024.2
```

La ruta de Efinity no se fija dentro de este instalador porque depende de la
máquina, la versión licenciada y el proyecto.

Archivos descargados:

```text
~/.cache/digital-logic-design/
```

Se pueden cambiar las ubicaciones antes de activar:

```bash
export DIGITAL_LOGIC_INSTALL_ROOT="$HOME/tools"
export DIGITAL_LOGIC_CACHE_DIR="$HOME/Downloads/digital-logic-design"
source digital-logic-design all
```

## Actualizar una herramienta

Las versiones, URLs, SHA256 aplicables y rutas están declaradas al comienzo de
`digital-logic-design.sh`, agrupadas por herramienta.

Para actualizar:

1. cambia las variables de la herramienta al comienzo de `digital-logic-design.sh`;
2. ejecuta la función correspondiente, por ejemplo `digital-logic-design digital`;
3. comprueba los proyectos con la nueva versión;
4. conserva la versión anterior hasta terminar la validación.

No reemplaces archivos individuales dentro de una instalación ya extraída.

Para ver todos los comandos disponibles:

```bash
digital-logic-design help
```

Fuentes oficiales:

- <https://github.com/YosysHQ/oss-cad-suite-build/releases>
- <https://github.com/chipsalliance/verible/releases>
- <https://github.com/johnnycubides/netlist2svg>
- <https://www.npmjs.com/package/@johnnycubides/netlist2svg>
- <https://github.com/hneemann/Digital/releases/tag/v0.31>
- <https://github.com/ra3xdh/qucs_s/releases/tag/26.1.1>
- <https://github.com/lite-xl/lite-xl/releases/tag/v2.1.8>
- <https://github.com/enjoy-digital/litex/tree/2026.04>
- <https://github.com/enjoy-digital/litex/wiki/Installation>
- <https://surfer-project.org/>
- <https://docs.surfer-project.org/>
- <https://gitlab.com/surfer-project/surfer>
- <https://github.com/johnnycubides/swissknife/tree/master/bash/installs/lite-xl>
- <https://sigrok.org/wiki/PulseView>
- <https://sigrok.org/wiki/Lcsoft_Mini_Board>
