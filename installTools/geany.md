# GEANY

Vídeo instalación de Geany:

[![Geany instalación y configuración](https://img.youtube.com/vi/1i6v0cj5fdY/0.jpg)](https://www.youtube.com/watch?v=1i6v0cj5fdY "Geany instalación y configuración")

* Editor de texto liviano
* Integra terminal de comandos
* Compatible con Makefile
* Altamente configurable
* Permite la lectura de archivos.md (MarkDown)

## Instalación

En debian:

```bash
sudo apt install geany geany-plugins
```

## Configuraciones

Activar los plugins:

* MarkDown
* Split window
* Tree browser

### Configurar propiedades de Markdown

El archivo `template.html` que está en el path

```bash
~/.config/geany/plugins/markdown/template.html
```

Configurar la su contenido como sigue:

```html
<html>
  <head>
    <style type="text/css">
      body {
        font-family: @@font_name@@;
        font-size: @@font_point_size@@pt;
        background-color: @@bg_color@@;
        color: @@fg_color@@;
      }
      code {
        white-space: pre-line;
        color: crimson;
        background-color: #f1f1f1;
        font-family: @@code_font_name@@;
        font-size: @@code_font_point_size@@pt;
      }
      img {
        height: 60%;
      }
    </style>
  </head>
  <body>
    @@markdown@@
  </body>
</html>
```

### Configurar botones de geany para ejecutar instrucciones

Las instrucciones referidas son aquellas que se ejecutan en terminal

Ir a **Build -> Set Build Commands** y agregar la siguiente información:

```bash
[build-menu]
FT_00_LB=simular
FT_00_CM=make sim
FT_00_WD=
FT_01_LB=sintetizar
FT_01_CM=make syn
FT_01_WD=
FT_02_LB=configurar
FT_02_CM=make config
FT_02_WD=
```

### Themas de geany

Visita el sitio [temas geany](https://www.geany.org/download/themes/), seleccione
el tema e instalar en `~/.config/geany/colorschemes/`, reinicie Geany y en **View -> Change Color Scheme**
seleccione el tema deseado

## Referencias

* [Markdown plugin](https://plugins.geany.org/markdown.html)
