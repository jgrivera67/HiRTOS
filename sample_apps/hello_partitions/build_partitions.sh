#!/bin/sh

cd hello_partition1
alr build
cd ../hello_partition2
alr build
cd ..
rm -f obj/development/partition_images.o
