#!/bin/bash

# Define variables
SCRIPT_DIR=$(pwd)
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_AUTOLOAD_DIR="$HOME/.local/share/nvim/site/autoload"
VIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
REPO_URL="https://github.com/VivekSite/configuration-file-nvim.git"
COC_DIR="$HOME/.config/nvim/plugged/coc.nvim"

if [ ! -f "$SCRIPT_DIR/utils.sh" ]; then
  echo "$SCRIPT_DIR/utils.sh file not found!"
  exit 1
fi

source "$SCRIPT_DIR/utils.sh"

# Detect the operating system and update packages
update_system

# Install vim-plug
check_package_installed "nvim"
if [ $? -ne 0 ]; then
  echo "Installing vim-plug..."
  mkdir -p "$NVIM_AUTOLOAD_DIR"
  curl -fLo "$NVIM_AUTOLOAD_DIR/plug.vim" --create-dirs "$VIM_PLUG_URL"
else
  echo "nvim already installed"
fi

# Clone the configuration repository
if [ ! -f "$NVIM_CONFIG_DIR/init.vim" ]; then
  echo "Cloning repository..."
  mkdir -p "$NVIM_CONFIG_DIR"
  cp "$SCRIPT_DIR/init.vim" "$NVIM_CONFIG_DIR/init.vim"
fi

# Install plugins
echo "Installing plugins..."
nvim +'PlugInstall --sync' +qa

# Build CoC for code completion
if [ -d "$COC_DIR" ]; then
  echo "Building CoC for code completion..."
  cd "$COC_DIR"
  npm install

  # Install CoC extensions
  echo "Installing CoC extensions..."
  nvim +'CocInstall -sync coc-clangd coc-tsserver coc-json coc-pyright' +qa
else
  echo "CoC.nvim was not installed correctly. Please check your init.vim file and try again."
fi

# Cleanup
echo "Cleaning up..."
if [ -f "$HOME/configuration-file-nvim" ]; then
  rm -rf "$HOME/configuration-file-nvim"
fi

echo "Setup complete! Open Neovim and enjoy your configuration."
