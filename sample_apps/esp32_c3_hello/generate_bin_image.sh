#!/bin/sh

rm -f obj/development/partition_images.o
if [ $# != 1 ]; then
  echo "Usage: $0 <elf file>"
  exit 1
fi

elf_file=$1
if [ ! -f $elf_file ]; then
  echo "*** ERROR: file $elf_file does not exist"
  exit 1
fi

esptool.py --chip esp32c3 \
  elf2image --flash_mode dio --flash_freq 80m --flash_size 2MB \
  $elf_file

status=$?
if [ $status != 0 ]; then
  if [ $status == 127 ]; then
    echo "*** esptool.py not found. To install it, run: pip3 install esptool)"
  else
    echo "*** ERROR: esptool.py failed with error $status"
  fi

  exit 1
fi

