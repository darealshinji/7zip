#!/bin/sh
set -e
#set -x

# this shell script should help to show differences between
# asmc and nasm generated object files
# example: ./conv.sh 7zCrcOpt

if [ "x$1" = "x" ]; then
    exit 1
fi

if [ "$1" = "LzFindOpt" ] || [ "$1" = "LzmaDecOpt" ]; then
    list="elf64 win64"
else
    list="elf32 elf64 win32 win64"
fi


PATTERN='s|^\?_[0-9][0-9][0-9]:|      |g; s|;.*||g; / j[a-z] /d; / j[a-z][a-z] /d; /:/d'


for FMT in $list ; do
    if [ $FMT = elf64 ] ; then
        ASMC="asmc64 -elf64 -Dx64 -DABI_LINUX"
    elif [ $FMT = win64 ]; then
        ASMC="asmc64 -win64 -Dx64"
    elif [ $FMT = elf32 ]; then
        ASMC="asmc -elf -DABI_LINUX"
    else
        ASMC="asmc -coff"
    fi

    $ASMC -c -Fomasm.o x86-masm/$1.asm
    nasm -Ix86 -f$FMT -o nasm.o x86/$1.asm
    objconv -fnasm masm.o
    objconv -fnasm nasm.o
    sed -i -e "$PATTERN" masm.asm
    sed -i -e "$PATTERN" nasm.asm
    set +e
    diff -u masm.asm nasm.asm > ${1}_$FMT.diff
    #mv masm.asm masm_$FMT.asm
    #mv nasm.asm nasm_$FMT.asm
    rm -f masm.* nasm.*
    set -e
done
