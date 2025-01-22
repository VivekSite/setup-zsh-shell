#!/bin/bash

# Define variables
SCRIPT_DIR=$(pwd)
POWERLEVEL10K_DIR="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
ZSH_PLUGIN_DIR="$HOME/.oh-my-zsh/custom/plugins"
ZSHRC_FILE="$HOME/.zshrc"
CUSTOM_COMMENT="#Custom Aliases Added By User"




if [ ! -f "$SCRIPT_DIR/utils.sh" ]; then
  echo "$SCRIPT_DIR/utils.sh file not found!"
  exit 1
fi

source "$SCRIPT_DIR/utils.sh"




# update the system deps
update_system



# Function to install Powerlevel10k
install_powerlevel10k() {
  if [ -d "$POWERLEVEL10K_DIR" ]; then
    echo "Powerlevel10k theme already installed!"
  else
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    update_or_add_variable "ZSH_THEME" "powerlevel10k/powerlevel10k"
  fi
}



# Function to install Oh My Zsh
install_oh_my_zsh() {
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}



# Function to change the default shell to Zsh
set_default_shell() {
  echo "Setting Zsh as the default shell..."
  chsh -s $(which zsh)
}



# Install zsh-autosuggestions plugin
install_zsh_autosuggestions() {
  if [ -d "$ZSH_PLUGIN_DIR/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions already installed!"
  else
    echo "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    add_zsh_plugin "zsh-autosuggestions"
  fi
}



# Install zsh-syntax-highlighting plugin
install_zsh_syntax_highlighting() {
  if [ -d "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting" ]; then
    echo "zsh-syntax-highlighting already installed!"
  else
    echo "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    add_zsh_plugin "zsh-syntax-highlighting"
  fi
}



# Define aliases as key-value pairs in an array
declare -A ALIASES=(
  ["c"]="clear"
  ["e"]="exit"
  ["vim"]="nvim"
  ["ch"]="history -c"
  ["rmd"]="rm -rf"
  ["ll"]="ls -l"
  ["la"]="ls -a"
  ["lh"]="ls -lah"
  ["l"]="ls -la"
  ["gits"]="git status"
  ["gitb"]="git branch"
  ["gitc"]="git checkout"
  ["gitr"]="git rebase"
)

# Function to add aliases if not present
add_aliases() {
  # Ensure the custom comment exists in the .zshrc file
  if ! grep -qFx "$CUSTOM_COMMENT" "$ZSHRC_FILE"; then
    echo "$CUSTOM_COMMENT" >> "$ZSHRC_FILE"
  fi

  # Loop through aliases
  for key in "${!ALIASES[@]}"; do
    alias_line="alias $key='${ALIASES[$key]}'"
    if grep -qFx "$alias_line" "$ZSHRC_FILE"; then
      echo "Alias '$key' already present in $ZSHRC_FILE."
    else
      echo "Adding alias '$key' to $ZSHRC_FILE."
      echo "$alias_line" >> "$ZSHRC_FILE"
    fi
  done

  echo "All aliases processed."
}



# Main script execution
echo "Starting Zsh and Powerlevel10k installation script..."

# Step 1: Install Zsh
install_zsh

# Step 2: Install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh is already installed. Skipping..."
else
  install_oh_my_zsh
fi

# Step 3: Install Powerlevel10k
install_powerlevel10k

# Step 4: Install Zsh plugins
install_zsh_autosuggestions
install_zsh_syntax_highlighting

# Step 5: Set Zsh as the default shell
set_default_shell
add_aliases

echo "Installation complete! Open a new terminal or run 'zsh' to start using it."
echo "You can configure Powerlevel10k by running 'p10k configure'."
