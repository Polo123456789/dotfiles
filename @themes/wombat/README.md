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
`tmux` y `synth-shell`.
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
