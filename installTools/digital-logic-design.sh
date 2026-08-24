#!/bin/bash

TOOLS_PATH="${DIGITAL_LOGIC_INSTALL_ROOT:-$HOME/gitPackages/digital-logic-design-tools}"
CACHE_PATH="${DIGITAL_LOGIC_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/digital-logic-design}"
LAUNCHER_PATH="${DIGITAL_LOGIC_LAUNCHER_PATH:-$HOME/.local/bin/digital-logic-design.sh}"

OSS_CAD_SUITE_VERSION=2026-07-24
OSS_CAD_SUITE_FILE=oss-cad-suite-linux-x64-20260724.tgz
OSS_CAD_SUITE_URL=https://github.com/YosysHQ/oss-cad-suite-build/releases/download/$OSS_CAD_SUITE_VERSION/$OSS_CAD_SUITE_FILE
OSS_CAD_SUITE_SHA256=ed363f93d6f5303c5cb8ecfb79b3f4fee7b40b958ad5f293c8c66906d5ffc14a
OSS_CAD_SUITE_PATH=$TOOLS_PATH/oss-cad-suite-$OSS_CAD_SUITE_VERSION

VERIBLE_VERSION=v0.0-4084-gf3e4d98b
VERIBLE_FILE=verible-$VERIBLE_VERSION-linux-static-x86_64.tar.gz
VERIBLE_URL=https://github.com/chipsalliance/verible/releases/download/$VERIBLE_VERSION/$VERIBLE_FILE
VERIBLE_SHA256=9f9be876fd9242274ac43f8c379a888aaa85fd99493783d0293b07474e2ccc67
VERIBLE_PATH=$TOOLS_PATH/verible-$VERIBLE_VERSION

DIGITAL_VERSION=v0.31
DIGITAL_FILE=Digital-$DIGITAL_VERSION.zip
DIGITAL_URL=https://github.com/hneemann/Digital/releases/download/$DIGITAL_VERSION/Digital.zip
DIGITAL_SHA256=12f014c8b99140554f8f7464ebc771bbe3de6af39c83c20463492bcb892afc69
DIGITAL_PATH=$TOOLS_PATH/digital-$DIGITAL_VERSION

LITE_XL_INSTALLER_URL=https://raw.githubusercontent.com/johnnycubides/swissknife/master/bash/installs/lite-xl/install-all.bash
LITE_XL_INSTALLER_FILE=lite-xl-install-all.bash
LITE_XL_PATH=$TOOLS_PATH/lite-xl/lite-xl

NETLISTSVG_VERSION=1.0.2
NETLISTSVG_PATH=$TOOLS_PATH/netlistsvg-$NETLISTSVG_VERSION

QUCS_S_VERSION=26.1.1
QUCS_S_FILE=Qucs-S-$QUCS_S_VERSION-linux-x86_64.AppImage
QUCS_S_URL=https://github.com/ra3xdh/qucs_s/releases/download/$QUCS_S_VERSION/$QUCS_S_FILE
QUCS_S_SHA256=a86ab951118bfdffc8acfda8893cde0e2aeedc7129cc73978ae7d16761ec5cb5
QUCS_S_PATH=$TOOLS_PATH/qucs-s-$QUCS_S_VERSION

LITEX_VERSION=2026.04
LITEX_SETUP_FILE=litex_setup.py
LITEX_SETUP_URL=https://raw.githubusercontent.com/enjoy-digital/litex/$LITEX_VERSION/$LITEX_SETUP_FILE
LITEX_SETUP_SHA256=1a63a8c27b3e50c5b9858255edeb6b7e4ece80787bdcf10ff44b8267e5972381
LITEX_REPOS_FILE=litex_repos.py
LITEX_REPOS_URL=https://raw.githubusercontent.com/enjoy-digital/litex/$LITEX_VERSION/$LITEX_REPOS_FILE
LITEX_REPOS_SHA256=4d63f8a192656e3e8aae6a0e3543b0a977066fe3b2101aaf9ea18967e89fdc19
LITEX_PATH=$TOOLS_PATH/litex-$LITEX_VERSION
LITEX_VENV_PATH=$LITEX_PATH/venv
LITEX_DEFAULT_CONFIG=${LITEX_CONFIG:-standard}
LITEX_SETUPTOOLS_VERSION=80.9.0
LITEX_WHEEL_VERSION=0.45.1
LITEX_MESON_VERSION=1.12.0

dependencies() {
  sudo apt update
  sudo apt install \
    build-essential \
    coreutils \
    curl \
    default-jre \
    desktop-file-utils \
    gcc \
    gcc-riscv64-unknown-elf \
    git \
    ngspice \
    picocom \
    pulseview \
    python3-venv \
    shared-mime-info \
    sigrok-firmware-fx2lafw \
    tar \
    unzip \
    wget \
    -y || return 1

  if command -v node >/dev/null 2>&1; then
    echo "Using existing Node.js: $(node --version)"

    if ! command -v npm >/dev/null 2>&1; then
      echo "Node.js is installed, but npm is not available." >&2
      echo "Install npm using the same Node.js installation method." >&2
      return 1
    fi

    echo "Using existing npm: $(npm --version)"
    return 0
  fi

  sudo apt install nodejs npm -y
}

oss_cad_suite() {
  local ARCHIVE=$CACHE_PATH/$OSS_CAD_SUITE_FILE
  local TEMP_PATH

  echo "Installing OSS CAD Suite $OSS_CAD_SUITE_VERSION"

  if [[ -f "$OSS_CAD_SUITE_PATH/environment" ]]; then
    echo "Already installed: $OSS_CAD_SUITE_PATH"
    return 0
  fi

  if [[ -e "$OSS_CAD_SUITE_PATH" ]]; then
    echo "Incomplete installation: $OSS_CAD_SUITE_PATH" >&2
    echo "Remove that directory and run the command again." >&2
    return 1
  fi

  mkdir -p "$TOOLS_PATH" "$CACHE_PATH" || return 1

  if [[ -f "$ARCHIVE" ]] &&
    ! printf '%s  %s\n' "$OSS_CAD_SUITE_SHA256" "$ARCHIVE" |
      sha256sum --check --status
  then
    echo "Removing invalid cached archive: $ARCHIVE"
    rm -f "$ARCHIVE"
  fi

  if [[ ! -f "$ARCHIVE" ]]; then
    curl \
      --fail \
      --location \
      --progress-bar \
      "$OSS_CAD_SUITE_URL" \
      --output "$ARCHIVE.part" || return 1
    mv "$ARCHIVE.part" "$ARCHIVE" || return 1
  else
    echo "Using cached archive: $ARCHIVE"
  fi

  if ! printf '%s  %s\n' "$OSS_CAD_SUITE_SHA256" "$ARCHIVE" |
    sha256sum --check --status
  then
    echo "Checksum verification failed: $ARCHIVE" >&2
    rm -f "$ARCHIVE"
    return 1
  fi

  TEMP_PATH=$(mktemp -d "$TOOLS_PATH/.oss-cad-suite.XXXXXX") || return 1

  if ! tar -xzf "$ARCHIVE" -C "$TEMP_PATH"; then
    rm -rf "$TEMP_PATH"
    return 1
  fi

  if [[ ! -f "$TEMP_PATH/oss-cad-suite/environment" ]]; then
    echo "Unexpected archive structure: $ARCHIVE" >&2
    rm -rf "$TEMP_PATH"
    return 1
  fi

  mv "$TEMP_PATH/oss-cad-suite" "$OSS_CAD_SUITE_PATH" || {
    rm -rf "$TEMP_PATH"
    return 1
  }

  rmdir "$TEMP_PATH"
  echo "Installed: $OSS_CAD_SUITE_PATH"
}

verible() {
  local ARCHIVE=$CACHE_PATH/$VERIBLE_FILE
  local TEMP_PATH

  echo "Installing Verible $VERIBLE_VERSION"

  if [[ -f "$VERIBLE_PATH/bin/verible-verilog-lint" ]]; then
    echo "Already installed: $VERIBLE_PATH"
    return 0
  fi

  if [[ -e "$VERIBLE_PATH" ]]; then
    echo "Incomplete installation: $VERIBLE_PATH" >&2
    echo "Remove that directory and run the command again." >&2
    return 1
  fi

  mkdir -p "$TOOLS_PATH" "$CACHE_PATH" || return 1

  if [[ -f "$ARCHIVE" ]] &&
    ! printf '%s  %s\n' "$VERIBLE_SHA256" "$ARCHIVE" |
      sha256sum --check --status
  then
    echo "Removing invalid cached archive: $ARCHIVE"
    rm -f "$ARCHIVE"
  fi

  if [[ ! -f "$ARCHIVE" ]]; then
    curl \
      --fail \
      --location \
      --progress-bar \
      "$VERIBLE_URL" \
      --output "$ARCHIVE.part" || return 1
    mv "$ARCHIVE.part" "$ARCHIVE" || return 1
  else
    echo "Using cached archive: $ARCHIVE"
  fi

  if ! printf '%s  %s\n' "$VERIBLE_SHA256" "$ARCHIVE" |
    sha256sum --check --status
  then
    echo "Checksum verification failed: $ARCHIVE" >&2
    rm -f "$ARCHIVE"
    return 1
  fi

  TEMP_PATH=$(mktemp -d "$TOOLS_PATH/.verible.XXXXXX") || return 1

  if ! tar -xzf "$ARCHIVE" -C "$TEMP_PATH"; then
    rm -rf "$TEMP_PATH"
    return 1
  fi

  if [[ ! -f \
    "$TEMP_PATH/verible-$VERIBLE_VERSION/bin/verible-verilog-lint" \
  ]]; then
    echo "Unexpected archive structure: $ARCHIVE" >&2
    rm -rf "$TEMP_PATH"
    return 1
  fi

  mv "$TEMP_PATH/verible-$VERIBLE_VERSION" "$VERIBLE_PATH" || {
    rm -rf "$TEMP_PATH"
    return 1
  }

  rmdir "$TEMP_PATH"
  echo "Installed: $VERIBLE_PATH"
}

digital() {
  local ARCHIVE=$CACHE_PATH/$DIGITAL_FILE
  local TEMP_PATH

  echo "Installing Digital $DIGITAL_VERSION"

  if [[ -f "$DIGITAL_PATH/Digital.jar" ]]; then
    ln -sfn Digital.sh "$DIGITAL_PATH/digital" || return 1
    echo "Already installed: $DIGITAL_PATH"
    return 0
  fi

  if [[ -e "$DIGITAL_PATH" ]]; then
    echo "Incomplete installation: $DIGITAL_PATH" >&2
    echo "Remove that directory and run the command again." >&2
    return 1
  fi

  mkdir -p "$TOOLS_PATH" "$CACHE_PATH" || return 1

  if [[ -f "$ARCHIVE" ]] &&
    ! printf '%s  %s\n' "$DIGITAL_SHA256" "$ARCHIVE" |
      sha256sum --check --status
  then
    echo "Removing invalid cached archive: $ARCHIVE"
    rm -f "$ARCHIVE"
  fi

  if [[ ! -f "$ARCHIVE" ]]; then
    curl \
      --fail \
      --location \
      --progress-bar \
      "$DIGITAL_URL" \
      --output "$ARCHIVE.part" || return 1
    mv "$ARCHIVE.part" "$ARCHIVE" || return 1
  else
    echo "Using cached archive: $ARCHIVE"
  fi

  if ! printf '%s  %s\n' "$DIGITAL_SHA256" "$ARCHIVE" |
    sha256sum --check --status
  then
    echo "Checksum verification failed: $ARCHIVE" >&2
    rm -f "$ARCHIVE"
    return 1
  fi

  TEMP_PATH=$(mktemp -d "$TOOLS_PATH/.digital.XXXXXX") || return 1

  if ! unzip -q "$ARCHIVE" -d "$TEMP_PATH"; then
    rm -rf "$TEMP_PATH"
    return 1
  fi

  if [[ ! -f "$TEMP_PATH/Digital/Digital.jar" ]]; then
    echo "Unexpected archive structure: $ARCHIVE" >&2
    rm -rf "$TEMP_PATH"
    return 1
  fi

  mv "$TEMP_PATH/Digital" "$DIGITAL_PATH" || {
    rm -rf "$TEMP_PATH"
    return 1
  }

  rmdir "$TEMP_PATH"
  ln -sfn Digital.sh "$DIGITAL_PATH/digital" || return 1
  echo "Installed: $DIGITAL_PATH"
}

lite_xl() {
  local INSTALLER=$CACHE_PATH/$LITE_XL_INSTALLER_FILE

  echo "Installing Lite XL"

  if [[ -x "$LITE_XL_PATH/lite-xl" ]]; then
    echo "Already installed: $LITE_XL_PATH"
    return 0
  fi

  mkdir -p "$TOOLS_PATH" "$CACHE_PATH" || return 1

  curl \
    --fail \
    --location \
    --progress-bar \
    "$LITE_XL_INSTALLER_URL" \
    --output "$INSTALLER.part" || return 1

  mv "$INSTALLER.part" "$INSTALLER" || return 1

  LITE_XL_PACKAGES_PATH="$TOOLS_PATH" bash "$INSTALLER" all
}

netlistsvg() {
  local TEMP_PATH

  echo "Installing Netlistsvg $NETLISTSVG_VERSION"

  if [[ -x "$NETLISTSVG_PATH/node_modules/.bin/netlistsvg" ]]; then
    echo "Already installed: $NETLISTSVG_PATH"
    return 0
  fi

  if [[ -e "$NETLISTSVG_PATH" ]]; then
    echo "Incomplete installation: $NETLISTSVG_PATH" >&2
    echo "Remove that directory and run the command again." >&2
    return 1
  fi

  mkdir -p "$TOOLS_PATH" "$CACHE_PATH" || return 1
  TEMP_PATH=$(mktemp -d "$TOOLS_PATH/.netlistsvg.XXXXXX") || return 1

  if ! npm install \
    --prefix "$TEMP_PATH" \
    --no-audit \
    --no-fund \
    --no-package-lock \
    --omit=dev \
    "netlistsvg@$NETLISTSVG_VERSION"
  then
    rm -rf "$TEMP_PATH"
    return 1
  fi

  if [[ ! -x "$TEMP_PATH/node_modules/.bin/netlistsvg" ]]; then
    echo "Netlistsvg executable was not found after installation" >&2
    rm -rf "$TEMP_PATH"
    return 1
  fi

  mv "$TEMP_PATH" "$NETLISTSVG_PATH" || {
    rm -rf "$TEMP_PATH"
    return 1
  }

  echo "Installed: $NETLISTSVG_PATH"
}

qucs_s() {
  local ARCHIVE=$CACHE_PATH/$QUCS_S_FILE
  local TEMP_PATH

  echo "Installing Qucs-S $QUCS_S_VERSION"

  if [[ -x "$QUCS_S_PATH/qucs-s" ]]; then
    echo "Already installed: $QUCS_S_PATH"
    return 0
  fi

  if [[ -e "$QUCS_S_PATH" ]]; then
    echo "Incomplete installation: $QUCS_S_PATH" >&2
    echo "Remove that directory and run the command again." >&2
    return 1
  fi

  mkdir -p "$TOOLS_PATH" "$CACHE_PATH" || return 1

  if [[ -f "$ARCHIVE" ]] &&
    ! printf '%s  %s\n' "$QUCS_S_SHA256" "$ARCHIVE" |
      sha256sum --check --status
  then
    echo "Removing invalid cached archive: $ARCHIVE"
    rm -f "$ARCHIVE"
  fi

  if [[ ! -f "$ARCHIVE" ]]; then
    curl \
      --fail \
      --location \
      --progress-bar \
      "$QUCS_S_URL" \
      --output "$ARCHIVE.part" || return 1
    mv "$ARCHIVE.part" "$ARCHIVE" || return 1
  else
    echo "Using cached archive: $ARCHIVE"
  fi

  if ! printf '%s  %s\n' "$QUCS_S_SHA256" "$ARCHIVE" |
    sha256sum --check --status
  then
    echo "Checksum verification failed: $ARCHIVE" >&2
    rm -f "$ARCHIVE"
    return 1
  fi

  chmod +x "$ARCHIVE" || return 1
  TEMP_PATH=$(mktemp -d "$TOOLS_PATH/.qucs-s.XXXXXX") || return 1

  if ! (
    cd "$TEMP_PATH" || exit 1
    "$ARCHIVE" --appimage-extract >/dev/null
  ); then
    rm -rf "$TEMP_PATH"
    return 1
  fi

  if [[ ! -x "$TEMP_PATH/squashfs-root/AppRun" ]]; then
    echo "Unexpected AppImage structure: $ARCHIVE" >&2
    rm -rf "$TEMP_PATH"
    return 1
  fi

  mv "$TEMP_PATH/squashfs-root" "$TEMP_PATH/app" || {
    rm -rf "$TEMP_PATH"
    return 1
  }
  ln -s app/AppRun "$TEMP_PATH/qucs-s" || {
    rm -rf "$TEMP_PATH"
    return 1
  }
  ln -s app/AppRun "$TEMP_PATH/qucs" || {
    rm -rf "$TEMP_PATH"
    return 1
  }

  mv "$TEMP_PATH" "$QUCS_S_PATH" || {
    rm -rf "$TEMP_PATH"
    return 1
  }

  echo "Installed: $QUCS_S_PATH"
}

litex() {
  local CONFIG=${1:-$LITEX_DEFAULT_CONFIG}
  local SETUP_ARCHIVE=$CACHE_PATH/$LITEX_SETUP_FILE-$LITEX_VERSION
  local REPOS_ARCHIVE=$CACHE_PATH/$LITEX_REPOS_FILE-$LITEX_VERSION

  if [[ "$CONFIG" != standard && "$CONFIG" != full ]]; then
    echo "Unknown LiteX configuration: $CONFIG" >&2
    echo "Use standard or full." >&2
    return 1
  fi

  echo "Installing LiteX $LITEX_VERSION ($CONFIG)"

  if {
    [[ "$CONFIG" == standard && -f "$LITEX_PATH/.installed-standard" ]] ||
      [[ -f "$LITEX_PATH/.installed-full" ]]
  } && [[ -x "$LITEX_VENV_PATH/bin/litex_sim" ]] &&
    [[ -x "$LITEX_VENV_PATH/bin/meson" ]]
  then
    echo "Already installed: $LITEX_PATH ($CONFIG)"
    return 0
  fi

  mkdir -p "$TOOLS_PATH" "$CACHE_PATH" "$LITEX_PATH" || return 1

  if [[ -f "$SETUP_ARCHIVE" ]] &&
    ! printf '%s  %s\n' "$LITEX_SETUP_SHA256" "$SETUP_ARCHIVE" |
      sha256sum --check --status
  then
    echo "Removing invalid cached file: $SETUP_ARCHIVE"
    rm -f "$SETUP_ARCHIVE"
  fi

  if [[ ! -f "$SETUP_ARCHIVE" ]]; then
    curl \
      --fail \
      --location \
      --progress-bar \
      "$LITEX_SETUP_URL" \
      --output "$SETUP_ARCHIVE.part" || return 1
    mv "$SETUP_ARCHIVE.part" "$SETUP_ARCHIVE" || return 1
  else
    echo "Using cached file: $SETUP_ARCHIVE"
  fi

  if ! printf '%s  %s\n' "$LITEX_SETUP_SHA256" "$SETUP_ARCHIVE" |
    sha256sum --check --status
  then
    echo "Checksum verification failed: $SETUP_ARCHIVE" >&2
    return 1
  fi

  if [[ -f "$REPOS_ARCHIVE" ]] &&
    ! printf '%s  %s\n' "$LITEX_REPOS_SHA256" "$REPOS_ARCHIVE" |
      sha256sum --check --status
  then
    echo "Removing invalid cached file: $REPOS_ARCHIVE"
    rm -f "$REPOS_ARCHIVE"
  fi

  if [[ ! -f "$REPOS_ARCHIVE" ]]; then
    curl \
      --fail \
      --location \
      --progress-bar \
      "$LITEX_REPOS_URL" \
      --output "$REPOS_ARCHIVE.part" || return 1
    mv "$REPOS_ARCHIVE.part" "$REPOS_ARCHIVE" || return 1
  else
    echo "Using cached file: $REPOS_ARCHIVE"
  fi

  if ! printf '%s  %s\n' "$LITEX_REPOS_SHA256" "$REPOS_ARCHIVE" |
    sha256sum --check --status
  then
    echo "Checksum verification failed: $REPOS_ARCHIVE" >&2
    return 1
  fi

  cp "$SETUP_ARCHIVE" "$LITEX_PATH/$LITEX_SETUP_FILE" || return 1
  cp "$REPOS_ARCHIVE" "$LITEX_PATH/$LITEX_REPOS_FILE" || return 1
  chmod +x "$LITEX_PATH/$LITEX_SETUP_FILE" || return 1

  if [[ ! -x "$LITEX_VENV_PATH/bin/python3" ]]; then
    /usr/bin/python3 -m venv "$LITEX_VENV_PATH" || return 1
  fi

  "$LITEX_VENV_PATH/bin/python3" -m pip install \
    "setuptools==$LITEX_SETUPTOOLS_VERSION" \
    "wheel==$LITEX_WHEEL_VERSION" \
    "meson==$LITEX_MESON_VERSION" || return 1

  (
    cd "$LITEX_PATH" || exit 1

    # Keep the verified release files and HTTPS clone URLs. LiteX uses the
    # GITHUB_ACTIONS flag to prevent --dev from switching clones to SSH.
    GITHUB_ACTIONS=true "$LITEX_VENV_PATH/bin/python3" \
      "$LITEX_PATH/$LITEX_SETUP_FILE" \
      --dev \
      --init \
      --install \
      --config="$CONFIG" \
      --tag="$LITEX_VERSION"
  ) || return 1

  "$LITEX_VENV_PATH/bin/python3" -c 'import litex, migen' || return 1

  touch "$LITEX_PATH/.installed-$CONFIG" || return 1
  echo "Installed: $LITEX_PATH ($CONFIG)"
}

launcher() {
  local SCRIPT_PATH
  local CURRENT_TARGET

  SCRIPT_PATH=$(readlink -f "${BASH_SOURCE[0]}") || return 1

  if [[ -L "$LAUNCHER_PATH" ]]; then
    CURRENT_TARGET=$(readlink -f "$LAUNCHER_PATH") || return 1

    if [[ "$CURRENT_TARGET" == "$SCRIPT_PATH" ]]; then
      echo "Already linked: $LAUNCHER_PATH"
      return 0
    fi

    echo "The launcher points to another file: $LAUNCHER_PATH" >&2
    echo "Remove it and run the command again if you want to replace it." >&2
    return 1
  fi

  if [[ -e "$LAUNCHER_PATH" ]]; then
    echo "A regular file already exists: $LAUNCHER_PATH" >&2
    echo "Move or remove it and run the command again." >&2
    return 1
  fi

  mkdir -p "$(dirname "$LAUNCHER_PATH")" || return 1
  ln -s "$SCRIPT_PATH" "$LAUNCHER_PATH" || return 1
  echo "Linked: $LAUNCHER_PATH -> $SCRIPT_PATH"
}

install() {
  oss_cad_suite || return 1
  verible || return 1
  netlistsvg || return 1
  digital || return 1
  qucs_s || return 1
  lite_xl || return 1
  litex "$LITEX_DEFAULT_CONFIG" || return 1
  launcher || return 1
}

activate() {
  if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "Source the script to activate the tools:" >&2
    echo "  source ./digital-logic-design.sh activate" >&2
    return 1
  fi

  if [[ ! -f "$OSS_CAD_SUITE_PATH/environment" ]]; then
    echo "OSS CAD Suite is not installed. Run ./digital-logic-design.sh install first." >&2
    return 1
  fi

  if [[ ! -f "$VERIBLE_PATH/bin/verible-verilog-lint" ]]; then
    echo "Verible is not installed. Run ./digital-logic-design.sh install first." >&2
    return 1
  fi

  if [[ ! -f "$DIGITAL_PATH/Digital.jar" ]]; then
    echo "Digital is not installed. Run ./digital-logic-design.sh install first." >&2
    return 1
  fi

  if [[ ! -x "$NETLISTSVG_PATH/node_modules/.bin/netlistsvg" ]]; then
    echo "Netlistsvg is not installed. Run ./digital-logic-design.sh install first." >&2
    return 1
  fi

  if [[ ! -x "$QUCS_S_PATH/qucs-s" ]]; then
    echo "Qucs-S is not installed. Run ./digital-logic-design.sh install first." >&2
    return 1
  fi

  if [[ ! -x "$LITEX_VENV_PATH/bin/litex_sim" ]]; then
    echo "LiteX is not installed. Run ./digital-logic-design.sh litex standard first." >&2
    return 1
  fi

  source "$OSS_CAD_SUITE_PATH/environment" || return 1

  OSS_CAD_SUITE_ROOT=$OSS_CAD_SUITE_PATH
  VERIBLE_ROOT=$VERIBLE_PATH
  DIGITAL_ROOT=$DIGITAL_PATH
  NETLISTSVG_ROOT=$NETLISTSVG_PATH
  QUCS_S_ROOT=$QUCS_S_PATH
  LITEX_ROOT=$LITEX_PATH
  LITEX_VENV=$LITEX_VENV_PATH
  LITEX_PYTHON=$LITEX_VENV_PATH/bin/python3

  export OSS_CAD_SUITE_ROOT VERIBLE_ROOT DIGITAL_ROOT
  export NETLISTSVG_ROOT QUCS_S_ROOT LITEX_ROOT LITEX_VENV LITEX_PYTHON
  export PATH="$LITEX_VENV/bin:$QUCS_S_ROOT:$DIGITAL_ROOT:$NETLISTSVG_ROOT/node_modules/.bin:$VERIBLE_ROOT/bin:$PATH"

  echo "Activated OSS CAD Suite $OSS_CAD_SUITE_VERSION"
  echo "Activated Verible $VERIBLE_VERSION"
  echo "Activated Netlistsvg $NETLISTSVG_VERSION"
  echo "Activated Digital $DIGITAL_VERSION"
  echo "Activated Qucs-S $QUCS_S_VERSION"
  echo "Activated LiteX $LITEX_VERSION"
  echo "Run 'source ./digital-logic-design.sh deactivate' to restore the previous environment."
}

deactivate_tools() {
  if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "Source the script to deactivate the tools:" >&2
    echo "  source ./digital-logic-design.sh deactivate" >&2
    return 1
  fi

  if ! declare -F deactivate >/dev/null; then
    echo "The digital logic tools are not active in this terminal." >&2
    return 1
  fi

  deactivate
  unset OSS_CAD_SUITE_ROOT VERIBLE_ROOT DIGITAL_ROOT
  unset NETLISTSVG_ROOT QUCS_S_ROOT LITEX_ROOT LITEX_VENV LITEX_PYTHON
  hash -r 2>/dev/null
  echo "Digital logic tools deactivated."
}

all() {
  install || return 1
  activate || return 1
}

help() {
  echo "Arguments:"
  echo "  dependencies   Install Debian packages"
  echo "  oss_cad_suite  Install OSS CAD Suite, including GTKWave and Surfer"
  echo "  verible        Install Verible"
  echo "  netlistsvg     Install Netlistsvg"
  echo "  digital        Install Digital"
  echo "  qucs_s         Install Qucs-S"
  echo "  lite_xl        Install Lite XL and its configuration"
  echo "  litex          Install LiteX: standard (default) or full"
  echo "  launcher       Link this script into ~/.local/bin"
  echo "  install        Install all tools"
  echo "  activate       Activate all tools in the current terminal"
  echo "  deactivate     Deactivate all tools in the current terminal"
  echo "  all            Install and activate all tools"
  echo
  echo "Examples:"
  echo "  ./digital-logic-design.sh digital"
  echo "  ./digital-logic-design.sh qucs_s"
  echo "  ./digital-logic-design.sh lite_xl"
  echo "  ./digital-logic-design.sh litex standard"
  echo "  ./digital-logic-design.sh litex full"
  echo "  ./digital-logic-design.sh launcher"
  echo "  ./digital-logic-design.sh install"
  echo "  source ./digital-logic-design.sh activate"
  echo "  source ./digital-logic-design.sh deactivate"
  echo "  source ./digital-logic-design.sh all"
}

case "${1:-help}" in
  dependencies)
    dependencies
    ;;
  oss_cad_suite)
    oss_cad_suite
    ;;
  verible)
    verible
    ;;
  netlistsvg)
    netlistsvg
    ;;
  digital)
    digital
    ;;
  qucs_s)
    qucs_s
    ;;
  lite_xl)
    lite_xl
    ;;
  litex)
    litex "${2:-$LITEX_DEFAULT_CONFIG}"
    ;;
  launcher)
    launcher
    ;;
  install)
    install
    ;;
  activate)
    activate
    ;;
  deactivate)
    deactivate_tools
    ;;
  all)
    all
    ;;
  help)
    help
    ;;
  *)
    echo "Unknown argument: $1" >&2
    echo
    help
    false
    ;;
esac

STATUS=$?

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  unset -f \
    dependencies \
    oss_cad_suite \
    verible \
    netlistsvg \
    digital \
    qucs_s \
    lite_xl \
    litex \
    launcher \
    install \
    activate \
    deactivate_tools \
    all \
    help
  return "$STATUS"
fi

exit "$STATUS"
