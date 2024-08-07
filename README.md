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
