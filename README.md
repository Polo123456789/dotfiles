Dotfiles
========

Mis configuraciones manejadas con stow.

Uso
---

```sh
# Clonar el repositorio a $HOME/dotfiles
cd dotfiles
stow <paquete>
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
cp .config/synth-shell/ dotfiles/synth-shell/ --parents -
```
