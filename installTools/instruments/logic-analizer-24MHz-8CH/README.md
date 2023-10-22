# Analizador Lógico

En este apartado se indica las instrucciones de Instalación
de un analizador lógico de 8 o 16 canales compatible con
herramientas opensource. Si hace uso de un analizador lógico del
proveedor *Saleae* podrá hacer uso de PulseView o de el [Logic Analyzer de saleae](https://www.saleae.com/downloads/).
En el caso de hacer uso de un clone basado en Cypress podrá hacer uso de
PulseView.

## Opción1: Instalación de pulseview

* Instalación del visor de formas de ondas *PulseView*
```bash
sudo apt install pulseview
```

Instalación del firmware para el analizador lógico compatible con:
* Saleae Logic
* Cypress Clone
```bash
sudo apt install sigrok-firmware-fx2lafw
```

Sino pulseview no pude ver el analizador lógico puede agregar las reglas en udev como sigue:

```bash
cd /etc/udev/rules.d/
sudo wget -O 60-libsigrok.rules "https://sigrok.org/gitweb/?p=libsigrok.git;a=blob_plain;f=contrib/60-libsigrok.rules"
sudo wget -O 61-libsigrok-plugdev.rules "https://sigrok.org/gitweb/?p=libsigrok.git;a=blob_plain;f=contrib/61-libsigrok-plugdev.rules"
sudo wget -O 61-libsigrok-uaccess.rules "https://sigrok.org/gitweb/?p=libsigrok.git;a=blob_plain;f=contrib/61-libsigrok-uaccess.rules"
sudo udevadm control --reload-rules
```

## Opción 2: Instalación de Logic Analyzer oficial de Saleae

* Descargar el software desde la página oficial: [Download Saleae software](https://www.saleae.com/downloads/)
* Seguir las instrucciones de Instalación para sistemas basados en Debian: [Instrucciones de Instalación](https://support.saleae.com/logic-software/sw-installation#ubuntu-instructions)

## Referencias

* [Manual de uso de pulseview](https://sigrok.org/doc/pulseview/0.4.1/manual.html)
* [PulseView](https://sigrok.org/wiki/PulseView)
* [Firmware para el analizador lógico](https://sigrok.org/wiki/Lcsoft_Mini_Board)
