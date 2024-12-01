# Documentación para BlackIce40

![BlackIce40](https://raw.githubusercontent.com/folknology/BlackIceMx/master/BlackIceMx-Fully-loaded.JPG)

## Pinout de la BlackIce40

![Pinout para la blackice40](./resources/blackice-mx-pinout.png)

* [Esquemáticos sobre la tarjeta de desarrollo BlackIce40](./resources/BlackIceMx-Schematic.pdf)
* [Esquemático sobre el núcleo BlackIce40](./resources/IceCore-Schematic.pdf)
* [Physical Constraints file (.pcf) para BlackIce40](./resources/blackice-mx.pcf)

> Sobre la configuración: Al oprimir el botón **mode** si el led naranja se enciende
> indica que podrá hacer la configuración desde la memoria flash; la configuración
> será cargada en la flash de la IceCore y en cada reinicio se cargará tal configuración.

## Vídeos útiles

1. [Configuración volátil y persistente para blackice2 ice40](https://www.youtube.com/watch?v=lVM3kEyNgYA):
  En este vídeo se muestra el procedimiento para configurar la ice40 ya sea de manera volátil (configurando a través de memoria CRAM),
  de persistente (subiendo el bitstream a la memoria flash de la placa de desarrollo).

[![Configuración volátil y persistente para blackice2 ice40](https://img.youtube.com/vi/lVM3kEyNgYA/0.jpg)](https://www.youtube.com/watch?v=lVM3kEyNgYA "Configuración volátil y persistente para blackice2 ice40")



## Referencias

* [Datasheet familias ice40](../resource-ice40/iCE40LPHXFamilyDataSheet.pdf)
* [Resumen familias ice40](../resource-ice40/HX640.PDF)
* [Manejo de memorias RAM en las ice40](../resource-ice40/FPGA-TN-02002-1-7-Memory-Usage-Guide-for-iCE40-Devices.pdf)
* [Github page de la BlackIceMx (core y shield)](https://lawrie.github.io/blackicemxbook/GettingStarted/GettingStarted.html)
* [Archivos fuentes IceCore](https://github.com/folknology/IceCore)
* [Archivos fuente del BlackIceMx Shield](https://github.com/folknology/BlackIceMx)
* [Formato del archivo .pcf en ice40](https://github.com/YosysHQ/nextpnr/blob/master/docs/ice40.md)
* [Ejemplos con ice40](https://github.com/nesl/ice40_examples)
* [System on chip para la blackice](https://github.com/lawrie/blacksoc/tree/master)
* [Ejemplo de echo por uart](https://github.com/folknology/IceCore/tree/USB-CDC-issue-3/Examples/line-echo)
