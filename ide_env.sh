ALIRE_DIR=/opt/alire
export PATH=$ALIRE_DIR/bin:~/my-projects/third-party/gnat_arm_elf_12.1.2_89ba9262/bin:~/my-projects/third-party/gnatprove_12.1.1_e1e1ce47/bin:/opt/tkdiff:/opt/fuzz/bin:/opt/arm-gnu-toolchain/bin:$PATH
#export PATH=$PATH:/Users/josegrivera/.config/alire/cache/dependencies/gnat_arm_elf_11.2.4_839811c8/bin::~/my-projects/third-party/gnatprove_11.2.3_454d37ad/bin:~/my-projects/third-party/gnatcov_22.0.1_a69a9af4/bin

#export OS=macOS

export GPR_FILE=hirtos.gpr
export ARMFVP_DIR=/opt/FVP_Base_AEMv8R/AEMv8R_base_pkg
export ARMFVP_BIN_PATH=$ARMFVP_DIR/models/Linux64_GCC-9.3
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ARMFVP_DIR/fmtplib

export GIT_EXTERNAL_DIFF=tkdiff

alias v='gvim -U ide_env.vim'

function run_fvp {
   typeset elf_file

   if [ $# != 1 ]; then
        echo "Usage: $FUNCNAME <elf file>"
        return 1
   fi

   elf_file=$1


   $ARMFVP_BIN_PATH/FVP_BaseR_AEMv8R \
           -C bp.pl011_uart0.uart_enable=1 \
           -C bp.pl011_uart0.baud_rate=115200 \
           -C cluster0.gicv3.SRE-EL2-enable-RAO=1 \
           -C cluster0.gicv3.cpuintf-mmap-access-level=2 \
	   --application $elf_file #--log ~/tmp/fvp-run.log
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

. ~/my-projects/third-party/alire/scripts/alr-completion.bash
