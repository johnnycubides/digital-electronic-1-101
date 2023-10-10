# Analizador Lógico

En este apartado se indica las instrucciones de Instalación
de un analizador lógico de 8 o 16 canales compatible con
herramientas opensource. Si hace uso de un analizador lógico del
proveedor *Saleae* podrá hacer uso de PulseView o de el [Logic Analyzer de saleae](https://www.saleae.com/downloads/).
En el caso de hacer uso de un clone basado en Cypress podrá hacer uso de
PulseView.

## Opción1: Instalación de PulseView

* Instalación del visor de formas de ondas *PulseView*
```bash
sudo apt install PulseView
```

Instalación del firmware para el analizador lógico compatible con:
* Saleae Logic
* Cypress Clone
```bash
sudo apt install sigrok-firmware-fx2lafw
```

## Opción 2: Instalación de Logic Analyzer oficial de Saleae

* Descargar el software desde la página oficial: [Download Saleae software](https://www.saleae.com/downloads/)
* Seguir las instrucciones de Instalación para sistemas basados en Debian: [Instrucciones de Instalación](https://support.saleae.com/logic-software/sw-installation#ubuntu-instructions)

## Referencias

* [PulseView](https://sigrok.org/wiki/PulseView)
* [Firmware para el analizador lógico](https://sigrok.org/wiki/Lcsoft_Mini_Board)
