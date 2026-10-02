# Wombat

Paleta tomada de `nvim/.config/nvim/colors/wombat.lua`. El fondo `#171717`
es el de Kitty, que Neovim usa porque su fondo es transparente.
La variante del escritorio usa el gris azulado `#3a4046` de Wombat para
superficies y azul `#88b8f6` con texto oscuro para selecciones. Neovim conserva
su tema original.

## Cambiar colores

Editar `palette.json` y ejecutar desde la raíz del repositorio:

```sh
python @themes/wombat/generate.py
python @themes/wombat/generate.py --check
```

Los archivos generados se guardan en Git. No necesitan Python al iniciar la
sesión. Las plantillas están en `templates/`, con la misma ruta que el archivo
de destino dentro del repositorio y el sufijo `.in`.

Los archivos funcionales de i3 usan variables de `05-wombat`. Los scripts de
i3blocks cargan `wombat.sh`; sus umbrales e intervalos son independientes de la
paleta. Rofi conserva su configuración y disposición; Dunst conserva los
ajustes de comportamiento que estaban activos, con colores en un archivo aparte.

## Instalar y recargar

Paquetes: `shared-i3`, `plain-i3`, `i3blocks`, `kitty`, `rofi`, `dunst`,
`tmux`, `synth-shell`, `gtk` y `qt`.
`plain-i3` declara Rofi y Dunst como dependencias para el comando `dotfiles stow`.
Los archivos locales existentes deben incorporarse o respaldarse antes de
instalar sus enlaces con Stow.

```sh
i3 -C -c ~/.config/i3/config
i3-msg restart
dunstctl reload
pkill -USR1 -x kitty
tmux source-file ~/.config/tmux/wombat.conf
```

Rofi lee el tema al abrirse. Reiniciar i3 conserva las ventanas y reinicia
i3blocks, que no vuelve a leer su configuración con un simple `reload` de i3.

Synth Shell usa los colores ANSI de Kitty. Las terminales nuevas leen el prompt
actualizado. Para actualizar una terminal Bash ya abierta:

```sh
source ~/.config/synth-shell/synth-shell-prompt.sh
```

Tmux carga `wombat.conf` después de sus plugins. La paleta cambia los colores
de la barra, selecciones, mensajes, paneles y ventanas emergentes, conservando
los formatos y atajos existentes. Cmus queda fuera del tema.

## Aplicaciones GTK y Qt

`gtk` añade colores a Adwaita en GTK 3 y GTK 4, incluyendo las variables
públicas de Libadwaita. Conserva las fuentes de las aplicaciones.
La preferencia oscura se activa con:

```sh
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
```

Qt 5 y Qt 6 usan su lector nativo de paletas KDE y el estilo Fusion, con
`~/.config/kdeglobals` generado desde los mismos colores. No requiere Plasma,
qt5ct, qt6ct ni Kvantum. `plain-i3/.xprofile` exporta
`QT_QPA_PLATFORMTHEME=kde`, `QT_STYLE_OVERRIDE=Fusion` y `KDE_SESSION_VERSION=5`
al iniciar sesión, y los transmite a D-Bus y systemd. La última variable permite
que Qt lea el formato moderno de `kdeglobals`; el escritorio sigue siendo i3.
Se comprobó esta vía en Qt 5 y Qt 6: el módulo GTK3 de Qt 5 no heredaba la paleta.

Las aplicaciones ya abiertas pueden requerir reiniciarse para leer el CSS.
Las aplicaciones Qt lanzadas desde procesos de una sesión anterior no heredan
las nuevas variables; abrir una nueva sesión de i3 las aplica de forma global.
Para probar una aplicación Qt antes de cerrar sesión:

```sh
QT_QPA_PLATFORMTHEME=kde KDE_SESSION_VERSION=5 QT_STYLE_OVERRIDE=Fusion nombre-de-la-aplicacion
```

Las aplicaciones con temas propios pueden ignorar parte de esta configuración.
No se modifica el contenido de páginas web.

## Iconos

GTK y Qt usan Papirus Dark con las carpetas azules predeterminadas. El cursor
sigue siendo Adwaita de 24 píxeles. La selección está en los archivos de
configuración; los archivos del tema se instalan por separado.

En Arch, instalar `papirus-icon-theme`. También se puede instalar desde el
repositorio oficial de Papirus en el usuario, como en esta máquina:

```sh
make install PREFIX="$HOME/.local" ICON_THEMES='Papirus Papirus-Dark'
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
```

Ejecutar `make` desde el código de
[Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme).
Se necesitan ambos directorios porque Papirus Dark comparte iconos con Papirus.
`plain-i3/.xprofile` restaura la selección al iniciar sesión. Las aplicaciones
Qt abiertas pueden necesitar reiniciarse para mostrar los iconos nuevos.

## Vivaldi

El generador también produce `vivaldi/Wombat-Blue.zip`, un tema importable con
fondo y barras oscuros, texto cálido y resaltados azules. Usa colores
fijos, sin tomarlos de la página abierta. No incluye fondos ni iconos externos.

En Vivaldi: Ajustes > Temas > Biblioteca > Abrir tema. Seleccionar el ZIP,
revisar la vista previa y pulsar Instalar. Si está activo el cambio de tema
según el sistema o un horario, seleccionar Wombat Blue también en ese horario.

Para actualizar la paleta, ejecutar el generador y volver a importar el ZIP.
La importación es manual; el generador no modifica el perfil del navegador.

## Criterios visuales

- Fondos oscuros y texto cálido.
- Foco blanco cálido y bordes de un píxel.
- Amarillo para avisos, rojo para errores, azul y verde para estados.
- Azul para selecciones, escritorio activo, pestañas y detalles del prompt.
- Tipografía Monocraft en terminal, lanzador, barra y notificaciones.
- La opacidad existente de Kitty se conserva, así que su fondo puede variar
  ligeramente según lo que haya detrás.

Antes de dar un cambio por terminado, comprobar la configuración, abrir Rofi,
ver una notificación y revisar Kitty y la barra en pantalla.
