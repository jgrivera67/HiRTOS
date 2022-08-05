ALIRE_DIR=~/my-projects/third-party/alire
export PATH=$ALIRE_DIR/bin:/opt/gcc-12.0.1-aarch64/bin:$PATH
export PATH=$PATH:/Users/josegrivera/.config/alire/cache/dependencies/gnat_arm_elf_11.2.4_839811c8/bin::~/my-projects/third-party/gnatprove_11.2.3_454d37ad/bin:~/my-projects/third-party/gnatcov_22.0.1_a69a9af4/bin

export OS=macOS
export GPR_FILE=hirtos.gpr

alias v='gvim -U ide_env.vim'

. $ALIRE_DIR/scripts/alr-completion.bash
