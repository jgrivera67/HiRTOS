ALIRE_DIR=/opt/alire
#export PATH=$ALIRE_DIR/bin:/opt/tkdiff:/opt/fuzz/bin:/opt/arm-gnu-toolchain/bin:/opt/gnatstudio:$PATH
export PATH=/opt/gcc-14.2.0-3-aarch64/bin:$ALIRE_DIR/bin:~/.alire/bin:/opt/tkdiff:/opt/fuzz/bin:/opt/arm-gnu-toolchain/bin:$PATH

export OS=macOS

export GPR_FILE=hirtos.gpr
#export ARMFVP_DIR=$HOME/my-apps/AEMv8R_base_pkg
export ARMFVP_DIR=/opt/FVP_Base_AEMv8R/AEMv8R_base_pkg
export ARMFVP_BIN_PATH=$ARMFVP_DIR/models/Linux64_GCC-9.3
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ARMFVP_DIR/fmtplib
#export FUZZLIB=/usr/local/lib/fuzzlib
export FUZZLIB=/opt/fuzz/lib/fuzzlib

export GIT_EXTERNAL_DIFF=tkdiff

alias v='gvim -U ide_env.vim'

function run_fvp {
   typeset elf_file

   if [ $# != 1 ]; then
        echo "Usage: $FUNCNAME <elf file>"
        return 1
   fi

   elf_file=$1

   #
   # NOTE:
   # - `cluster0.gicv3.SRE-EL2-enable-RAO=1` and `cluster0.gicv3.cpuintf-mmap-access-level=2`
   #   are needed to enable access to the GIC CPU interface's system registers
   # - `bp.refcounter.non_arch_start_at_default=1` enables the system counter that drives
   #   the generic timer counter.
   #
   $ARMFVP_BIN_PATH/FVP_BaseR_AEMv8R \
           -C bp.pl011_uart0.uart_enable=1 \
           -C bp.pl011_uart0.baud_rate=460800 \
           -C bp.pl011_uart1.uart_enable=1 \
           -C bp.pl011_uart1.baud_rate=460800 \
           -C bp.pl011_uart2.uart_enable=1 \
           -C bp.pl011_uart2.baud_rate=460800 \
           -C bp.pl011_uart3.uart_enable=1 \
           -C bp.pl011_uart3.baud_rate=460800 \
           -C cluster0.gicv3.SRE-EL2-enable-RAO=1 \
           -C cluster0.gicv3.cpuintf-mmap-access-level=2 \
           -C bp.refcounter.non_arch_start_at_default=1 \
	   --application $elf_file #--log ~/tmp/fvp-run.log

	   #-C cci400.force_on_from_start=1 \
           #-C bp.sram.enable_atomic_ops=1 \
           #-C cci400.force_on_from_start=1 \
           #-C cluster0.gicv3.EOI-check-ID=1 \
           #-C cluster0.gicv3.EOI-check-CPUID=1 \
}

function run_fvp_with_trace {
   typeset elf_file

   if [ $# != 1 ]; then
        echo "Usage: $FUNCNAME <elf file>"
        return 1
   fi

   elf_file=$1
   $ARMFVP_BIN_PATH/FVP_BaseR_AEMv8R \
	   --plugin=$ARMFVP_DIR//plugins/Linux64_GCC-9.3/TarmacTrace.so \
	   --parameter TRACE.TarmacTrace.trace-file="STDERR" \
           -C bp.pl011_uart0.uart_enable=1 \
           -C bp.pl011_uart0.baud_rate=115200 \
           -C cluster0.gicv3.SRE-EL2-enable-RAO=1 \
           -C cluster0.gicv3.cpuintf-mmap-access-level=2 \
           -C bp.refcounter.non_arch_start_at_default=1 \
	   -C cci400.force_on_from_start=1 \
	   --application $elf_file # 2> ~/tmp/fvp-trace.pipe
}

function gen_lst_riscv
{
    typeset elf_file
    typeset usage_msg

    usage_msg="Usage: gen_lst_riscv <elf file>"

    if [ $# != 1 ]; then
        echo $usage_msg
        return 1
    fi

    elf_file=$1
    if [ ! -f $elf_file ]; then
        echo "*** ERROR: file $elf_file does not exist"
        return 1
    fi

    rm -f $elf_file.lst

    echo "Generating $elf_file.lst ..."
    riscv64-unknown-elf-objdump -dSstl $elf_file > $elf_file.lst

    if [ ! -f $elf_file.lst ]; then
        echo "*** ERROR: file $elf_file.lst not created"
        return 1;
    fi
}

function gen_lst_arm
{
    typeset elf_file
    typeset usage_msg

    usage_msg="Usage: gen_lst <elf file>"

    if [ $# != 1 ]; then
        echo $usage_msg
        return 1
    fi

    elf_file=$1
    if [ ! -f $elf_file ]; then
        echo "*** ERROR: file $elf_file does not exist"
        return 1
    fi

    rm -f $elf_file.lst

    echo "Generating $elf_file.lst ..."
    arm-none-eabi-objdump -dSstl $elf_file > $elf_file.lst

    if [ ! -f $elf_file.lst ]; then
        echo "*** ERROR: file $elf_file.lst not created"
        return 1;
    fi
}

export ESPTOOL_DIR=/home/jgrivera/.espressif/python_env/idf5.3_py3.8_env/bin/

function gen_esp32c3_bin
{
    typeset elf_file
    typeset usage_msg

    usage_msg="Usage: gen_esp32c3_bin <elf file>"

    if [ $# != 1 ]; then
        echo $usage_msg
        return 1
    fi

    elf_file=$1
    if [ ! -f $elf_file ]; then
        echo "*** ERROR: file $elf_file does not exist"
        return 1
    fi

    $ESPTOOL_DIR/esptool.py --chip esp32c3 \
       elf2image --flash_mode dio --flash_freq 80m --flash_size 2MB \
       $elf_file
       #-o $elf_file.bin $elf_file
    # --elf-sha256-offset 0xb0 --min-rev 3 --min-rev-full 3 --max-rev-full 199 \
}

function gen_esp32p4_bin
{
    typeset elf_file
    typeset usage_msg

    usage_msg="Usage: gen_esp32p4_bin <elf file>"

    if [ $# != 1 ]; then
        echo $usage_msg
        return 1
    fi

    elf_file=$1
    if [ ! -f $elf_file ]; then
        echo "*** ERROR: file $elf_file does not exist"
        return 1
    fi

    $ESPTOOL_DIR/esptool.py --chip esp32p4 \
       elf2image --flash-mode dio --flash-freq 80m --flash-size 2MB \
       $elf_file
       #-o $elf_file.bin $elf_file
    # --elf-sha256-offset 0xb0 --min-rev 3 --min-rev-full 3 --max-rev-full 199 \
}

function flash_esp32c3_app
{
    typeset bin_file
    typeset tty_dev
    typeset usage_msg

    usage_msg="Usage: flash_esp32c3 <bin file> </dev/ttyXXX>"

    if [ $# != 2 ]; then
        echo $usage_msg
        return 1
    fi

    bin_file=$1
    tty_dev=$2
    if [ ! -f $bin_file ]; then
        echo "*** ERROR: file $bin_file does not exist"
        return 1
    fi

   # Flash App image on ESPC32-C3 flash:
   #$ESPTOOL_DIR/esptool.py --chip esp32c3 -p $tty_dev -b 460800 \
   esptool.py --chip esp32c3 -p $tty_dev -b 460800 \
      --before=default_reset --after=hard_reset write_flash \
      --flash_mode dio --flash_freq 80m --flash_size 2MB 0x10000 \
       $bin_file
}

function flash_esp32c3
{
    typeset bin_file
    typeset tty_dev
    typeset usage_msg

    usage_msg="Usage: flash_esp32c3 <bin file> </dev/ttyXXX>"

    if [ $# != 2 ]; then
        echo $usage_msg
        return 1
    fi

    bin_file=$1
    tty_dev=$2
    if [ ! -f $bin_file ]; then
        echo "*** ERROR: file $bin_file does not exist"
        return 1
    fi

   # Flash App image on ESPC32-C3 flash:
   #$ESPTOOL_DIR/esptool.py --chip esp32c3 -p $tty_dev -b 460800 \
   esptool.py --chip esp32c3 -p $tty_dev -b 460800 \
      --before=default_reset --after=hard_reset write_flash \
      --flash_mode dio --flash_freq 80m --flash_size 2MB 0x00000 \
       $bin_file
}

function flash_esp32c6
{
    typeset bin_file
    typeset tty_dev
    typeset usage_msg

    usage_msg="Usage: flash_esp32c6 <bin file> </dev/ttyXXX>"

    if [ $# != 2 ]; then
        echo $usage_msg
        return 1
    fi

    bin_file=$1
    tty_dev=$2
    if [ ! -f $bin_file ]; then
        echo "*** ERROR: file $bin_file does not exist"
        return 1
    fi

   # Flash App image on ESPC32-C6 flash:
   #$ESPTOOL_DIR/esptool.py --chip esp32c6 -p $tty_dev -b 460800 \
   esptool.py --chip esp32c6 -p $tty_dev -b 460800 \
      --before=default_reset --after=hard_reset write_flash \
      --flash_mode dio --flash_freq 80m --flash_size 2MB 0x00000 \
       $bin_file
}

function flash_esp32p4
{
    typeset bin_file
    typeset tty_dev
    typeset usage_msg

    usage_msg="Usage: flash_esp32p4 <bin file> </dev/ttyXXX>"

    if [ $# != 2 ]; then
        echo $usage_msg
        return 1
    fi

    bin_file=$1
    tty_dev=$2
    if [ ! -f $bin_file ]; then
        echo "*** ERROR: file $bin_file does not exist"
        return 1
    fi

   # Flash App image on ESPC32-C3 flash:
   #$ESPTOOL_DIR/esptool.py --chip esp32c3 -p $tty_dev -b 460800 \
   esptool --chip esp32p4 -p $tty_dev -b 460800 \
      --before=default-reset --after=hard-reset write-flash \
      --flash-mode dio --flash-freq 80m --flash-size 2MB 0x00000 \
       $bin_file
}

function flash_raspberry4
{
    typeset bin_file
    typeset tty_dev
    typeset usage_msg

    usage_msg="Usage: $FUNCNAME <bin file>"

    if [ $# != 1 ]; then
        echo $usage_msg
        return 1
    fi

    bin_file=$1
    if [ ! -f $bin_file ]; then
        echo "*** ERROR: file $bin_file does not exist"
        return 1
    fi

   # Flash App image on SD card:
   cp $bin_file /Volumes/bootfs/kernel8.img
   sync
}

function send_bin_over_uart {
   typeset bin_file
   typeset tty_port

   if [ $# != 2 ]; then
        echo "Usage: $FUNCNAME <bin file> <tty port>"
        return 1
   fi

   bin_file=$1
   tty_port=$2
   stty -f $tty_port 115200  #configure to the baud rate of the embedded system
   #lsx --xmodem --binary $bin_file > $tty_port < $tty_port
   ~/my-projects/aarch64_bare_metal_ada/uart_boot_loader_client/bin/uart_boot_loader_client $bin_file > $tty_port < $tty_port
}

function my_uart {
   typeset tty_port

   if [ $# != 1 ]; then
        echo "Usage: $FUNCNAME <tty port>"
        return 1
   fi

   tty_port=$1

   #picocom -b 115200 --send-cmd="lsx -vv --xmodem --binary" --receive-cmd="lrx -vv" $tty_port
   picocom -b 115200 --send-cmd="$HOME/my-projects/uart_boot_loader/uart_boot_loader_client/bin/uart_boot_loader_client" $tty_port
}

. ~/my-projects/third-party/alire/scripts/alr-completion.bash
