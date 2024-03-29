#!/bin/env python3

import subprocess
import sys

def colorString(string: str, color: str):
    return f'\033[{color}m{string}\033[0m'

dryRun=False

compareTo=sys.argv[1] if len(sys.argv) > 1 else 'ORIG_HEAD'

gitDiff=subprocess.check_output(['git', 'diff-tree', '-r', '--raw', compareTo, 'HEAD'])
gitDiff=gitDiff.decode('utf-8')

lines=gitDiff.split('\n')

changedPackages: dict[str, list]={}
changeTypesRequireReStow=['A', 'C', 'D', 'R']

def isPackage(path: str):
    return path[0] != '.' and path[0] != '@' and '/' in path;

def packageName(path: str):
    return path.split('/')[0]

for line in lines:
    if len(line) == 0:
        continue

    parts=line.split('\t')
    details=parts[0].split(' ')
    file=parts[1]
    changeType=details[4][0]

    if changeType in changeTypesRequireReStow and isPackage(file):
        name=packageName(file)
        if not name in changedPackages:
            changedPackages[name]=[]

        changedPackages[name].append(f'{changeType} {file}')

if len(changedPackages) == 0:
    exit(0)

print("")
print(colorString('########################################', '1;32'))
print(colorString('#             Re Stow Files            #', '1;32'))
print(colorString('########################################', '1;32'))
print("")

packagesToReStow=[]

for package in changedPackages:
    print(f'El paquete {colorString(package, "1;33")} ha cambiado de forma disruptiva, se require reinstalarlo para evitar links rotos')
    print(colorString(f'Cambios:', '1;31'))
    for change in changedPackages[package]:
        print(colorString(f'  {change}', '1;36'))
    answer=input('Desea ponerlo en cola para reinstalar? [Y/n] ')
    if answer == 'Y' or answer == 'y' or answer == '':
        packagesToReStow.append(package)
    print("")

def runCmd(cmd: str):
    if dryRun:
        print(f'Running: {cmd}')
    else:
        print(colorString(cmd, '1;32'))
        subprocess.run(cmd.split(' '))

if len(packagesToReStow) > 0:
    for package in packagesToReStow:
        runCmd(f'dotfiles restow {package}')

print(colorString('Done', '1;32'))
