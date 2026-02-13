# BRIEF: Justfile to install LiteX and Efinix tools and build gateware for TRION FPGA
#
# INSTRUCTIONS TO INSTALL JUST
#
# 1. curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# 2. Restart the terminal
# 3. cargo install just
#
# INSTRUCTIONS TO INSTALL LITEX AND EFINIX TOOLS
#
# 1. Download and install the Efinix toolchain. Please use the "Efinix 2025.1" version.
# 2. Set EFINITY_TOOLCHAIN_PATH with the path to the Efinix toolchain installation.
# 3. Set PACK_DIR with the path where LiteX will be installed.
# 4. Execute "just litex-install" to install LiteX.
# 5. Execute "just efinix-dependencies-install" to install the required dependencies and configuration.
#
# HOW TO USE
#
# BUILD GATEWARE
# just build: Builds the gateware from f, where f is the filename.
# You can change the value of f directly or provide the filename in the prompt,
# for example: just build f=name.py
#
# CONFIGURE TRION FPGA
# just config: Volatile configuration of the FPGA.
#
# just -l: Check for more options
#
# CONTEXT:
#
# lsb_release -a
# No LSB modules are available.
# Distributor ID: Debian
# Description:    Debian GNU/Linux trixie/sid
# Release:        n/a
# Codename:       trixie
#
# uname -a
# Linux catalejo 6.12.27-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.27-1 (2025-05-06) x86_64 GNU/Linux
#
# 2026-02-12
# Johnny

f := "base.py"
EFINITY_TOOLCHAIN_PATH := "/media/johnny/bruno/opt/efinity/2025.1"
PACK_DIR := "/media/johnny/bruno/gitPackages/"
LITEX_ENV_NAME := "litex_py_env"
LITEX_DIR := PACK_DIR + "litex-digital"
LITEX_ENV_ACT := ". " + PACK_DIR + LITEX_ENV_NAME + "/bin/activate &&"
BITSTREAM := "build/gateware/outflow/top.hex"
export LITEX_ENV_EFINITY := EFINITY_TOOLCHAIN_PATH
export EFXPGM_HOME := EFINITY_TOOLCHAIN_PATH + "/pgm/"
export EFINITY_HOME := EFINITY_TOOLCHAIN_PATH
export EFXDBG_HOME := EFINITY_TOOLCHAIN_PATH + "/debugger"
export EFXPT_HOME := EFINITY_TOOLCHAIN_PATH + "/pt"
export EFINITY_USER_DIR := "."
export EFINITY_USER_DIR_INI := "."

alias config := config-ram
alias b := make-gateware
alias build := make-gateware

# Make gateware
make-gateware:
    {{ LITEX_ENV_ACT }} python {{ f }}

# Config fpga (volatile)
config-ram:
    {{ LITEX_ENV_ACT }} python3 {{ EFXPGM_HOME }}bin/efx_pgm/ftdi_program.py {{ BITSTREAM }}  -m passive -b "Generic Board Profile Using FT2232H" --url ftdi://0x0403:0x6010/1

# Clean build dir
clean:
    rm -rf build/*

# Install tools
litex-install: check-install-dirs-existence
    mkdir -p {{ PACK_DIR }}
    cd {{ PACK_DIR }} && \
    python3 -m venv {{ LITEX_ENV_NAME }} && \
    {{ LITEX_ENV_ACT }} \
    mkdir -p {{ LITEX_DIR }} && cd {{ LITEX_DIR }} && \
    wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py && \
    chmod +x litex_setup.py && \
    ./litex_setup.py --init --install --config=full && \
    ./litex_setup.py --update && \
    deactivate

# verify directory existence
check-install-dirs-existence:
    #!/bin/bash
    if [ -d "{{ PACK_DIR }}{{ LITEX_ENV_NAME }}" ]; then
      echo "{{ PACK_DIR }}{{ LITEX_ENV_NAME }} exists, you must remove it manually"
      exit 1
    fi
    # rm -rf {{ PACK_DIR }}{{ LITEX_ENV_NAME }}
    if [ -d "{{ LITEX_DIR }}" ]; then
      echo "{{ LITEX_DIR }} exists, you must remove it manually"
      exit 1
    fi

# Install efinix config dependencies
efinix-dependencies-install:
    {{ LITEX_ENV_ACT }} pip install pyftdi pyspiflash xmlschema psutil daemoniker setproctitle PyQt6 protobuf grpcio tornado PyVCD

# Update litex
litex-update:
    cd {{ LITEX_DIR }} && \
    {{ LITEX_ENV_ACT }} ./litex_setup.py --update
