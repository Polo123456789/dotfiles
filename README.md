Dotfiles
========

Requiere de `stow`

Uso
---

### Setup

1. Clonar el repositorio a `~/dotfiles`
2. Instalar el script `dotfiles` en `$PATH`
3. Agregar el autocompletado del script al `bashrc`

   ```sh
    source ~/dotfiles/dotfiles-completion.bash
   ```

### Instalar configuraciones

```sh
dotfiles stow <paquete>
```

### Remover configuraciones

```sh
dotfiles unstow <paquete>
```

### Control de versiones

```sh
dotfiles <git-cmd>
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
`cp`. (Ejemplo con la configuracion de `synth-shell`)

```
cp .config/synth-shell/ dotfiles/synth-shell/ --parents -r
```

Bash
====

Para instalar bash, asegurese de que en el bashrc este el siguiente codigo:

```sh
if [ -d "$HOME/.bashrc.d" ]
then
    for file in $HOME/.bashrc.d/*
    do
        if [ -r $file ]; then
            source $file
        fi
    done
    unset file
fi
```
