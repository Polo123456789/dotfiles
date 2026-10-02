Dotfiles
========

Requiere de `stow`. Todo directorio iniciando con un `@` es ignorado por
`stow`, y esta reservado para el uso de `dotfiles`.

Uso
---

### Setup

1. Clonar el repositorio a `~/dotfiles`

2. Instalar el script `dotfiles` en `$PATH`

3. Agregar el auto completado del script al `bashrc`

   ```sh
    source ~/dotfiles/dotfiles-completion.bash
   ```

4. Agregar los hooks de git: `git config core.hooksPath @git-hooks/`

### Instalar configuraciones

Nota: Es importante que el paquete vaya antes que otros argumentos para `stow`.

```sh
dotfiles stow <paquete> --argumentos
```

### Remover configuraciones

Nota: Es importante que el paquete vaya antes que otros argumentos para `stow`.

```sh
dotfiles unstow <paquete> --argumentos
```

### Control de versiones

```sh
dotfiles git <git-cmd>
```

Agregar configuraciones existentes
----------------------------------

En `dotfiles` se crea el paquete (Usare bash como ejemplo):

```
cd ~/dotfiles
mkdir bash
```

Dentro del paquete usamos `touch` para únicamente crear los archivos en sus
lugares relativos:

```
cd bash
touch .bash_aliases
```

Y luego instalamos el paquete con la opción `--adopt`

**Nota:** Para directorios completos, se puede usar la opción `--parents` de
`cp`. (Ejemplo con la configuración de `synth-shell`)

```
cp .config/synth-shell/ dotfiles/synth-shell/ --parents -r
```

Hooks
-----

Los hooks se encuentran dentro de la carpeta `@hooks`.

Pueden ser de los siguientes tipos:

* `pre-stow`: Se ejecuta antes de instalar el paquete
* `post-stow`: Se ejecuta después de instalar el paquete
* `pre-unstow`: Se ejecuta antes de remover el paquete
* `post-unstow`: Se ejecuta después de remover el paquete

Estos se agruparan dentro de la carpeta `@hooks/<paquete>`. Cada hook tiene que
llamarse igual que el tipo de hook.

Todos los scripts pueden asumir que se encuentran en la carpeta `$HOME`, y que
la variable `$DOTFILES_CONFIG_DIR` contiene una carpeta a la que se puede
escribir, en la que podrán guardar archivos de configuración necesarios para
correr otros hooks.

Dependencias
------------

La paleta compartida de Wombat y sus instrucciones de generación y recarga
están en [@themes/wombat/README.md](@themes/wombat/README.md).

Los paquetes pueden tener dependencias, las cuales se instalaran antes de el
paquete en si. Estas se especifican en el archivo `paquete/@depends`, un
paquete por linea.

No hay ningun chequeo de dependencias ciclicas, por lo que es responsabilidad
del usuario evitarlas.

Diferentes Maquinas
-------------------

Para cambiar las configuraciones de una maquina a otra, se puede usar el
siguiente comando:

```sh
dotfiles branch-out
```

Este comando creara una rama con el hostname de la maquina actual. Luego se
puede usar el comando:

```sh
dotfiles pull-master
```

Para traer los cambios de la rama `master` a la rama del hostname.

### Escritorio plain-i3

```sh
dotfiles stow plain-i3 --simulate  # Comprueba enlaces sin ejecutar hooks
dotfiles stow plain-i3             # Instala paquetes, enlaces y preferencias
```

Aceptar las dependencias para incluir Kitty, Bash, tmux, Synth Shell, GTK y Qt.
El hook de `plain-i3` instala los paquetes de `plain-i3/@packages` que falten
mediante `sudo pacman -S --needed`; pacman conserva su confirmación habitual.
No instala paquetes de AUR ni actualiza todo el sistema.

La instalación comprueba conflictos antes de ejecutar los hooks del paquete y
se detiene si falla un hook, una dependencia o Stow. No adopta archivos locales.
Los paquetes ya enlazados también revisan sus dependencias. En ese caso, o con
`restow`, se ejecutan `pre-restow` y `post-restow` si existen. Los hooks antiguos
`pre-stow` y `post-stow` se reservan para enlaces nuevos. La simulación no ejecuta
ningún hook, así que no comprueba ni instala paquetes del sistema.

El hook de `plain-i3` aplica Adwaita oscuro, preferencia oscura y Papirus Dark;
conserva el cursor. Guarda los valores previos una sola vez en
`~/.config/dotfiles/plain-i3/*.before`. Para restaurarlos manualmente:

```sh
for key in gtk-theme color-scheme icon-theme; do
  gsettings set org.gnome.desktop.interface "$key" \
    "$(cat "$HOME/.config/dotfiles/plain-i3/$key.before")"
done
```

Requiere ejecutar la instalación como tu usuario dentro de una sesión con D-Bus.
Monocraft, Nitrogen, el script de Synth Shell y los scripts personales de
`~/scripts` siguen siendo externos: el hook avisa si faltan. Vivaldi requiere importar el ZIP guardado en el repo.
Las variables de Qt se aplican en el próximo inicio de sesión mediante `.xprofile`.
No se reinician aplicaciones automáticamente. Reinstalar vuelve a aplicar las
preferencias; desinstalar los enlaces no elimina paquetes del sistema ni restaura
preferencias automáticamente.

Pruebas del instalador, con hogares temporales y sin modificar la sesión:

```sh
PYTHONDONTWRITEBYTECODE=1 python -m unittest discover -s @tests -v
```
