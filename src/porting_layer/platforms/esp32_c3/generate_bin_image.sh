#!/bin/sh

if [ $# != 2 ]; then
  echo "Usage: $0 <SoC: esp32c3 or esp32c6> <elf file>"
  exit 1
fi

soc=$1
elf_file=$2
if [ ! -f $elf_file ]; then
  echo "*** ERROR: file $elf_file does not exist"
  exit 1
fi

esptool.py --chip $soc \
  elf2image --flash_mode dio --flash_freq 80m --flash_size 2MB \
  $elf_file

status=$?
if [ $status != 0 ]; then
  if [ $status = 127 ]; then
    echo "*** WARNING: binary image could not be generated as esptool.py was not found. To install it, run: pip3 install esptool"
    exit 0
  else
    echo "*** ERROR: esptool.py failed with error $status"
  fi

  exit 1
fi

